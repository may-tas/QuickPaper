// lib/logic/cubits/article/article_state.dart

import 'package:equatable/equatable.dart';

import '../models/article.dart';
import '../models/search_filters.dart';

enum ArticleStatus { initial, loading, success, error }

class ArticleState extends Equatable {
  final List<Article> articles;
  final ArticleStatus status;
  final String? error;
  final SearchFilters filters;
  final int currentPage;
  final bool hasMoreData;

  const ArticleState({
    this.articles = const [],
    this.status = ArticleStatus.initial,
    this.error,
    this.filters = const SearchFilters(),
    this.currentPage = 0,
    this.hasMoreData = true,
  });

  ArticleState copyWith({
    List<Article>? articles,
    ArticleStatus? status,
    String? error,
    SearchFilters? filters,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return ArticleState(
      articles: articles ?? this.articles,
      status: status ?? this.status,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        status,
        error,
        filters,
        currentPage,
        hasMoreData,
      ];
}
