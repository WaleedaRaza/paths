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
                        'Canvas View • Scroll to Zoom',
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

          // Tasks Board View with Interactive Zoom/Pan
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
                    data: (milestones) => InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(2000),
                      minScale: 0.3,
                      maxScale: 2.0,
                      constrained: false,
                      child: _buildBoardView(context, ref, tasks, goals, milestones),
                    ),
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

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain columns with dividers
          ...columnsByDomain.entries.expand((entry) {
            final domain = entry.key;
            final milestoneIds = entry.value;
            return [
              _buildDomainColumn(context, domain, milestoneIds, hierarchy, goals, milestones),
              // Vertical divider
              Container(
                width: 1,
                height: 1000,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.border.withOpacity(0.0),
                      AppColors.border,
                      AppColors.border,
                      AppColors.border.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ];
          }).toList()..removeLast(), // Remove last divider
          // Orphaned tasks column (if any)
          if (orphanedTasks.isNotEmpty) ...[
            Container(
              width: 1,
              height: 1000,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.border.withOpacity(0.0),
                    AppColors.border,
                    AppColors.border,
                    AppColors.border.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            _buildOrphanedColumn(context, orphanedTasks),
          ],
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

    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (color-coded)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              children: [
                Icon(
                  _domainIcon(domain),
                  size: 22,
                  color: _domainColor(domain),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _domainLabel(domain),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _domainColor(domain),
                    ),
                  ),
                ),
                Text(
                  '$totalTasks',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _domainColor(domain).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Column Content
          ...milestoneIds.expand((milestoneId) {
            dynamic milestone;
            try {
              milestone = milestones.firstWhere((m) => m.id == milestoneId);
            } catch (_) {}

            final goalMap = hierarchy[milestoneId]!;
            
            return [
              // Milestone Heading (color-coded)
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.flag,
                        size: 15,
                        color: _domainColor(domain),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          milestone?.title ?? 'No Milestone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _domainColor(domain),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (milestone != null)
                        Icon(
                          LucideIcons.externalLink,
                          size: 13,
                          color: _domainColor(domain).withOpacity(0.5),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Goals under this milestone
              ...goalMap.entries.expand((entry) {
                final goalId = entry.key;
                final goalTasks = entry.value;
                dynamic goal;
                try {
                  goal = goals.firstWhere((g) => g.id == goalId);
                } catch (_) {}

                return [
                  // Goal Heading (color-coded)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.target,
                          size: 13,
                          color: _domainColor(domain).withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            goal?.title ?? 'Unknown Goal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _domainColor(domain).withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${goalTasks.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _domainColor(domain).withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Task Tiles - Modern, Compact, 1 per row
                  ...goalTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildTaskTile(context, task),
                  )),

                  const SizedBox(height: 20),
                ];
              }),

              const SizedBox(height: 12),
            ];
          }),
        ],
      ),
    );
  }

  Widget _buildOrphanedColumn(BuildContext context, List orphanedTasks) {
    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (neutral)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.inbox,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Ungrouped',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${orphanedTasks.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Column Content
          ...orphanedTasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildTaskTile(context, task),
          )),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, task) {
    // Parse description from metadata if available
    String? description;
    try {
      if (task.metadata != null && task.metadata.isNotEmpty) {
        final meta = task.metadata as Map<String, dynamic>?;
        description = meta?['description'] as String?;
      }
    } catch (_) {}

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(taskId: task.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: task.isCompleted 
                ? AppColors.surface.withOpacity(0.5)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: task.isCompleted 
                  ? AppColors.border.withOpacity(0.5)
                  : _priorityColor(task.priority).withOpacity(0.2),
              width: task.priority == TaskPriority.high ? 1.5 : 1,
            ),
            boxShadow: task.isCompleted 
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority stripe
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: _priorityColor(task.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task title
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted 
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Description (if available)
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: task.isCompleted 
                              ? AppColors.textTertiary.withOpacity(0.7)
                              : AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Completion indicator
              if (task.isCompleted)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.check,
                    size: 12,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTaskGrid(BuildContext context, List tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: tasks.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildTaskTile(context, tasks[index]),
      ),
    );
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade400;
      case TaskPriority.medium:
        return Colors.orange.shade400;
      case TaskPriority.low:
        return Colors.blue.shade400;
      case TaskPriority.none:
        return AppColors.border;
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
      case Domain.health:
        return Colors.orange;
      case Domain.dsa:
        return Colors.blue;
      case Domain.finance:
        return Colors.teal;
      case Domain.personal:
        return Colors.pink;
    }
  }
}
