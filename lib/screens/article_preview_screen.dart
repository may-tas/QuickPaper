import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:quick_paper/utils/size_config.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/ai_cubit.dart';
import '../cubit/ai_state.dart';
import '../models/article.dart';
import '../utils/network_painter.dart';

class ArticlePreviewScreen extends StatefulWidget {
  final Article article;

  const ArticlePreviewScreen({
    super.key,
    required this.article,
  });

  @override
  State<ArticlePreviewScreen> createState() => _ArticlePreviewScreenState();
}

class _ArticlePreviewScreenState extends State<ArticlePreviewScreen> {
  bool _showAiInsights = false;
  final ScrollController _scrollController = ScrollController();

  void _shareArticle() {
    Share.share(
      'Check out this research paper: ${widget.article.title}\n${widget.article.url}',
    );
  }

  Future<void> _openArticle() async {
    final url = Uri.parse(widget.article.url);
    try {
      log(url.toString());
      await launchUrl(url);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  title: Padding(
                    padding: EdgeInsets.all(SizeConfig.getPercentSize(2)),
                    child: Text(
                      widget.article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
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
                      fit: StackFit.expand,
                      children: [
                        // Abstract pattern background
                        CustomPaint(
                          painter: NetworkPainter(),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Theme.of(context)
                                    .primaryColor
                                    .withAlpha((0.7 * 255).toInt()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _showAiInsights
                            ? Icons.lightbulb
                            : Icons.lightbulb_outline,
                        key: ValueKey(_showAiInsights),
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _showAiInsights = !_showAiInsights;
                      });
                      if (_showAiInsights) {
                        context.read<AiCubit>()
                          ..summarizeArticle(widget.article)
                          ..generateInsights(widget.article);
                      }
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Card(
                  margin: const EdgeInsets.all(16.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showAiInsights) ...[
                          _buildAiInsights(),
                          const Divider(height: 32),
                        ],
                        _buildAuthorsSection(),
                        const SizedBox(height: 24),
                        _buildAbstractSection(),
                        const SizedBox(height: 24),
                        _buildMetadataSection(),
                      ],
                    ),
                  ),
                ),
              ),
              // Extra space for bottom bar
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildAuthorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Authors'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.article.authors.map((author) {
            return Chip(
              label: Text(
                author.name,
                style: const TextStyle(fontSize: 13),
              ),
              backgroundColor:
                  Theme.of(context).primaryColor.withAlpha((0.1 * 255).toInt()),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAbstractSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Abstract'),
        const SizedBox(height: 12),
        Text(
          widget.article.abstract,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Colors.black87,
              ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetadataItem(
            icon: Icons.calendar_today,
            label: 'Year',
            value: widget.article.year?.toString() ?? 'N/A',
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildMetadataItem(
            icon: Icons.format_quote,
            label: 'Citations',
            value: widget.article.citationCount.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildAiInsights() {
    return BlocBuilder<AiCubit, AiState>(
      builder: (context, state) {
        if (state.status == AiStatus.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == AiStatus.error) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: ${state.error}',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('AI Summary'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .primaryColor
                    .withAlpha((0.05 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MarkdownBody(
                data: state.summary ?? 'No summary available',
                styleSheet: MarkdownStyleSheet(
                  p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.black87,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Key Insights'),
            const SizedBox(height: 12),
            ...state.insights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .primaryColor
                            .withAlpha((0.2 * 255).toInt()),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.insights,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MarkdownBody(
                            data: insight,
                            styleSheet: MarkdownStyleSheet(
                              p: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0), // Reduced vertical padding
        child: SafeArea(
          top: false, // Only apply safe area to bottom
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openArticle,
                  icon: const Icon(Icons.article, size: 20), // Smaller icon
                  label: const Text(
                    'Read Paper',
                    style: TextStyle(fontSize: 14), // Smaller text
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Reduced spacing
              SizedBox(
                height: 40, // Explicit height
                width: 40, // Square aspect ratio
                child: ElevatedButton(
                  onPressed: _shareArticle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.zero, // Remove padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.share, size: 20), // Smaller icon
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
