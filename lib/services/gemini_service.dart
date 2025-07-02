// lib/data/services/gemini_service.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/article.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> summarizeArticle(Article article) async {
    try {
      final prompt = '''
        Summarize the following research paper. Focus on:
        1. Main findings
        2. Key methodology
        3. Practical implications

        Title: ${article.title}
        Abstract: ${article.abstract}
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate summary.';
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }

  Future<List<String>> generateKeyInsights(Article article) async {
    try {
      final prompt = '''
        Extract 3-5 key insights from this research paper:
        
        Title: ${article.title}
        Abstract: ${article.abstract}
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final insights = response.text?.split('\n') ?? [];
      return insights.where((insight) => insight.isNotEmpty).toList();
    } catch (e) {
      throw Exception('Failed to generate insights: $e');
    }
  }
}
