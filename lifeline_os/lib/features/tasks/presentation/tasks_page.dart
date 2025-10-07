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

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final Set<String> _expandedMilestones = {};
  final Set<String> _expandedGoals = {};

  @override
  Widget build(BuildContext context) {
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

          // Tasks Hierarchical Grid
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.checkSquare,
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
                    data: (milestones) => _buildHierarchicalTaskList(context, ref, tasks, goals, milestones),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => _buildSimpleTaskList(context, ref, tasks, goals),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildSimpleTaskList(context, ref, tasks, []),
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

  Widget _buildHierarchicalTaskList(BuildContext context, WidgetRef ref, List tasks, List goals, List milestones) {
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        // Iterate through milestones
        ...hierarchy.keys.map((milestoneId) {
          dynamic milestone;
          try {
            if (milestoneId != 'no-milestone') {
              milestone = milestones.firstWhere((m) => m.id == milestoneId);
            }
          } catch (_) {}

          final goalMap = hierarchy[milestoneId]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Milestone Header (collapsible)
              _buildMilestoneHeader(context, milestone, milestoneId, goalMap),
              const SizedBox(height: 16),

              // Goals under this milestone (if expanded)
              if (_expandedMilestones.contains(milestoneId)) ...[
                ...goalMap.keys.map((goalId) {
                  try {
                    final goal = goals.firstWhere((g) => g.id == goalId);
                    final goalTasks = goalMap[goalId]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Goal Subheader (collapsible)
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: _buildGoalHeader(context, goal, goalId, goalTasks),
                        ),
                        const SizedBox(height: 12),

                        // Task Grid (if expanded)
                        if (_expandedGoals.contains(goalId)) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 5;
                                if (constraints.maxWidth > 1800) {
                                  crossAxisCount = 6;
                                } else if (constraints.maxWidth < 1200) {
                                  crossAxisCount = 4;
                                } else if (constraints.maxWidth < 800) {
                                  crossAxisCount = 3;
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 1.1,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: goalTasks.length,
                                  itemBuilder: (context, index) => _buildCompactTaskTile(context, goalTasks[index]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    );
                  } catch (_) {
                    return const SizedBox.shrink();
                  }
                }),
              ],

              const SizedBox(height: 32),
            ],
          );
        }),

        // Orphaned tasks section
        if (orphanedTasks.isNotEmpty) ...[
          Row(
            children: [
              const Icon(LucideIcons.inbox, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Ungrouped Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 5;
              if (constraints.maxWidth > 1800) {
                crossAxisCount = 6;
              } else if (constraints.maxWidth < 1200) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth < 800) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: orphanedTasks.length,
                itemBuilder: (context, index) => _buildCompactTaskTile(context, orphanedTasks[index]),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSimpleTaskList(BuildContext context, WidgetRef ref, List tasks, List goals) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        if (constraints.maxWidth > 1800) {
          crossAxisCount = 6;
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth < 800) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) => _buildCompactTaskTile(context, tasks[index]),
        );
      },
    );
  }

  Widget _buildMilestoneHeader(BuildContext context, dynamic milestone, String milestoneId, Map<String, List> goalMap) {
    final isExpanded = _expandedMilestones.contains(milestoneId);
    final totalTasks = goalMap.values.fold<int>(0, (sum, tasks) => sum + tasks.length);

    return InkWell(
      onTap: () {
        setState(() {
          if (isExpanded) {
            _expandedMilestones.remove(milestoneId);
            // Also collapse all goals under this milestone
            goalMap.keys.forEach(_expandedGoals.remove);
          } else {
            _expandedMilestones.add(milestoneId);
            // Auto-expand all goals under this milestone
            goalMap.keys.forEach(_expandedGoals.add);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Expand/Collapse Icon
            Icon(
              isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            // Milestone Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: milestone != null ? _domainColor(milestone.domain).withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                LucideIcons.flag,
                size: 18,
                color: milestone != null ? _domainColor(milestone.domain) : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            // Milestone Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone?.title ?? 'No Milestone',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalTasks tasks across ${goalMap.length} goals',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Navigate to Milestone
            if (milestone != null)
              IconButton(
                icon: const Icon(LucideIcons.externalLink, size: 16),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
                    ),
                  );
                },
                tooltip: 'View Milestone',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalHeader(BuildContext context, goal, String goalId, List tasks) {
    final isExpanded = _expandedGoals.contains(goalId);
    final completedCount = tasks.where((t) => t.isCompleted).length;

    return InkWell(
      onTap: () {
        setState(() {
          if (isExpanded) {
            _expandedGoals.remove(goalId);
          } else {
            _expandedGoals.add(goalId);
          }
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            // Expand/Collapse Icon
            Icon(
              isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            // Goal Icon
            const Icon(
              LucideIcons.target,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            // Goal Title
            Expanded(
              child: Text(
                goal.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Progress Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$completedCount/${tasks.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTaskTile(BuildContext context, task) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: task.isCompleted ? Colors.green.withOpacity(0.3) : AppColors.border,
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
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                if (task.isCompleted)
                  const Icon(LucideIcons.check, size: 12, color: Colors.green),
              ],
            ),
            const SizedBox(height: 8),

            // Task title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.3,
                ),
                maxLines: 2,
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
                  size: 10,
                  color: AppColors.textTertiary,
                ),
                const Spacer(),
                // Points
                Text(
                  '${task.totalPoints}',
                  style: const TextStyle(
                    fontSize: 10,
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

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
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
