import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/schedule_item.dart';
import '../../providers/schedule_provider.dart';

class ScheduleTimeline extends ConsumerWidget {
  final List<ScheduleItem> items;

  const ScheduleTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.calendar,
                size: 48,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: 16),
              Text(
                'No scheduled items',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ScheduleItemCard(item: item);
      },
    );
  }
}

class _ScheduleItemCard extends ConsumerWidget {
  final ScheduleItem item;

  const _ScheduleItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(scheduleRepositoryProvider);
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isCompleted
            ? AppColors.accent.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeFormat.format(item.startTime),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                timeFormat.format(item.endTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Divider
          Container(
            width: 2,
            height: 40,
            color: item.isCompleted
                ? AppColors.accent
                : AppColors.textTertiary.withOpacity(0.3),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: item.isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getDurationMinutes(item)} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          
          // Checkbox
          GestureDetector(
            onTap: () => repo.toggleScheduleItem(item.id, !item.isCompleted),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isCompleted
                    ? AppColors.accent
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isCompleted
                      ? AppColors.accent
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: item.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  int _getDurationMinutes(ScheduleItem item) {
    return item.endTime.difference(item.startTime).inMinutes;
  }
}

