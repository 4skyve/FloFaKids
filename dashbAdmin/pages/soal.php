<?php
if (isset($_GET['hapus'])) {
    $coll_del = ($_GET['lang'] ?? 'id') === 'en' ? 'questions_en' : 'questions';
    fb_delete($coll_del, $_GET['hapus']);
    header("Location: ?page=soal&msg=hapus&lang=" . ($_GET['lang'] ?? 'id')); exit;
}

$lang   = $_GET['lang'] ?? 'id';
$coll   = $lang === 'en' ? 'questions_en' : 'questions';
$flt_lv = $_GET['level'] ?? '';

// Ambil semua data dulu, lalu cari level unik untuk opsi filter
$all_data = fb_get_all($coll);
$levels   = array_unique(array_filter(array_map(fn($r) => $r['level'] ?? null, $all_data)));
sort($levels);

// Filter di PHP (bukan query Firestore) supaya level berapapun bisa difilter
$data = $flt_lv !== '' ? array_values(array_filter($all_data, fn($r) => (string)($r['level'] ?? '') === $flt_lv)) : $all_data;
?>

<div class="content-card">
    <div class="card-header-custom">
        <h6><i class="bi bi-question-circle-fill text-warning me-2"></i>Daftar Soal</h6>
        <a href="?page=form_tambah_soal&lang=<?= $lang ?>" class="btn btn-primary btn-sm btn-action">
            <i class="bi bi-plus-lg me-1"></i>Tambah
        </a>
    </div>

    <?php if (isset($_GET['msg'])): ?>
        <div class="alert alert-success alert-dismissible mx-3 mt-3 mb-0">
            <?= ['tambah'=>'Soal ditambahkan!','edit'=>'Soal diperbarui!','hapus'=>'Soal dihapus!'][$_GET['msg']] ?? '' ?>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <?php endif; ?>

    <div class="table-toolbar">
        <div class="search-box">
            <i class="bi bi-search si"></i>
            <input type="text" id="searchInput" placeholder="Cari soal...">
        </div>

        <!-- FILTER LEVEL, otomatis dari data yng ada -->
        <form method="get" style="display:inline-flex;gap:6px;align-items:center;">
            <input type="hidden" name="page" value="soal">
            <input type="hidden" name="lang" value="<?= $lang ?>">
            <select name="level" class="filter-sel" onchange="this.form.submit()">
                <option value="">Semua Level</option>
                <?php foreach ($levels as $lv): ?>
                    <option value="<?= $lv ?>" <?= $flt_lv == $lv ? 'selected' : '' ?>>
                        Level <?= $lv ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </form>

        <select class="filter-sel" id="perPage">
            <option value="10">10/hal</option>
            <option value="25">25/hal</option>
            <option value="50">50/hal</option>
        </select>
        <div class="ms-auto d-flex gap-2">
            <a href="?page=soal&lang=id" class="btn btn-sm <?= $lang==='id'?'btn-success':'btn-outline-success' ?> btn-action">
                <i class="bi bi-translate me-1"></i>ID
            </a>
            <a href="?page=soal&lang=en" class="btn btn-sm <?= $lang==='en'?'btn-success':'btn-outline-success' ?> btn-action">
                <i class="bi bi-translate me-1"></i>EN
            </a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover mb-0" id="dataTable">
            <thead>
                <tr>
                    <th style="width:46px;padding-left:18px">No</th>
                    <th class="sortable">Pertanyaan <span class="sort-icon text-muted">⇅</span></th>
                    <th>Pilihan</th>
                    <th>Jawaban</th>
                    <th class="sortable" style="width:80px">Level <span class="sort-icon text-muted">⇅</span></th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <?php $no = 1; foreach ($data as $row): ?>
                <?php
                $opts   = $row['options'] ?? [];
                $ansIdx = (int)($row['answer'] ?? 0);
                $ansLbl = $opts[$ansIdx] ?? 'Opsi ' . ($ansIdx + 1);
                $lv     = (int)($row['level'] ?? 1);
                $lvCls  = $lv <= 1 ? 'badge-lv1' : ($lv === 2 ? 'badge-lv2' : 'badge-lv3');
                ?>
                <tr>
                    <td class="num-cell" style="padding-left:18px;color:#94a3b8;font-weight:700;"><?= $no++ ?></td>
                    <td style="max-width:220px;font-weight:600;color:#0f172a;">
                        <?= htmlspecialchars($row['question'] ?? '—') ?>
                    </td>
                    <td>
                        <?php foreach ($opts as $i => $opt): ?>
                            <span class="badge <?= $i===$ansIdx?'badge-title':'bg-light text-secondary border' ?>" style="margin:2px;">
                                <?= htmlspecialchars($opt) ?>
                            </span>
                        <?php endforeach; ?>
                    </td>
                    <td><span class="badge badge-title"><?= htmlspecialchars($ansLbl) ?></span></td>
                    <td><span class="badge <?= $lvCls ?>">Level <?= $lv ?></span></td>
                    <td>
                        <a href="?page=detail_soal&id=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-info btn-action me-1">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="?page=form_edit_soal&id=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-warning btn-action me-1">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <a href="?page=soal&hapus=<?= $row['__id'] ?>&lang=<?= $lang ?>"
                           class="btn btn-sm btn-outline-danger btn-action"
                           onclick="return confirm('Yakin hapus soal ini?')">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>
            <?php endforeach; ?>
            <?php if (empty($data)): ?>
                <tr><td colspan="6" class="text-center text-muted py-5">Belum ada soal.</td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>

    <div class="d-flex align-items-center justify-content-between px-3 py-3">
        <span class="text-muted" style="font-size:12px;" id="pageInfo"></span>
        <ul class="pagination pagination-sm mb-0" id="pager"></ul>
    </div>
</div>