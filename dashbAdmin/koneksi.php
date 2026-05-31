<?php
define('FB_PROJECT', 'flofakids-324d4');
define('FB_BASE',    'https://firestore.googleapis.com/v1/projects/' . FB_PROJECT . '/databases/(default)/documents');
define('FB_STORAGE', 'https://firebasestorage.googleapis.com/v0/b/' . FB_PROJECT . '.appspot.com/o/');

function fb_storage_url(string $path): string {
    if (empty($path)) return '';
    if (str_starts_with($path, 'http')) return $path;
    $filename = basename($path);
    return 'images/' . $filename;
}

function fb_parse(array $doc): array {
    $fields = $doc['fields'] ?? [];
    $result = ['__id' => basename($doc['name'] ?? '')];
    foreach ($fields as $k => $v) {
        if (isset($v['stringValue']))       $result[$k] = $v['stringValue'];
        elseif (isset($v['integerValue']))  $result[$k] = (int)$v['integerValue'];
        elseif (isset($v['booleanValue']))  $result[$k] = (bool)$v['booleanValue'];
        elseif (isset($v['arrayValue'])) {
            $items = $v['arrayValue']['values'] ?? [];
            $result[$k] = array_map(fn($e) =>
                $e['stringValue'] ?? (isset($e['integerValue']) ? (int)$e['integerValue'] : ''), $items);
        }
    }
    return $result;
}

function fb_fields(array $data): array {
    $fields = [];
    foreach ($data as $k => $v) {
        if ($k === '__id') continue;
        if (is_int($v))        $fields[$k] = ['integerValue' => (string)$v];
        elseif (is_bool($v))   $fields[$k] = ['booleanValue' => $v];
        elseif (is_array($v)) {
            $vals = array_map(fn($s) => is_int($s)
                ? ['integerValue' => (string)$s]
                : ['stringValue'  => (string)$s], $v);
            $fields[$k] = ['arrayValue' => ['values' => $vals]];
        } else {
            $fields[$k] = ['stringValue' => (string)$v];
        }
    }
    return ['fields' => $fields];
}

function fb_get_all(string $coll): array {
    $url  = FB_BASE . '/' . $coll . '?pageSize=500';
    $resp = @file_get_contents($url);
    if (!$resp) return [];
    $json = json_decode($resp, true);
    $docs = array_map('fb_parse', $json['documents'] ?? []);

    usort($docs, fn($a, $b) => ($b['order'] ?? 0) <=> ($a['order'] ?? 0));

    return $docs;
}

function fb_get_one(string $coll, string $id): ?array {
    $url  = FB_BASE . '/' . $coll . '/' . $id;
    $resp = @file_get_contents($url);
    if (!$resp) return null;
    $json = json_decode($resp, true);
    if (isset($json['error'])) return null;
    return fb_parse($json);
}

function fb_insert(string $coll, array $data): bool {
    $url  = FB_BASE . '/' . $coll;
    $body = json_encode(fb_fields($data));
    $ctx  = stream_context_create(['http' => [
        'method'  => 'POST',
        'header'  => "Content-Type: application/json\r\n",
        'content' => $body,
    ]]);
    return @file_get_contents($url, false, $ctx) !== false;
}

function fb_update(string $coll, string $id, array $data): bool {
    $fields = fb_fields($data)['fields'];
    $keys   = array_keys($fields);
    $mask   = implode('&', array_map(fn($k) => 'updateMask.fieldPaths=' . urlencode($k), $keys));
    $url    = FB_BASE . '/' . $coll . '/' . $id . '?' . $mask;
    $body   = json_encode(['fields' => $fields]);
    $ctx    = stream_context_create(['http' => [
        'method'  => 'PATCH',
        'header'  => "Content-Type: application/json\r\n",
        'content' => $body,
    ]]);
    return @file_get_contents($url, false, $ctx) !== false;
}

function fb_delete(string $coll, string $id): bool {
    $url = FB_BASE . '/' . $coll . '/' . $id;
    $ctx = stream_context_create(['http' => ['method' => 'DELETE']]);
    return @file_get_contents($url, false, $ctx) !== false;
}

function fb_query_int(string $coll, string $field, int $value): array {
    $url  = 'https://firestore.googleapis.com/v1/projects/' . FB_PROJECT . '/databases/(default)/documents:runQuery';
    $body = json_encode(['structuredQuery' => [
        'from'  => [['collectionId' => $coll]],
        'where' => ['fieldFilter' => [
            'field' => ['fieldPath' => $field],
            'op'    => 'EQUAL',
            'value' => ['integerValue' => $value],
        ]],
    ]]);
    $ctx  = stream_context_create(['http' => [
        'method'  => 'POST',
        'header'  => "Content-Type: application/json\r\n",
        'content' => $body,
    ]]);
    $resp = @file_get_contents($url, false, $ctx);
    if (!$resp) return [];
    $rows = json_decode($resp, true);
    return array_values(array_filter(
        array_map(fn($r) => isset($r['document']) ? fb_parse($r['document']) : null, $rows)
    ));
}
    // Auto generate order = jumlah dokumen + 1
function fb_next_order(string $coll): int {
    $data = fb_get_all($coll);
    if (empty($data)) return 1;
    $orders = array_map(fn($r) => (int)($r['order'] ?? 0), $data);
    return max($orders) + 1;
}
