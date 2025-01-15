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
      authorId: json['authorId'] ?? '',
      name: json['name'] ?? '',
      url: json['url'],
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
    this.pdfUrl,
    this.venue,
    this.journalName,
    this.publicationTypes = const [],
  });

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
      pdfUrl: json['openAccessPdf']?['url'] as String?,
      venue: json['venue'] as String?,
      journalName: json['journal']?['name'] as String?,
      publicationTypes: (json['publicationTypes'] as List<dynamic>?)
              ?.map((type) => type as String)
              .toList() ??
          [],
    );
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
        pdfUrl,
        venue,
        journalName,
        publicationTypes,
      ];
}
