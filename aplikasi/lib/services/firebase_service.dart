import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseService {
  // Ganti dengan project ID Firebase kamu
  static const String _projectId = 'flofakids-324d4';
  static const String _baseUrl =
      'https://firestore.googleapis.com/v1/projects/flofakids-324d4/databases/(default)/documents';
  static final Map<String, List<Map<String, dynamic>>> _cache = {};
  // ── Helper: ubah format Firestore ke Map biasa ──
  static Map<String, dynamic> _parseDocument(Map<String, dynamic> doc) {
    final fields = doc['fields'] as Map<String, dynamic>? ?? {};
    final result = <String, dynamic>{};

    fields.forEach((key, value) {
      final v = value as Map<String, dynamic>;
      if (v.containsKey('stringValue')) {
        result[key] = v['stringValue'];
      } else if (v.containsKey('integerValue')) {
        result[key] = int.parse(v['integerValue'].toString());
      } else if (v.containsKey('arrayValue')) {
        final items = v['arrayValue']['values'] as List? ?? [];
        result[key] = items.map((e) {
          final entry = e as Map<String, dynamic>;
          if (entry.containsKey('stringValue')) return entry['stringValue'];
          if (entry.containsKey('integerValue'))
            return int.parse(entry['integerValue'].toString());
          return '';
        }).toList();
      }
    });

    return result;
  }

  static Future<List<Map<String, dynamic>>> getQuestions(int level) async {
    final cacheKey = 'questions_$level';
    if (_cache.containsKey(cacheKey))
      return _cache[cacheKey]!; // ← langsung return kalau sudah ada

    try {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents:runQuery',
      );
      final body = jsonEncode({
        "structuredQuery": {
          "from": [
            {"collectionId": "questions"},
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "level"},
              "op": "EQUAL",
              "value": {"integerValue": level},
            },
          },
        },
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) return [];

      final List docs = jsonDecode(response.body);
      final result = docs
          .where((d) => d['document'] != null)
          .map((d) => _parseDocument(d['document']))
          .toList();

      _cache[cacheKey] = result; // ← simpan ke cache
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getQuestionsEn(int level) async {
    final cacheKey = 'questions_en_$level';
    if (_cache.containsKey(cacheKey))
      return _cache[cacheKey]!; // ← langsung return kalau sudah ada

    try {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents:runQuery',
      );
      final body = jsonEncode({
        "structuredQuery": {
          "from": [
            {"collectionId": "questions_en"},
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "level"},
              "op": "EQUAL",
              "value": {"integerValue": level},
            },
          },
        },
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) return [];

      final List docs = jsonDecode(response.body);
      final result = docs
          .where((d) => d['document'] != null)
          .map((d) => _parseDocument(d['document']))
          .toList();

      _cache[cacheKey] = result; // ← simpan ke cache
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFloraArticles() async {
    if (_cache.containsKey('flora')) return _cache['flora']!; // ← tambah
    try {
      final url = Uri.parse('$_baseUrl/flora?pageSize=100');
      final response = await http.get(url);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List? ?? [];
      final result = docs.map((d) => _parseDocument(d)).toList();
      _cache['flora'] = result; // ← tambah
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFaunaArticles() async {
    if (_cache.containsKey('fauna')) return _cache['fauna']!;
    try {
      final url = Uri.parse('$_baseUrl/fauna?pageSize=100');
      final response = await http.get(url);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List? ?? [];
      final result = docs.map((d) => _parseDocument(d)).toList();
      _cache['fauna'] = result;
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFloraArticlesEn() async {
    if (_cache.containsKey('flora_en')) return _cache['flora_en']!;
    try {
      final url = Uri.parse('$_baseUrl/flora_en?pageSize=100');
      final response = await http.get(url);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List? ?? [];
      final result = docs.map((d) => _parseDocument(d)).toList();
      _cache['flora_en'] = result;
      return result;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFaunaArticlesEn() async {
    if (_cache.containsKey('fauna_en')) return _cache['fauna_en']!;
    try {
      final url = Uri.parse('$_baseUrl/fauna_en?pageSize=100');
      final response = await http.get(url);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List? ?? [];
      final result = docs.map((d) => _parseDocument(d)).toList();
      _cache['fauna_en'] = result;
      return result;
    } catch (e) {
      return [];
    }
  }
static void clearCache() {
  _cache.clear();
}
}
