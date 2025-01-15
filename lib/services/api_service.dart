// lib/data/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'api.semanticscholar.org';
  static const String _apiVersion = 'graph/v1';

  // It's recommended to add your API key for higher rate limits
  // Free tier: 100 requests per 5 minutes
  static const String _apiKey = 'YOUR_API_KEY'; // Optional

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        // if (_apiKey.isNotEmpty) 'x-api-key': _apiKey,
      };

  Future<Map<String, dynamic>> searchArticles({
    required String query,
    String? year,
    String sort = 'relevance',
    int limit = 10,
    int offset = 0,
  }) async {
    // The API supports these fields
    const fields = [
      'paperId',
      'url',
      'title',
      'abstract',
      'venue',
      'year',
      'referenceCount',
      'citationCount',
      'influentialCitationCount',
      'isOpenAccess',
      'openAccessPdf',
      'authors',
      'journal',
      'publicationVenue',
      'publicationTypes',
    ];

    final queryParameters = {
      'query': query,
      'offset': offset.toString(),
      'limit': limit.toString(),
      'fields': fields.join(','),
    };

    // Add optional parameters if provided
    if (year != null) queryParameters['year'] = year;

    final uri =
        Uri.https(_baseUrl, '$_apiVersion/paper/search', queryParameters);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search articles: $e');
    }
  }

  Future<Map<String, dynamic>> getArticleDetails(String paperId) async {
    const fields = [
      'paperId',
      'url',
      'title',
      'abstract',
      'venue',
      'year',
      'referenceCount',
      'citationCount',
      'influentialCitationCount',
      'isOpenAccess',
      'openAccessPdf',
      'authors',
      'references',
      'citations',
      'journal',
      'publicationVenue',
      'publicationTypes',
    ];

    final uri = Uri.https(_baseUrl, '$_apiVersion/paper/$paperId', {
      'fields': fields.join(','),
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception(
            'Failed to get article details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get article details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAuthorPapers(String authorId) async {
    const fields = [
      'paperId',
      'title',
      'year',
      'citationCount',
      'influentialCitationCount',
    ];

    final uri = Uri.https(_baseUrl, '$_apiVersion/author/$authorId/papers', {
      'fields': fields.join(','),
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to get author papers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get author papers: $e');
    }
  }

  // Get citations for a paper
  Future<List<Map<String, dynamic>>> getPaperCitations(String paperId) async {
    const fields = [
      'paperId',
      'title',
      'year',
      'citationCount',
      'influentialCitationCount',
    ];

    final uri = Uri.https(_baseUrl, '$_apiVersion/paper/$paperId/citations', {
      'fields': fields.join(','),
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception(
            'Failed to get paper citations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get paper citations: $e');
    }
  }
}
