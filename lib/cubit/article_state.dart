// lib/logic/cubits/article/article_state.dart

import 'package:equatable/equatable.dart';

import '../models/article.dart';

enum ArticleStatus { initial, loading, success, error }

class ArticleState extends Equatable {
  final List<Article> articles;
  final ArticleStatus status;
  final String? error;
  final String? year;
  final int currentPage;
  final bool hasMoreData;

  const ArticleState({
    this.articles = const [],
    this.status = ArticleStatus.initial,
    this.error,
    this.year,
    this.currentPage = 0,
    this.hasMoreData = true,
  });

  ArticleState copyWith({
    List<Article>? articles,
    ArticleStatus? status,
    String? error,
    String? year,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return ArticleState(
      articles: articles ?? this.articles,
      status: status ?? this.status,
      error: error ?? this.error,
      year: year ?? this.year,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        status,
        error,
        year,
        currentPage,
        hasMoreData,
      ];
}
