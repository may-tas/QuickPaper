import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/article_cubit.dart';
import '../models/search_filters.dart';
import '../utils/size_config.dart';
import '../utils/typography.dart';

class FilterChipsWidget extends StatelessWidget {
  final SearchFilters filters;

  const FilterChipsWidget({
    super.key,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    if (!filters.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: SizeConfig.getPercentSize(10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.getPercentSize(4)),
        children: [
          if (filters.year != null)
            _buildFilterChip(
              context,
              'Year: ${filters.year}',
              () => context.read<ArticleCubit>().filterByYear(null),
            ),
          if (filters.author != null)
            _buildFilterChip(
              context,
              'Author: ${filters.author}',
              () => context.read<ArticleCubit>().filterByAuthor(null),
            ),
          if (filters.minCitationCount != null ||
              filters.maxCitationCount != null)
            _buildFilterChip(
              context,
              'Citations: ${filters.minCitationCount ?? "0"} - ${filters.maxCitationCount ?? "∞"}',
              () => context.read<ArticleCubit>().clearCitationFilters(),
            ),
          if (filters.language != null)
            _buildFilterChip(
              context,
              'Language: ${_getLanguageDisplayName(filters.language!)}',
              () => context.read<ArticleCubit>().filterByLanguage(null),
            ),
          if (filters.isOpenAccess != null)
            _buildFilterChip(
              context,
              filters.isOpenAccess!
                  ? '🔓 Open Access'
                  : '🔒 Subscription Required',
              () => context.read<ArticleCubit>().filterByOpenAccess(null),
            ),
          if (filters.sortBy != 'relevance_score:desc')
            _buildFilterChip(
              context,
              'Sort: ${_getSortDisplayName(filters.sortBy)}',
              () => context
                  .read<ArticleCubit>()
                  .setSortBy('relevance_score:desc'),
            ),

          // Clear all button
          Container(
            margin: EdgeInsets.only(left: SizeConfig.getPercentSize(2)),
            child: ActionChip(
              label: Text(
                'Clear All',
                style: Typo.bodySmall.copyWith(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => context.read<ArticleCubit>().clearFilters(),
              backgroundColor: Colors.red[50],
              side: BorderSide(color: Colors.red[200]!),
              avatar: Icon(
                Icons.clear_all,
                size: SizeConfig.getPercentSize(4),
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.getPercentSize(2)),
      child: FilterChip(
        label: Text(
          label,
          style: Typo.bodySmall.copyWith(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        onSelected: (_) {}, // Required parameter
        onDeleted: onRemove,
        deleteIcon: Icon(
          Icons.close,
          size: SizeConfig.getPercentSize(4),
          color: Colors.deepPurple[700],
        ),
        backgroundColor: Colors.deepPurple[50],
        side: BorderSide(color: Colors.deepPurple[200]!),
        selectedColor: Colors.deepPurple[100],
        selected: true,
      ),
    );
  }

  String _getSortDisplayName(String sortBy) {
    switch (sortBy) {
      case 'publication_date:desc':
        return 'Newest';
      case 'publication_date:asc':
        return 'Oldest';
      case 'cited_by_count:desc':
        return 'Most Cited';
      case 'relevance_score:desc':
      default:
        return 'Relevance';
    }
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'zh':
        return 'Chinese';
      case 'ja':
        return 'Japanese';
      case 'pt':
        return 'Portuguese';
      case 'it':
        return 'Italian';
      case 'ru':
        return 'Russian';
      default:
        return languageCode;
    }
  }
}
