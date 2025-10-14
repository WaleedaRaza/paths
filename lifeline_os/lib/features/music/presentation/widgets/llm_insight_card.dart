import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class LLMInsightCard extends ConsumerWidget {
  const LLMInsightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch latest insight from database
    final hasInsight = false; // Placeholder

    if (!hasInsight) {
      return const SizedBox.shrink(); // Don't show if no insight
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              const Text(
                'AI Insight',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'You dove deep into indie this week during focus hours (34 plays!). '
            'Your discovery rate doubled - 6 new artists is impressive. '
            'Try the new Khruangbin album next, it matches your Wednesday evening vibe.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

