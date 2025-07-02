// lib/data/repositories/article_repository.dart

import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';
import '../services/api_service.dart';

class ArticleRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  ArticleRepository({
    required ApiService apiService,
    required SharedPreferences prefs,
  })  : _apiService = apiService,
        _prefs = prefs;

  Future<List<Article>> searchArticles({
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
    final response = await _apiService.searchArticles(
      query: query,
      year: year,
      author: author,
      venue: venue,
      institution: institution,
      isOpenAccess: isOpenAccess,
      sort: sort,
      limit: limit,
      offset: offset,
    );

    final papers = response['results']
        as List<dynamic>; // OpenAlex uses 'results' instead of 'data'
    return papers
        .map((paper) => Article.fromOpenAlexJson(paper as Map<String, dynamic>))
        .toList();
  }

  Future<List<Article>> getPaperCitations(String paperId) async {
    final citations = await _apiService.getPaperCitations(paperId);
    return citations.map((paper) => Article.fromOpenAlexJson(paper)).toList();
  }

  // Local storage methods
  Future<void> saveRecentSearch(String query) async {
    final searches = _prefs.getStringList('recent_searches') ?? [];
    if (!searches.contains(query)) {
      searches.insert(0, query);
      if (searches.length > 10) searches.removeLast();
      await _prefs.setStringList('recent_searches', searches);
    }
  }

  List<String> getRecentSearches() {
    return _prefs.getStringList('recent_searches') ?? [];
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove('recent_searches');
  }
}
