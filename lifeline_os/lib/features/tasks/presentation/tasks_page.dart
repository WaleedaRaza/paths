import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/tables.dart';
import '../../../core/models/task.dart';
import '../../goals/providers/goals_provider.dart';
import '../../milestones/presentation/milestone_detail_page.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../providers/tasks_provider.dart';
import 'task_detail_page.dart';
import 'widgets/task_modal.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(filteredTasksProvider);
    final goalsAsync = ref.watch(allGoalsProvider);
    final milestonesAsync = ref.watch(allMilestonesProvider);
    final filterGoal = ref.watch(taskFilterGoalProvider);
    final filterPriority = ref.watch(taskFilterPriorityProvider);
    final filterEnergy = ref.watch(taskFilterEnergyProvider);
    final filterStatus = ref.watch(taskFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Filters
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Board View',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const TaskModal(),
                        );
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('New Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Status Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButton<TaskFilter>(
                          value: filterStatus,
                          underline: const SizedBox.shrink(),
                          isDense: true,
                          items: const [
                            DropdownMenuItem(value: TaskFilter.all, child: Text('All')),
                            DropdownMenuItem(value: TaskFilter.active, child: Text('Active')),
                            DropdownMenuItem(value: TaskFilter.completed, child: Text('Completed')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(taskFilterProvider.notifier).state = value;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Goal Filter
                      goalsAsync.when(
                        data: (goals) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButton<String?>(
                            value: filterGoal,
                            hint: const Text('All Goals', style: TextStyle(fontSize: 14)),
                            underline: const SizedBox.shrink(),
                            isDense: true,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Goals')),
                              ...goals.map((goal) => DropdownMenuItem(
                                value: goal.id,
                                child: Text(goal.title, overflow: TextOverflow.ellipsis),
                              )),
                            ],
                            onChanged: (value) => ref.read(taskFilterGoalProvider.notifier).state = value,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 12),
                      // Priority Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButton<TaskPriority?>(
                          value: filterPriority,
                          hint: const Text('Priority', style: TextStyle(fontSize: 14)),
                          underline: const SizedBox.shrink(),
                          isDense: true,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('All Priority')),
                            DropdownMenuItem(value: TaskPriority.high, child: Text('High')),
                            DropdownMenuItem(value: TaskPriority.medium, child: Text('Medium')),
                            DropdownMenuItem(value: TaskPriority.low, child: Text('Low')),
                          ],
                          onChanged: (value) => ref.read(taskFilterPriorityProvider.notifier).state = value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Energy Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButton<TaskEnergy?>(
                          value: filterEnergy,
                          hint: const Text('Energy', style: TextStyle(fontSize: 14)),
                          underline: const SizedBox.shrink(),
                          isDense: true,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('All Energy')),
                            DropdownMenuItem(value: TaskEnergy.low, child: Text('Low')),
                            DropdownMenuItem(value: TaskEnergy.medium, child: Text('Medium')),
                            DropdownMenuItem(value: TaskEnergy.high, child: Text('High')),
                          ],
                          onChanged: (value) => ref.read(taskFilterEnergyProvider.notifier).state = value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Clear Filters
                      if (filterGoal != null || filterPriority != null || filterEnergy != null)
                        TextButton.icon(
                          onPressed: () {
                            ref.read(taskFilterGoalProvider.notifier).state = null;
                            ref.read(taskFilterPriorityProvider.notifier).state = null;
                            ref.read(taskFilterEnergyProvider.notifier).state = null;
                          },
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Clear'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tasks Board View
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.check,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No tasks found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create a task or adjust your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return goalsAsync.when(
                  data: (goals) => milestonesAsync.when(
                    data: (milestones) => _buildBoardView(context, ref, tasks, goals, milestones),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => _buildSimpleTaskGrid(context, tasks),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildSimpleTaskGrid(context, tasks),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardView(BuildContext context, WidgetRef ref, List tasks, List goals, List milestones) {
    // Build hierarchy: Milestone → Goal → Tasks
    final Map<String, Map<String, List>> hierarchy = {};
    final List orphanedTasks = [];

    for (final task in tasks) {
      if (task.goalId == null) {
        orphanedTasks.add(task);
        continue;
      }

      try {
        final goal = goals.firstWhere((g) => g.id == task.goalId);
        final milestoneId = goal.milestoneId ?? 'no-milestone';

        hierarchy.putIfAbsent(milestoneId, () => {});
        hierarchy[milestoneId]!.putIfAbsent(goal.id, () => []);
        hierarchy[milestoneId]![goal.id]!.add(task);
      } catch (_) {
        orphanedTasks.add(task);
      }
    }

    // Get domains for columns
    final Map<Domain, List<String>> columnsByDomain = {};
    for (final milestoneId in hierarchy.keys) {
      if (milestoneId == 'no-milestone') continue;
      try {
        final milestone = milestones.firstWhere((m) => m.id == milestoneId);
        columnsByDomain.putIfAbsent(milestone.domain, () => []).add(milestoneId);
      } catch (_) {}
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain columns
          ...columnsByDomain.entries.map((entry) {
            final domain = entry.key;
            final milestoneIds = entry.value;
            return _buildDomainColumn(context, domain, milestoneIds, hierarchy, goals, milestones);
          }),
          // Orphaned tasks column (if any)
          if (orphanedTasks.isNotEmpty)
            _buildOrphanedColumn(context, orphanedTasks),
        ],
      ),
    );
  }

  Widget _buildDomainColumn(BuildContext context, Domain domain, List<String> milestoneIds, Map<String, Map<String, List>> hierarchy, List goals, List milestones) {
    // Count total tasks in this domain
    int totalTasks = 0;
    for (final milestoneId in milestoneIds) {
      final goalMap = hierarchy[milestoneId]!;
      for (final taskList in goalMap.values) {
        totalTasks += taskList.length;
      }
    }

    return Container(
      width: 360,
      margin: const EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (clean, no box)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Icon(
                  _domainIcon(domain),
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _domainLabel(domain),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '$totalTasks',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Column Content (scrollable, no outer box)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: milestoneIds.map((milestoneId) {
                dynamic milestone;
                try {
                  milestone = milestones.firstWhere((m) => m.id == milestoneId);
                } catch (_) {}

                final goalMap = hierarchy[milestoneId]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Milestone Heading (clean, no box)
                    InkWell(
                      onTap: milestone != null ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
                          ),
                        );
                      } : null,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.flag,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                milestone?.title ?? 'No Milestone',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (milestone != null)
                              const Icon(
                                LucideIcons.externalLink,
                                size: 12,
                                color: AppColors.textTertiary,
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Goals under this milestone
                    ...goalMap.entries.map((entry) {
                      final goalId = entry.key;
                      final goalTasks = entry.value;
                      dynamic goal;
                      try {
                        goal = goals.firstWhere((g) => g.id == goalId);
                      } catch (_) {}

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Goal Heading (clean, no box)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.target,
                                  size: 12,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    goal?.title ?? 'Unknown Goal',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${goalTasks.length}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Task Tiles Grid (2 per row in column)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: goalTasks.length,
                            itemBuilder: (context, index) => _buildTaskTile(context, goalTasks[index]),
                          ),

                          const SizedBox(height: 24),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanedColumn(BuildContext context, List orphanedTasks) {
    return Container(
      width: 360,
      margin: const EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (clean, no box)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.inbox,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Ungrouped',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${orphanedTasks.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Column Content
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: orphanedTasks.length,
              itemBuilder: (context, index) => _buildTaskTile(context, orphanedTasks[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, task) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: task.isCompleted ? AppColors.textTertiary : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row
            Row(
              children: [
                // Priority indicator
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                if (task.isCompleted)
                  Icon(
                    LucideIcons.check,
                    size: 12,
                    color: AppColors.textTertiary,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Task title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: task.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // Footer row
            Row(
              children: [
                // Energy icon
                Icon(
                  _energyIcon(task.energy),
                  size: 9,
                  color: AppColors.textTertiary,
                ),
                const Spacer(),
                // Points
                Text(
                  '${task.totalPoints}',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTaskGrid(BuildContext context, List tasks) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _buildTaskTile(context, tasks[index]),
    );
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  IconData _energyIcon(TaskEnergy energy) {
    switch (energy) {
      case TaskEnergy.low:
        return LucideIcons.battery;
      case TaskEnergy.medium:
        return LucideIcons.batteryMedium;
      case TaskEnergy.high:
        return LucideIcons.zap;
      case TaskEnergy.none:
        return LucideIcons.circle;
    }
  }

  String _domainLabel(Domain domain) {
    switch (domain) {
      case Domain.school:
        return 'School';
      case Domain.projects:
        return 'Projects';
      case Domain.finance:
        return 'Finance';
      case Domain.health:
        return 'Health';
      case Domain.dsa:
        return 'DSA';
      case Domain.personal:
        return 'Personal';
    }
  }

  IconData _domainIcon(Domain domain) {
    switch (domain) {
      case Domain.school:
        return LucideIcons.graduationCap;
      case Domain.projects:
        return LucideIcons.code;
      case Domain.finance:
        return LucideIcons.dollarSign;
      case Domain.health:
        return LucideIcons.heart;
      case Domain.dsa:
        return LucideIcons.cpu;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _domainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return Colors.indigo;
      case Domain.projects:
        return Colors.purple;
      case Domain.finance:
        return Colors.teal;
      case Domain.health:
        return Colors.orange;
      case Domain.dsa:
        return Colors.blue;
      case Domain.personal:
        return Colors.pink;
    }
  }
}


