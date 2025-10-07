import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../providers/goals_provider.dart';
import '../providers/goal_stats_provider.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../../tasks/providers/tasks_provider.dart' as tasks_providers;
import '../../tasks/presentation/task_detail_page.dart';
import '../../tasks/presentation/widgets/task_modal.dart';

class GoalDetailPage extends ConsumerWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalProvider(goalId));
    final statsAsync = ref.watch(goalStatsProvider(goalId));
    final tasksAsync = ref.watch(tasks_providers.tasksByGoalProvider(goalId));

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
          'Goal Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TaskModal(goalId: goalId),
          );
        },
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: goalAsync.when(
        data: (goal) {
          final milestoneAsync = goal.milestoneId != null
              ? ref.watch(milestoneByIdProvider(goal.milestoneId!))
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
                      icon: const Icon(LucideIcons.flag, size: 14),
                      label: const Text('Back to Milestone'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        goal.title,
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
                      // Parent Milestone Badge
                      if (milestoneAsync != null)
                        milestoneAsync.when(
                          data: (milestone) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.flag,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Milestone: ${milestone.title}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      if (goal.description != null && goal.description!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          goal.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Stats
                      statsAsync.when(
                        data: (stats) => Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _buildStatCard(
                              icon: LucideIcons.listChecks,
                              label: 'Tasks',
                              value: '${stats.completedTasks}/${stats.totalTasks}',
                              color: AppColors.primary,
                            ),
                            _buildStatCard(
                              icon: LucideIcons.percent,
                              label: 'Progress',
                              value: '${(stats.progress * 100).toInt()}%',
                              color: AppColors.secondary,
                            ),
                            _buildStatCard(
                              icon: LucideIcons.zap,
                              label: 'Points',
                              value: '${goal.totalPoints}',
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tasks Section
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Text(
                            'No tasks yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _buildTaskCard(context, task);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error loading tasks'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading goal')),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, task) {
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOverdue
                ? AppColors.error.withOpacity(0.5)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Icon(
              task.isCompleted ? LucideIcons.check : LucideIcons.circle,
              size: 24,
              color: task.isCompleted
                  ? AppColors.primary
                  : isOverdue
                      ? AppColors.error
                      : AppColors.textTertiary,
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: task.isCompleted
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (task.estimatedMinutes != null || isOverdue) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (task.estimatedMinutes != null) ...[
                          const Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.estimatedMinutes}min',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (isOverdue) ...[
                          if (task.estimatedMinutes != null) const SizedBox(width: 12),
                          const Icon(
                            Icons.warning_rounded,
                            size: 12,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Overdue',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Arrow
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

