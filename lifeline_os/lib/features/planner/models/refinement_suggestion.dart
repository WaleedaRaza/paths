import 'package:freezed_annotation/freezed_annotation.dart';

part 'refinement_suggestion.freezed.dart';
part 'refinement_suggestion.g.dart';

/// Model for AI-generated refinement suggestions
/// Contains reasoning, guidance, and proposed content for field improvements
@freezed
class RefinementSuggestion with _$RefinementSuggestion {
  const factory RefinementSuggestion({
    required String action, // 'expand', 'regenerate', 'simplify'
    required String fieldName,
    required String notes,
    required List<String> guidance, // Changed from String to List
    required List<String> proposedContentLines, // Changed from proposedContent String to array
    String? reasoning,
  }) = _RefinementSuggestion;

  factory RefinementSuggestion.fromJson(Map<String, dynamic> json) =>
      _$RefinementSuggestionFromJson(json);
}
