import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/article_cubit.dart';
import '../models/search_filters.dart';
import '../utils/size_config.dart';
import '../utils/typography.dart';

class SearchFiltersBottomSheet extends StatefulWidget {
  final SearchFilters currentFilters;

  const SearchFiltersBottomSheet({
    super.key,
    required this.currentFilters,
  });

  @override
  State<SearchFiltersBottomSheet> createState() =>
      _SearchFiltersBottomSheetState();
}

class _SearchFiltersBottomSheetState extends State<SearchFiltersBottomSheet> {
  late final TextEditingController _yearController;
  late final TextEditingController _authorController;
  late final TextEditingController _minCitationController;
  late final TextEditingController _maxCitationController;
  String? _language;
  bool? _isOpenAccess;
  String _sortBy = 'relevance_score:desc';

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: widget.currentFilters.year);
    _authorController =
        TextEditingController(text: widget.currentFilters.author);
    _minCitationController = TextEditingController(
        text: widget.currentFilters.minCitationCount?.toString());
    _maxCitationController = TextEditingController(
        text: widget.currentFilters.maxCitationCount?.toString());
    _language = widget.currentFilters.language;
    _isOpenAccess = widget.currentFilters.isOpenAccess;
    _sortBy = widget.currentFilters.sortBy;
  }

  @override
  void dispose() {
    _yearController.dispose();
    _authorController.dispose();
    _minCitationController.dispose();
    _maxCitationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: SizeConfig.getPercentSize(2)),
            width: SizeConfig.getPercentSize(12),
            height: SizeConfig.getPercentSize(1),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(SizeConfig.getPercentSize(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Filters',
                  style: Typo.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: Typo.bodyMedium.copyWith(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getPercentSize(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year Filter
                  _buildFilterSection(
                    'Publication Year',
                    _buildTextField(
                      controller: _yearController,
                      hintText: 'e.g., 2023',
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(4)),

                  // Author Filter
                  _buildFilterSection(
                    'Author',
                    _buildTextField(
                      controller: _authorController,
                      hintText: 'Search by author name',
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(4)),

                  // Citation Count Filter
                  _buildFilterSection(
                    'Citation Count',
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _minCitationController,
                            hintText: 'Min',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: SizeConfig.getPercentSize(2)),
                        Expanded(
                          child: _buildTextField(
                            controller: _maxCitationController,
                            hintText: 'Max',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(4)),

                  // Language Filter
                  _buildFilterSection(
                    'Language',
                    DropdownButtonFormField<String?>(
                      value: _language,
                      decoration: InputDecoration(
                        hintText: 'Select language',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getPercentSize(3),
                          vertical: SizeConfig.getPercentSize(2.5),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: null, child: Text('All Languages')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'es', child: Text('Spanish')),
                        DropdownMenuItem(value: 'fr', child: Text('French')),
                        DropdownMenuItem(value: 'de', child: Text('German')),
                        DropdownMenuItem(value: 'zh', child: Text('Chinese')),
                        DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                        DropdownMenuItem(
                            value: 'pt', child: Text('Portuguese')),
                        DropdownMenuItem(value: 'it', child: Text('Italian')),
                        DropdownMenuItem(value: 'ru', child: Text('Russian')),
                      ],
                      onChanged: (value) => setState(() => _language = value),
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(4)),

                  // Open Access Filter
                  _buildFilterSection(
                    'Open Access Status',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Explanation text
                        Container(
                          padding: EdgeInsets.all(SizeConfig.getPercentSize(3)),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: SizeConfig.getPercentSize(4),
                              ),
                              SizedBox(width: SizeConfig.getPercentSize(2)),
                              Expanded(
                                child: Text(
                                  'Open Access papers are freely available to read online without subscription fees',
                                  style: Typo.bodySmall.copyWith(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.getPercentSize(3)),

                        // Radio options
                        RadioListTile<bool?>(
                          title: Text('All Papers', style: Typo.bodyMedium),
                          subtitle: Text(
                            'Show both open and closed access papers',
                            style: Typo.bodySmall
                                .copyWith(color: Colors.grey[600]),
                          ),
                          value: null,
                          groupValue: _isOpenAccess,
                          onChanged: (value) =>
                              setState(() => _isOpenAccess = value),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<bool?>(
                          title: Row(
                            children: [
                              Icon(
                                Icons.lock_open,
                                color: Colors.green[600],
                                size: SizeConfig.getPercentSize(4),
                              ),
                              SizedBox(width: SizeConfig.getPercentSize(1.5)),
                              Text('Open Access Only', style: Typo.bodyMedium),
                            ],
                          ),
                          subtitle: Text(
                            'Free to read - includes Gold, Green, Hybrid, Bronze, and Diamond OA',
                            style: Typo.bodySmall
                                .copyWith(color: Colors.grey[600]),
                          ),
                          value: true,
                          groupValue: _isOpenAccess,
                          onChanged: (value) =>
                              setState(() => _isOpenAccess = value),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<bool?>(
                          title: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.red[600],
                                size: SizeConfig.getPercentSize(4),
                              ),
                              SizedBox(width: SizeConfig.getPercentSize(1.5)),
                              Text('Subscription Required',
                                  style: Typo.bodyMedium),
                            ],
                          ),
                          subtitle: Text(
                            'Requires subscription, purchase, or institutional access',
                            style: Typo.bodySmall
                                .copyWith(color: Colors.grey[600]),
                          ),
                          value: false,
                          groupValue: _isOpenAccess,
                          onChanged: (value) =>
                              setState(() => _isOpenAccess = value),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(4)),

                  // Sort By Filter
                  _buildFilterSection(
                    'Sort By',
                    DropdownButtonFormField<String>(
                      value: _sortBy,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getPercentSize(3),
                          vertical: SizeConfig.getPercentSize(2.5),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'relevance_score:desc',
                            child: Text('Relevance')),
                        DropdownMenuItem(
                            value: 'publication_date:desc',
                            child: Text('Newest First')),
                        DropdownMenuItem(
                            value: 'publication_date:asc',
                            child: Text('Oldest First')),
                        DropdownMenuItem(
                            value: 'cited_by_count:desc',
                            child: Text('Most Cited')),
                      ],
                      onChanged: (value) => setState(() => _sortBy = value!),
                    ),
                  ),

                  SizedBox(height: SizeConfig.getPercentSize(6)),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(SizeConfig.getPercentSize(4)),
            child: SizedBox(
              width: double.infinity,
              height: SizeConfig.getPercentSize(12),
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: Typo.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Typo.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: SizeConfig.getPercentSize(2)),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: Typo.titleSmall,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Typo.titleSmall.copyWith(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentSize(3),
          vertical: SizeConfig.getPercentSize(2.5),
        ),
      ),
    );
  }

  void _applyFilters() {
    final newFilters = SearchFilters(
      query: widget.currentFilters.query,
      year: _yearController.text.trim().isEmpty
          ? null
          : _yearController.text.trim(),
      author: _authorController.text.trim().isEmpty
          ? null
          : _authorController.text.trim(),
      minCitationCount: _minCitationController.text.trim().isEmpty
          ? null
          : int.tryParse(_minCitationController.text.trim()),
      maxCitationCount: _maxCitationController.text.trim().isEmpty
          ? null
          : int.tryParse(_maxCitationController.text.trim()),
      language: _language,
      isOpenAccess: _isOpenAccess,
      sortBy: _sortBy,
    );

    context.read<ArticleCubit>().updateFilters(newFilters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _yearController.clear();
      _authorController.clear();
      _minCitationController.clear();
      _maxCitationController.clear();
      _language = null;
      _isOpenAccess = null;
      _sortBy = 'relevance_score:desc';
    });
  }
}
