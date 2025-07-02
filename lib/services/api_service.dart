// lib/data/services/api_service.dart

import 'dart:convert';
import 'dart:developer';
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
    String? author,
    String? venue,
    String? institution,
    bool? isOpenAccess,
    String sort = 'relevance_score:desc',
    int limit = 10,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'per-page': limit.toString(),
      'page': ((offset ~/ limit) + 1).toString(), // OpenAlex uses page numbers
      'sort': sort,
      'select':
          'id,title,display_name,publication_year,doi,open_access,primary_location,authorships,cited_by_count,referenced_works,type,abstract_inverted_index', // Request specific fields
    };

    // Handle different search types
    if (query.isNotEmpty) {
      queryParams['search'] = query;
    }

    // Add filters
    final filters = <String>[];
    if (year != null && year.isNotEmpty) filters.add('publication_year:$year');
    if (author != null && author.isNotEmpty) {
      filters.add('raw_author_name.search:$author');
    }
    if (venue != null && venue.isNotEmpty) {
      filters.add('primary_location.source.display_name.search:$venue');
    }
    if (institution != null && institution.isNotEmpty) {
      filters.add('institutions.display_name.search:$institution');
    }
    if (isOpenAccess != null) filters.add('is_oa:$isOpenAccess');

    if (filters.isNotEmpty) {
      queryParams['filter'] = filters.join(',');
    }

    if (query.isEmpty && filters.isNotEmpty && sort == 'relevance_score:desc') {
      queryParams['sort'] = 'cited_by_count:desc';
    }

    final uri = Uri.https(_baseUrl, '/works', queryParams);

    try {
      log("Searching articles with query: $query, filters: $filters, uri: $uri");
      final response = await http.get(uri, headers: _headers);
      log("response: ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        log("response: ${response.body}");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search articles: $e');
    }
  }
}
