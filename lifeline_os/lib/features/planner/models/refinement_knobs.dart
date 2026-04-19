import 'package:freezed_annotation/freezed_annotation.dart';

part 'refinement_knobs.freezed.dart';
part 'refinement_knobs.g.dart';

/// Configuration knobs for controlling AI refinement behavior
/// Controls style, novelty, temperature, and output format
@freezed
class RefinementKnobs with _$RefinementKnobs {
  const factory RefinementKnobs({
    @Default(false) bool listOnly,           // Force bullet format, no justifications
    @Default(8) int targetCount,             // Target number of items/lines
    @Default(false) bool includeExamples,    // Add concrete examples
    @Default([]) List<String> forbidPhrases, // Banned words (for novelty)
    @Default([]) List<String> mustInclude,   // Required terms
    @Default(0.5) double temperature,        // LLM sampling temperature
    @Default(0.3) double noveltyThreshold,   // Min difference from original (0.0-1.0)
  }) = _RefinementKnobs;

  factory RefinementKnobs.fromJson(Map<String, dynamic> json) =>
      _$RefinementKnobsFromJson(json);
}
