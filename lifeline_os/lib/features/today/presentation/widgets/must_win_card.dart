import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/must_win.dart';
import '../../providers/must_wins_provider.dart';

class MustWinCard extends ConsumerWidget {
  final MustWin mustWin;

  const MustWinCard({super.key, required this.mustWin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(mustWinsRepositoryProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mustWin.isCompleted
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: mustWin.isCompleted
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => repo.toggleMustWin(mustWin.id, !mustWin.isCompleted),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: mustWin.isCompleted
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: mustWin.isCompleted
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: mustWin.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 16,
                      color: Colors.white,
                    ).animate().scale(duration: 200.ms)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          
          // Title
          Expanded(
            child: Text(
              mustWin.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: mustWin.isCompleted
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
                decoration: mustWin.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          
          // Delete button
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 18),
            color: AppColors.textTertiary,
            onPressed: () => repo.deleteMustWin(mustWin.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms);
  }
}

