import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../providers/schedule_provider.dart';

class HourSlotTimeline extends ConsumerWidget {
  final DateTime selectedDate;

  const HourSlotTimeline({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider(selectedDate));
    final repo = ref.read(scheduleRepositoryProvider);
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
            child: scheduleAsync.when(
              data: (scheduleItems) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: 17, // 6am to 11pm
                  itemBuilder: (context, index) {
                    final hour = 6 + index;
                    final isCurrent = hour == currentHour;
                    
                    // Find schedule item for this hour
                    final item = scheduleItems.where((s) {
                      final startHour = s.startTime.hour;
                      return startHour == hour;
                    }).firstOrNull;

                    return _buildHourSlot(
                      context: context,
                      ref: ref,
                      repo: repo,
                      hour: hour,
                      scheduleItem: item,
                      isCurrent: isCurrent,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading schedule')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourSlot({
    required BuildContext context,
    required WidgetRef ref,
    required ScheduleRepository repo,
    required int hour,
    required dynamic scheduleItem,
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
            child: scheduleItem != null
                ? _buildScheduledTask(context, repo, scheduleItem)
                : _buildEmptySlot(context, ref, repo, selectedDate, hour),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTask(BuildContext context, ScheduleRepository repo, dynamic scheduleItem) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Checkbox
          InkWell(
            onTap: () async {
              await repo.toggleScheduleItem(scheduleItem.id, !scheduleItem.isCompleted);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: scheduleItem.isCompleted ? AppColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: scheduleItem.isCompleted 
                      ? AppColors.success 
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: scheduleItem.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheduleItem.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: scheduleItem.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatHour(scheduleItem.startTime.hour)} - ${_formatHour(scheduleItem.endTime.hour)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 16),
            color: AppColors.textTertiary,
            onPressed: () async {
              await repo.deleteScheduleItem(scheduleItem.id);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(BuildContext context, WidgetRef ref, ScheduleRepository repo, DateTime date, int hour) {
    return InkWell(
      onTap: () => _showScheduleDialog(context, repo, date, hour),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(LucideIcons.plus, size: 16, color: AppColors.textTertiary),
            const SizedBox(width: 8),
            Text(
              'Schedule time block',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  void _showScheduleDialog(BuildContext context, ScheduleRepository repo, DateTime date, int hour) {
    final titleController = TextEditingController();
    int endHour = (hour + 1).clamp(6, 23); // Default to 1 hour block
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Schedule Time Block'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('From: ', style: TextStyle(fontSize: 14)),
                  Text(
                    _formatHour(hour),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  const Text('To: ', style: TextStyle(fontSize: 14)),
                  DropdownButton<int>(
                    value: endHour,
                    items: List.generate(24 - hour, (index) {
                      final h = hour + index + 1;
                      return DropdownMenuItem(
                        value: h,
                        child: Text(_formatHour(h)),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => endHour = value);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isNotEmpty) {
                  final startTime = DateTime(date.year, date.month, date.day, hour);
                  final endTime = DateTime(date.year, date.month, date.day, endHour);
                  
                  await repo.addScheduleItem(
                    date: date,
                    title: titleController.text.trim(),
                    startTime: startTime,
                    endTime: endTime,
                  );
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}

