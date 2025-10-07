import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class HourSlotTimeline extends StatelessWidget {
  const HourSlotTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final currentHour = now.hour;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.clock, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                const Text(
                  'Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_formatHour(currentHour)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hour slots
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 17, // 6am to 11pm
              itemBuilder: (context, index) {
                final hour = 6 + index;
                final isCurrent = hour == currentHour;
                final task = _getMockTaskForHour(hour);

                return _buildHourSlot(
                  hour: hour,
                  task: task,
                  isCurrent: isCurrent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourSlot({
    required int hour,
    required MockScheduledTask? task,
    required bool isCurrent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.border,
          width: isCurrent ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Time label
          Container(
            width: 70,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: Text(
              _formatHour(hour),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                color: isCurrent ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),

          // Task or empty slot
          Expanded(
            child: task != null
                ? _buildScheduledTask(task)
                : _buildEmptySlot(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTask(MockScheduledTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(task.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(task.category),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${task.estimateMinutes}min',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Play button
          IconButton(
            icon: const Icon(LucideIcons.play, size: 18),
            color: AppColors.primary,
            onPressed: () {
              // Mock action
            },
            tooltip: 'Start Timer',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(LucideIcons.plus, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Text(
            'Drop task here',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'School':
        return AppColors.primary;
      case 'Projects':
        return AppColors.accent;
      case 'Health':
        return AppColors.success;
      case 'Finance':
        return const Color(0xFF10B981);
      default:
        return AppColors.secondary;
    }
  }

  MockScheduledTask? _getMockTaskForHour(int hour) {
    // Mock scheduled tasks
    switch (hour) {
      case 8:
        return MockScheduledTask(
          title: 'D426 Quiz Prep',
          category: 'School',
          estimateMinutes: 25,
        );
      case 10:
        return MockScheduledTask(
          title: 'Petform Auth Fix',
          category: 'Projects',
          estimateMinutes: 50,
        );
      case 12:
        return MockScheduledTask(
          title: 'Lunch Break',
          category: 'Personal',
          estimateMinutes: 60,
        );
      case 18:
        return MockScheduledTask(
          title: 'Evening Workout',
          category: 'Health',
          estimateMinutes: 45,
        );
      case 21:
        return MockScheduledTask(
          title: 'Learning Time',
          category: 'Personal',
          estimateMinutes: 30,
        );
      default:
        return null;
    }
  }
}

class MockScheduledTask {
  final String title;
  final String category;
  final int estimateMinutes;

  MockScheduledTask({
    required this.title,
    required this.category,
    required this.estimateMinutes,
  });
}

