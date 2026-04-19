import 'package:freezed_annotation/freezed_annotation.dart';

part 'kobayashi_analysis.freezed.dart';
part 'kobayashi_analysis.g.dart';

@freezed
class KobayashiAnalysis with _$KobayashiAnalysis {
  const factory KobayashiAnalysis({
    required String id,
    required String sessionId,
    required int overallScore,
    required List<String> strengths,
    required List<String> weaknesses,
    required List<String> recommendations,
    required String transcript,
    required DateTime createdAt,
  }) = _KobayashiAnalysis;

  factory KobayashiAnalysis.fromJson(Map<String, dynamic> json) =>
      _$KobayashiAnalysisFromJson(json);
}

