// lib/models/search_filters.dart

import 'package:equatable/equatable.dart';

class SearchFilters extends Equatable {
  final String query;
  final String? year;
  final String? author;
  final String? venue;
  final String? institution;
  final bool? isOpenAccess;
  final String sortBy;

  const SearchFilters({
    this.query = '',
    this.year,
    this.author,
    this.venue,
    this.institution,
    this.isOpenAccess,
    this.sortBy = 'relevance_score:desc',
  });

  SearchFilters copyWith({
    String? query,
    String? year,
    String? author,
    String? venue,
    String? institution,
    bool? isOpenAccess,
    String? sortBy,
    bool clearYear = false,
    bool clearAuthor = false,
    bool clearVenue = false,
    bool clearInstitution = false,
    bool clearIsOpenAccess = false,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      year: clearYear ? null : (year ?? this.year),
      author: clearAuthor ? null : (author ?? this.author),
      venue: clearVenue ? null : (venue ?? this.venue),
      institution: clearInstitution ? null : (institution ?? this.institution),
      isOpenAccess:
          clearIsOpenAccess ? null : (isOpenAccess ?? this.isOpenAccess),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return year != null ||
        author != null ||
        venue != null ||
        institution != null ||
        isOpenAccess != null ||
        sortBy != 'relevance_score:desc';
  }

  int get activeFilterCount {
    int count = 0;
    if (year != null) count++;
    if (author != null) count++;
    if (venue != null) count++;
    if (institution != null) count++;
    if (isOpenAccess != null) count++;
    if (sortBy != 'relevance_score:desc') count++;
    return count;
  }

  @override
  List<Object?> get props => [
        query,
        year,
        author,
        venue,
        institution,
        isOpenAccess,
        sortBy,
      ];
}
