// lib/logic/cubits/article/article_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/search_filters.dart';
import '../repositories/article_repository.dart';
import 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ArticleRepository _repository;
  String _lastQuery = '';
  static const int pageSize = 5;
  bool _isLoading = false;

  ArticleCubit({required ArticleRepository repository})
      : _repository = repository,
        super(const ArticleState());

  Future<void> searchArticles(String query, {bool refresh = true}) async {
    if (_isLoading) return;
    _isLoading = true;

    if (refresh) {
      emit(state.copyWith(
        status: ArticleStatus.loading,
        currentPage: 0,
        hasMoreData: true,
        articles: [], // Clear existing articles on new search
        filters: state.filters.copyWith(query: query),
      ));
      _lastQuery = query;
    }

    try {
      final articles = await _repository.searchArticles(
        query: query,
        year: state.filters.year,
        author: state.filters.author,
        maxCitationCount: state.filters.maxCitationCount,
        minCitationCount: state.filters.minCitationCount,
        language: state.filters.language,
        isOpenAccess: state.filters.isOpenAccess,
        sort: state.filters.sortBy,
        offset: state.currentPage * pageSize,
        limit: pageSize,
      );

      final newArticles = refresh ? articles : [...state.articles, ...articles];

      emit(state.copyWith(
        articles: newArticles,
        status: ArticleStatus.success,
        hasMoreData: articles.length >= pageSize,
      ));

      if (!refresh && query.isNotEmpty) {
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

  // New method to search with filters only
  Future<void> searchWithFilters() async {
    if (_isLoading) return;

    // If no search query and no active filters, reset to initial state
    if (_lastQuery.isEmpty && !state.filters.hasActiveFilters) {
      emit(const ArticleState());
      return;
    }

    _isLoading = true;

    emit(state.copyWith(
      status: ArticleStatus.loading,
      currentPage: 0,
      hasMoreData: true,
      articles: [],
    ));

    try {
      final articles = await _repository.searchArticles(
        query: _lastQuery, // Use last query or empty string
        year: state.filters.year,
        author: state.filters.author,
        maxCitationCount: state.filters.maxCitationCount,
        minCitationCount: state.filters.minCitationCount,
        language: state.filters.language,
        isOpenAccess: state.filters.isOpenAccess,
        sort: state.filters.sortBy,
        offset: 0,
        limit: pageSize,
      );

      emit(state.copyWith(
        articles: articles,
        status: ArticleStatus.success,
        hasMoreData: articles.length >= pageSize,
        currentPage: 0,
      ));
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
        state.status == ArticleStatus.loading) {
      return;
    }

    emit(state.copyWith(
      currentPage: state.currentPage + 1,
    ));

    await searchArticles(_lastQuery, refresh: false);
  }

  void updateFilters(SearchFilters newFilters) {
    emit(state.copyWith(
      filters: newFilters,
      currentPage: 0,
      articles: [],
      hasMoreData: true,
    ));
    // Check if we should reset to initial state or search with filters
    if (_lastQuery.isEmpty && !newFilters.hasActiveFilters) {
      emit(const ArticleState());
    } else {
      searchWithFilters();
    }
  }

  void filterByYear(String? year) {
    final updatedFilters = state.filters.copyWith(
      year: year,
      clearYear: year == null,
    );
    updateFilters(updatedFilters);
  }

  void filterByAuthor(String? author) {
    final updatedFilters = state.filters.copyWith(
      author: author,
      clearAuthor: author == null,
    );
    updateFilters(updatedFilters);
  }

  void filterByLanguage(String? language) {
    final updatedFilters = state.filters.copyWith(
      language: language,
      clearLanguage: language == null,
    );
    updateFilters(updatedFilters);
  }

  void filterByOpenAccess(bool? isOpenAccess) {
    final updatedFilters = state.filters.copyWith(
      isOpenAccess: isOpenAccess,
      clearIsOpenAccess: isOpenAccess == null,
    );
    updateFilters(updatedFilters);
  }

  void setSortBy(String sortBy) {
    final updatedFilters = state.filters.copyWith(sortBy: sortBy);
    updateFilters(updatedFilters);
  }

  void clearFilters() {
    emit(state.copyWith(
      filters: const SearchFilters(),
      currentPage: 0,
      articles: [],
      hasMoreData: true,
    ));
    // Check if we should reset to initial state or search with cleared filters
    if (_lastQuery.isEmpty) {
      emit(const ArticleState());
    } else {
      searchWithFilters();
    }
  }

  void clearCitationFilters() {
    final updatedFilters = state.filters.copyWith(
      clearMinCitationCount: true,
      clearMaxCitationCount: true,
    );
    updateFilters(updatedFilters);
  }

  List<String> getRecentSearches() {
    return _repository.getRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    await _repository.clearRecentSearches();
  }
}
