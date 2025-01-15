// lib/data/repositories/article_repository.dart

import 'package:research_articles_app/models/article.dart';
import 'package:research_articles_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _apiService.searchArticles(
      query: query,
      year: year,
      limit: limit,
      offset: offset,
    );

    final papers = response['data'] as List<dynamic>;
    return papers
        .map((paper) => Article.fromJson(paper as Map<String, dynamic>))
        .toList();
  }

  Future<Article> getArticleDetails(String paperId) async {
    final response = await _apiService.getArticleDetails(paperId);
    return Article.fromJson(response);
  }

  Future<List<Article>> getPaperCitations(String paperId) async {
    final citations = await _apiService.getPaperCitations(paperId);
    return citations.map((paper) => Article.fromJson(paper)).toList();
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
