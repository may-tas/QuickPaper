// lib/data/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'api.openalex.org';

  // Add your email for better performance (polite pool)
  static const String _email = 'satyamj210@gmail.com';
  static const String _appName = 'QuickPaper';
  static const String _version = '1.0';

  Map<String, String> get _headers => {
        'User-Agent': '$_appName/$_version (mailto:$_email)',
        'Content-Type': 'application/json',
      };

  Future<Map<String, dynamic>> searchArticles({
    required String query,
    String? year,
    String sort = 'relevance_score:desc',
    int limit = 10,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'search': query,
      'per-page': limit.toString(),
      'page': ((offset ~/ limit) + 1).toString(), // OpenAlex uses page numbers
      'sort': sort,
      'select':
          'id,title,display_name,publication_year,doi,open_access,primary_location,authorships,cited_by_count,referenced_works,type_crossref,abstract_inverted_index', // Request specific fields including abstract
    };

    // Add filters
    final filters = <String>[];
    if (year != null) filters.add('publication_year:$year');

    if (filters.isNotEmpty) {
      queryParams['filter'] = filters.join(',');
    }

    final uri = Uri.https(_baseUrl, '/works', queryParams);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search articles: $e');
    }
  }

  Future<Map<String, dynamic>> getArticleDetails(String workId) async {
    final uri = Uri.https(_baseUrl, '/works/$workId', {
      'select':
          'id,title,display_name,publication_year,doi,open_access,primary_location,authorships,cited_by_count,referenced_works,type_crossref,abstract_inverted_index,concepts,related_works'
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to get article details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get article details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAuthorPapers(String authorId) async {
    final uri = Uri.https(_baseUrl, '/works', {
      'filter': 'author.id:$authorId',
      'sort': 'publication_date:desc',
      'per-page': '25',
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Failed to get author papers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get author papers: $e');
    }
  }

  // Get citations for a paper
  Future<List<Map<String, dynamic>>> getPaperCitations(String paperId) async {
    final uri = Uri.https(_baseUrl, '/works', {
      'filter': 'cites:$paperId',
      'sort': 'publication_date:desc',
      'per-page': '25',
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception(
            'Failed to get paper citations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get paper citations: $e');
    }
  }
}
