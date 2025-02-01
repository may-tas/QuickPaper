// lib/logic/cubits/article/article_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:research_articles_app/cubit/article_state.dart';
import 'package:research_articles_app/repositories/article_repository.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ArticleRepository _repository;
  String _lastQuery = '';
  static const int pageSize = 10;
  bool _isLoading = false;

  ArticleCubit({required ArticleRepository repository})
      : _repository = repository,
        super(const ArticleState());

  Future<void> searchArticles(String query, {bool refresh = true}) async {
    if (query.isEmpty) return;
    if (_isLoading) return;
    _isLoading = true;

    if (refresh) {
      emit(state.copyWith(
        status: ArticleStatus.loading,
        currentPage: 0,
        hasMoreData: true,
        articles: [], // Clear existing articles on new search
      ));
      _lastQuery = query;
    }

    try {
      final articles = await _repository.searchArticles(
        query: query,
        year: state.year,
        offset: state.currentPage * pageSize,
        limit: pageSize,
      );

      final newArticles = refresh ? articles : [...state.articles, ...articles];

      emit(state.copyWith(
        articles: newArticles,
        status: ArticleStatus.success,
        hasMoreData: articles.length >= pageSize,
      ));

      if (!refresh) {
        await _repository.saveRecentSearch(query);
      }
    } catch (e) {
      emit(state.copyWith(
        status: ArticleStatus.error,
        error: e.toString(),
      ));
    } finally {
      _isLoading = false;
    }
  }

  void reset() {
    _lastQuery = '';
    emit(const ArticleState()); // This will reset to initial state
  }

  Future<void> loadMore() async {
    if (_isLoading ||
        !state.hasMoreData ||
        _lastQuery.isEmpty ||
        state.status == ArticleStatus.loading) {
      return;
    }

    emit(state.copyWith(
      currentPage: state.currentPage + 1,
    ));

    await searchArticles(_lastQuery, refresh: false);
  }

  void filterByYear(String? year) {
    emit(state.copyWith(
      year: year,
      currentPage: 0,
      articles: [],
      hasMoreData: true,
    ));
    if (_lastQuery.isNotEmpty) {
      searchArticles(_lastQuery);
    }
  }

  List<String> getRecentSearches() {
    return _repository.getRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    await _repository.clearRecentSearches();
  }
}
