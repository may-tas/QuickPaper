import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/article_cubit.dart';
import '../cubit/article_state.dart';
import '../widgets/article_card.dart';
import '../widgets/filter_chips_widget.dart';
import '../widgets/search_filters_bottom_sheet.dart';
import 'article_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {}); // This will rebuild the widget when text changes
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<ArticleCubit>();
      final state = cubit.state;

      if (state.hasMoreData &&
          state.status != ArticleStatus.loading &&
          _searchController.text.isNotEmpty) {
        cubit.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight:
                160, // Increased height for better title presentation
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                  left: 16, bottom: 82), // Adjusted padding
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quick',
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.9 * 255).toInt()),
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Paper',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context)
                          .primaryColor
                          .withAlpha((0.8 * 255).toInt()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha((0.05 * 255).toInt()),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha((0.05 * 255).toInt()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Hero(
                  tag: 'searchBar',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search research papers...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (query) {
                                if (query.isNotEmpty) {
                                  context
                                      .read<ArticleCubit>()
                                      .searchArticles(query);
                                } else {
                                  context.read<ArticleCubit>().reset();
                                }
                              },
                            ),
                          ),
                          // Filter Button
                          BlocBuilder<ArticleCubit, ArticleState>(
                            builder: (context, state) {
                              return IconButton(
                                icon: Badge(
                                  isLabelVisible:
                                      state.filters.hasActiveFilters,
                                  label: Text(
                                      '${state.filters.activeFilterCount}'),
                                  child: Icon(
                                    Icons.tune,
                                    color: state.filters.hasActiveFilters
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[600],
                                  ),
                                ),
                                onPressed: () => _showFiltersBottomSheet(
                                    context, state.filters),
                              );
                            },
                          ),
                          // Clear Button
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<ArticleCubit>().reset();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: BlocBuilder<ArticleCubit, ArticleState>(
          builder: (context, state) {
            if (state.status == ArticleStatus.initial) {
              return _buildEmptyState();
            }

            if (state.status == ArticleStatus.loading &&
                state.articles.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ArticleStatus.error) {
              return _buildErrorState(state.error ?? 'An error occurred');
            }

            return Column(
              children: [
                // Filter chips
                FilterChipsWidget(filters: state.filters),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Found ${state.articles.length} results, scroll to fetch more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        if (_searchController.text.isNotEmpty) {
                          context
                              .read<ArticleCubit>()
                              .searchArticles(_searchController.text);
                        } else if (state.filters.hasActiveFilters) {
                          context.read<ArticleCubit>().searchWithFilters();
                        }
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.articles.length +
                            1, // +1 for the loading indicator
                        itemBuilder: (context, index) {
                          // If we're at the end of the list
                          if (index == state.articles.length) {
                            if (state.articles.isNotEmpty) {
                              // Show "no more articles" message when we've reached the end
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox
                                .shrink(); // Return empty widget if no articles yet
                          }

                          final article = state.articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ArticleCard(
                              article: article,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ArticlePreviewScreen(article: article),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 84,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for research papers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter keywords, titles, or authors to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red[700],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  context
                      .read<ArticleCubit>()
                      .searchArticles(_searchController.text);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context, filters) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: SearchFiltersBottomSheet(currentFilters: filters),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
