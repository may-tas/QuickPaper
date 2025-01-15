// lib/logic/cubits/ai/ai_state.dart

import 'package:equatable/equatable.dart';

enum AiStatus { initial, loading, success, error }

class AiState extends Equatable {
  final String? summary;
  final List<String> insights;
  final AiStatus status;
  final String? error;

  const AiState({
    this.summary,
    this.insights = const [],
    this.status = AiStatus.initial,
    this.error,
  });

  AiState copyWith({
    String? summary,
    List<String>? insights,
    AiStatus? status,
    String? error,
  }) {
    return AiState(
      summary: summary ?? this.summary,
      insights: insights ?? this.insights,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [summary, insights, status, error];
}
