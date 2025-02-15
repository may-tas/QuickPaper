import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:research_articles_app/cubit/ai_state.dart';
import 'package:research_articles_app/models/article.dart';
import 'package:research_articles_app/services/gemini_service.dart';

class AiCubit extends Cubit<AiState> {
  final GeminiService _geminiService;

  AiCubit({required GeminiService geminiService})
      : _geminiService = geminiService,
        super(const AiState());

  Future<void> summarizeArticle(Article article) async {
    emit(state.copyWith(status: AiStatus.loading));

    try {
      final summary = await _geminiService.summarizeArticle(article);
      emit(state.copyWith(
        summary: summary,
        status: AiStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AiStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> generateInsights(Article article) async {
    emit(state.copyWith(status: AiStatus.loading));

    try {
      final insights = await _geminiService.generateKeyInsights(article);
      emit(state.copyWith(
        insights: insights,
        status: AiStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AiStatus.error,
        error: e.toString(),
      ));
    }
  }
}
