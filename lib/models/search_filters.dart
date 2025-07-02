// lib/models/search_filters.dart

import 'package:equatable/equatable.dart';

class SearchFilters extends Equatable {
  final String query;
  final String? year;
  final String? author;
  final int? minCitationCount;
  final int? maxCitationCount;
  final String? language;
  final bool? isOpenAccess;
  final String sortBy;

  const SearchFilters({
    this.query = '',
    this.year,
    this.author,
    this.minCitationCount,
    this.maxCitationCount,
    this.language,
    this.isOpenAccess,
    this.sortBy = 'relevance_score:desc',
  });

  SearchFilters copyWith({
    String? query,
    String? year,
    String? author,
    int? minCitationCount,
    int? maxCitationCount,
    String? language,
    bool? isOpenAccess,
    String? sortBy,
    bool clearYear = false,
    bool clearAuthor = false,
    bool clearMinCitationCount = false,
    bool clearMaxCitationCount = false,
    bool clearLanguage = false,
    bool clearIsOpenAccess = false,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      year: clearYear ? null : (year ?? this.year),
      author: clearAuthor ? null : (author ?? this.author),
      minCitationCount: clearMinCitationCount
          ? null
          : (minCitationCount ?? this.minCitationCount),
      maxCitationCount: clearMaxCitationCount
          ? null
          : (maxCitationCount ?? this.maxCitationCount),
      language: clearLanguage ? null : (language ?? this.language),
      isOpenAccess:
          clearIsOpenAccess ? null : (isOpenAccess ?? this.isOpenAccess),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return year != null ||
        author != null ||
        minCitationCount != null ||
        maxCitationCount != null ||
        language != null ||
        isOpenAccess != null ||
        sortBy != 'relevance_score:desc';
  }

  int get activeFilterCount {
    int count = 0;
    if (year != null) count++;
    if (author != null) count++;
    if (minCitationCount != null) count++;
    if (maxCitationCount != null) count++;
    if (language != null) count++;
    if (isOpenAccess != null) count++;
    if (sortBy != 'relevance_score:desc') count++;
    return count;
  }

  @override
  List<Object?> get props => [
        query,
        year,
        author,
        minCitationCount,
        maxCitationCount,
        language,
        isOpenAccess,
        sortBy,
      ];
}
