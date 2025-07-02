// lib/data/models/article.dart

import 'package:equatable/equatable.dart';

class Author {
  final String authorId;
  final String name;
  final String? url;

  Author({
    required this.authorId,
    required this.name,
    this.url,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      authorId: json['authorId'] ?? json['id'] ?? '',
      name: json['name'] ?? json['display_name'] ?? '',
      url: json['url'] ?? json['orcid'],
    );
  }

  // Factory for OpenAlex format
  factory Author.fromOpenAlexJson(Map<String, dynamic> json) {
    return Author(
      authorId: json['id'] ?? '',
      name: json['display_name'] ?? '',
      url: json['orcid'],
    );
  }
}

class Article extends Equatable {
  final String paperId;
  final String title;
  final List<Author> authors;
  final String abstract;
  final String url;
  final int? year;
  final int referenceCount;
  final int citationCount;
  final int influentialCitationCount;
  final bool isOpenAccess;
  final String? openAccessType; // gold, green, hybrid, bronze, diamond, closed
  final String? pdfUrl;
  final String? venue;
  final String? journalName;
  final List<String> publicationTypes;

  const Article({
    required this.paperId,
    required this.title,
    required this.authors,
    required this.abstract,
    required this.url,
    this.year,
    this.referenceCount = 0,
    this.citationCount = 0,
    this.influentialCitationCount = 0,
    this.isOpenAccess = false,
    this.openAccessType,
    this.pdfUrl,
    this.venue,
    this.journalName,
    this.publicationTypes = const [],
  });

  // Helper method to get open access description
  String get openAccessDescription {
    if (!isOpenAccess) return 'Subscription Required';

    switch (openAccessType?.toLowerCase()) {
      case 'gold':
        return 'Gold Open Access - Free on publisher website';
      case 'green':
        return 'Green Open Access - Free in repository';
      case 'hybrid':
        return 'Hybrid Open Access - Free option in subscription journal';
      case 'bronze':
        return 'Bronze Open Access - Free on publisher website (no license)';
      case 'diamond':
        return 'Diamond Open Access - Free with no author fees';
      default:
        return 'Open Access';
    }
  }

  // Helper method to get open access icon
  String get openAccessIcon {
    if (!isOpenAccess) return '🔒';

    switch (openAccessType?.toLowerCase()) {
      case 'gold':
        return '🥇';
      case 'green':
        return '🟢';
      case 'hybrid':
        return '🔄';
      case 'bronze':
        return '🥉';
      case 'diamond':
        return '💎';
      default:
        return '🔓';
    }
  }

  String get oaType => openAccessType ?? 'Unknown';

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      paperId: json['paperId'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)
              ?.map((author) => Author.fromJson(author as Map<String, dynamic>))
              .toList() ??
          [],
      abstract: json['abstract'] as String? ?? '',
      url: json['url'] as String,
      year: json['year'] as int?,
      referenceCount: json['referenceCount'] as int? ?? 0,
      citationCount: json['citationCount'] as int? ?? 0,
      influentialCitationCount: json['influentialCitationCount'] as int? ?? 0,
      isOpenAccess: json['isOpenAccess'] as bool? ?? false,
      openAccessType: json['openAccessType'] as String?,
      pdfUrl: json['openAccessPdf']?['url'] as String?,
      venue: json['venue'] as String?,
      journalName: json['journal']?['name'] as String?,
      publicationTypes: (json['publicationTypes'] as List<dynamic>?)
              ?.map((type) => type as String)
              .toList() ??
          [],
    );
  }

  // Factory for OpenAlex format
  factory Article.fromOpenAlexJson(Map<String, dynamic> json) {
    // Extract PDF URLs from open access locations
    String? pdfUrl;
    final oaLocations = json['open_access']?['oa_locations'] as List<dynamic>?;
    if (oaLocations != null) {
      for (final location in oaLocations) {
        if (location['host_type'] == 'repository' && location['url'] != null) {
          pdfUrl = location['url'] as String;
          break;
        }
      }
    }

    // Extract abstract from inverted index
    String abstract = '';
    final abstractIndex =
        json['abstract_inverted_index'] as Map<String, dynamic>?;
    if (abstractIndex != null) {
      abstract = _reconstructAbstractFromInvertedIndex(abstractIndex);
    }

    return Article(
      paperId: json['id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      authors: (json['authorships'] as List<dynamic>?)
              ?.map((authorship) => Author.fromOpenAlexJson(
                  authorship['author'] as Map<String, dynamic>))
              .toList() ??
          [],
      abstract: abstract,
      url: json['doi'] as String? ?? json['id'] as String,
      year: json['publication_year'] as int?,
      referenceCount: json['referenced_works']?.length as int? ?? 0,
      citationCount: json['cited_by_count'] as int? ?? 0,
      influentialCitationCount: json['cited_by_count'] as int? ??
          0, // OpenAlex doesn't have this field
      isOpenAccess: json['open_access']?['is_oa'] as bool? ?? false,
      openAccessType: json['open_access']?['oa_status'] as String?,
      pdfUrl: pdfUrl,
      venue: json['primary_location']?['source']?['display_name'] as String?,
      journalName:
          json['primary_location']?['source']?['display_name'] as String?,
      publicationTypes: (json['type_crossref'] != null)
          ? [json['type_crossref'] as String]
          : [],
    );
  }

  // Helper method to reconstruct abstract from inverted index
  static String _reconstructAbstractFromInvertedIndex(
      Map<String, dynamic> invertedIndex) {
    if (invertedIndex.isEmpty) return '';

    // Create a map to store word positions
    final Map<int, String> positionToWord = {};

    // Process each word and its positions
    invertedIndex.forEach((word, positions) {
      if (positions is List) {
        for (final position in positions) {
          if (position is int) {
            positionToWord[position] = word;
          }
        }
      }
    });

    // Sort by position and reconstruct the text
    final sortedPositions = positionToWord.keys.toList()..sort();
    final words = sortedPositions.map((pos) => positionToWord[pos]!).toList();

    return words.join(' ');
  }

  Map<String, dynamic> toJson() => {
        'paperId': paperId,
        'title': title,
        'authors': authors
            .map((author) => {
                  'authorId': author.authorId,
                  'name': author.name,
                  'url': author.url,
                })
            .toList(),
        'abstract': abstract,
        'url': url,
        'year': year,
        'referenceCount': referenceCount,
        'citationCount': citationCount,
        'influentialCitationCount': influentialCitationCount,
        'isOpenAccess': isOpenAccess,
        'openAccessType': openAccessType,
        'pdfUrl': pdfUrl,
        'venue': venue,
        'journalName': journalName,
        'publicationTypes': publicationTypes,
      };

  @override
  List<Object?> get props => [
        paperId,
        title,
        authors,
        abstract,
        url,
        year,
        referenceCount,
        citationCount,
        influentialCitationCount,
        isOpenAccess,
        openAccessType,
        pdfUrl,
        venue,
        journalName,
        publicationTypes,
      ];
}
