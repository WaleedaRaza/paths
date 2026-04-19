import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/models/task.dart';
import '../providers/tasks_provider.dart';
import '../providers/tasks_repository.dart';
import '../../goals/providers/goals_provider.dart';
import 'widgets/task_modal.dart';

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskProvider(taskId));
    final subtasksAsync = ref.watch(subtasksProvider(taskId));
    final repo = ref.read(tasksRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TaskModal(taskId: taskId),
              );
            },
            tooltip: 'Edit Task',
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () => _showDeleteConfirmation(context, ref),
            tooltip: 'Delete Task',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: taskAsync.when(
        data: (task) {
          final goalAsync = task.goalId != null
              ? ref.watch(goalProvider(task.goalId!))
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(LucideIcons.target, size: 14),
                      label: const Text('Back to Goal'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Header Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parent Goal Badge
                      if (goalAsync != null)
                        goalAsync.when(
                          data: (goal) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.target,
                                  size: 14,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Part of: ${goal.title}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),

                      const SizedBox(height: 16),

                      // Title with checkbox
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => repo.toggleTask(task.id, !task.isCompleted),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: task.isCompleted
                                      ? AppColors.primary
                                      : AppColors.textTertiary,
                                  width: 2.5,
                                ),
                              ),
                              child: task.isCompleted
                                  ? const Icon(
                                      LucideIcons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: task.isCompleted
                                    ? AppColors.textTertiary
                                    : AppColors.textPrimary,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          task.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Metadata badges
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (task.priority != TaskPriority.none)
                            _buildBadge(
                              label: _getPriorityLabel(task.priority),
                              color: _getPriorityColor(task.priority),
                            ),
                          if (task.estimatedMinutes != null)
                            _buildBadge(
                              label: '${task.estimatedMinutes} min',
                              color: AppColors.accent,
                              icon: LucideIcons.clock,
                            ),
                          if (task.dueDate != null)
                            _buildBadge(
                              label: DateFormat('MMM d, y').format(task.dueDate!),
                              color: _isOverdue(task)
                                  ? AppColors.error
                                  : AppColors.primary,
                              icon: LucideIcons.calendar,
                            ),
                          if (task.totalPoints > 0)
                            _buildBadge(
                              label: '${task.totalPoints} pts',
                              color: AppColors.primary,
                              icon: LucideIcons.zap,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Subtasks Section
                const Text(
                  'Subtasks',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                subtasksAsync.when(
                  data: (subtasks) {
                    if (subtasks.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Text(
                            'No subtasks yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    }

                    final completed = subtasks.where((s) => s.isCompleted).length;

                    return Column(
                      children: [
                        // Progress indicator
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$completed of ${subtasks.length} completed',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: completed / subtasks.length,
                                        backgroundColor: AppColors.border.withOpacity(0.3),
                                        valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                                        minHeight: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${((completed / subtasks.length) * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtask list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subtasks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final subtask = subtasks[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => repo.toggleSubtask(
                                      subtask.id,
                                      !subtask.isCompleted,
                                    ),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: subtask.isCompleted
                                            ? AppColors.secondary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: subtask.isCompleted
                                              ? AppColors.secondary
                                              : AppColors.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: subtask.isCompleted
                                          ? const Icon(
                                              LucideIcons.check,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      subtask.title,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: subtask.isCompleted
                                            ? AppColors.textTertiary
                                            : AppColors.textPrimary,
                                        decoration: subtask.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  if (subtask.points > 0) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '+${subtask.points}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error loading subtasks'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading task')),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.low:
        return 'Low Priority';
      case TaskPriority.none:
        return '';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.secondary;
      case TaskPriority.none:
        return AppColors.textTertiary;
    }
  }

  bool _isOverdue(task) {
    return task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This will delete the task and all associated subtasks. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final repo = ref.read(tasksRepositoryProvider);
              await repo.deleteTask(taskId);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close detail page
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

