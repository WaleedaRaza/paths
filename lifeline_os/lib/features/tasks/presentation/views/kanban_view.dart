import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../providers/tasks_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_modal.dart';

class TasksKanbanView extends ConsumerWidget {
  const TasksKanbanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasksAsync = ref.watch(activeTasksProvider);
    final completedTasksAsync = ref.watch(completedTasksProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // To Do Column
          Expanded(
            child: _KanbanColumn(
              title: 'To Do',
              icon: LucideIcons.circle,
              color: AppColors.textTertiary,
              tasksAsync: activeTasksAsync,
            ),
          ),
          const SizedBox(width: 16),
          
          // Done Column
          Expanded(
            child: _KanbanColumn(
              title: 'Done',
              icon: LucideIcons.check,
              color: AppColors.success,
              tasksAsync: completedTasksAsync,
            ),
          ),
        ],
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final AsyncValue tasksAsync;

  const _KanbanColumn({
    required this.title,
    required this.icon,
    required this.color,
    required this.tasksAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              tasksAsync.when(
                data: (tasks) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Tasks List
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return Center(
                  child: Text(
                    'No tasks',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () => _showTaskDetails(context, task.id),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, __) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showTaskDetails(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => TaskModal(taskId: taskId),
    );
  }
}

