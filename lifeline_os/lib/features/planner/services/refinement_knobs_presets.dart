import '../models/refinement_knobs.dart';
import 'novelty_checker.dart';

/// Preset configurations for refinement knobs based on action and field type
class RefinementKnobsPresets {
  /// Get appropriate knobs for given action and field
  static RefinementKnobs getKnobs({
    required String action,
    required String sectionType,
    required String fieldName,
    required String currentContent,
  }) {
    // Action base settings
    final base = switch (action) {
      'expand' => const RefinementKnobs(
        temperature: 0.35,
        targetCount: 12,
        includeExamples: true,
        noveltyThreshold: 0.3,
      ),
      'regenerate' => RefinementKnobs(
        temperature: 0.7,
        targetCount: 8,
        noveltyThreshold: 0.5,
        forbidPhrases: NoveltyChecker.getTopTrigrams(currentContent, 5),
      ),
      'simplify' => const RefinementKnobs(
        temperature: 0.1,
        targetCount: 5,
        listOnly: true,
        noveltyThreshold: 0.2,
      ),
      _ => const RefinementKnobs(),
    };

    // Field-specific overrides for Research & Stack section
    if (sectionType == 'research') {
      if (fieldName == 'Tech Stack' && action == 'expand') {
        return base.copyWith(
          listOnly: true,
          targetCount: 26,
          forbidPhrases: [
            'vast ecosystem',
            'large community',
            'robust',
            'widely used',
            'popular choice',
          ],
        );
      }

      if (fieldName == 'Dependencies') {
        return base.copyWith(
          listOnly: true,
          targetCount: 10,
        );
      }

      if (fieldName == 'Best Practices') {
        if (action == 'simplify') {
          return base.copyWith(
            listOnly: true,
            targetCount: 6,
          );
        }
      }

      if (fieldName == 'Security') {
        if (action == 'expand') {
          return base.copyWith(
            listOnly: true,
            targetCount: 8,
            includeExamples: true,
          );
        }
      }
    }

    return base;
  }
}
