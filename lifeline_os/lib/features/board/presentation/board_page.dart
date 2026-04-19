import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/tables.dart';
import '../../../core/models/task.dart';
import '../../goals/providers/goals_provider.dart';
import '../../milestones/presentation/milestone_detail_page.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../../tasks/presentation/task_detail_page.dart';
import '../../tasks/providers/tasks_provider.dart';

class BoardPage extends ConsumerStatefulWidget {
  const BoardPage({super.key});

  @override
  ConsumerState<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends ConsumerState<BoardPage> {
  final Set<String> _expandedMilestones = {};
  final Set<String> _expandedGoals = {};

  final List<Domain> _columns = [
    Domain.school,
    Domain.projects,
    Domain.finance,
    Domain.dsa,
    Domain.health,
    Domain.personal,
  ];

  @override
  Widget build(BuildContext context) {
    final milestonesAsync = ref.watch(allMilestonesProvider);
    final goalsAsync = ref.watch(allGoalsProvider);
    final tasksAsync = ref.watch(allTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Text(
                  'Board View',
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
                    'Kanban View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      // Collapse all
                      _expandedMilestones.clear();
                      _expandedGoals.clear();
                    });
                  },
                  icon: const Icon(LucideIcons.minimize2, size: 18),
                  tooltip: 'Collapse All',
                ),
                IconButton(
                  onPressed: () {
                    // Expand all (will be filled with actual IDs)
                    milestonesAsync.whenData((milestones) {
                      goalsAsync.whenData((goals) {
                        setState(() {
                          _expandedMilestones.addAll(milestones.map((m) => m.id));
                          _expandedGoals.addAll(goals.map((g) => g.id));
                        });
                      });
                    });
                  },
                  icon: const Icon(LucideIcons.maximize2, size: 18),
                  tooltip: 'Expand All',
                ),
              ],
            ),
          ),

          // Board Columns
          Expanded(
            child: milestonesAsync.when(
              data: (milestones) => goalsAsync.when(
                data: (goals) => tasksAsync.when(
                  data: (tasks) => _buildBoard(milestones, goals, tasks),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error loading tasks')),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading goals')),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading milestones')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(List milestones, List goals, List tasks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _columns.map((domain) {
          return _buildColumn(domain, milestones, goals, tasks);
        }).toList(),
      ),
    );
  }

  Widget _buildColumn(Domain domain, List milestones, List goals, List tasks) {
    // Filter milestones for this domain
    final domainMilestones = milestones.where((m) => m.domain == domain).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first

    // Count items
    int goalCount = 0;
    int taskCount = 0;
    for (final milestone in domainMilestones) {
      final milestoneGoals = goals.where((g) => g.milestoneId == milestone.id);
      goalCount += milestoneGoals.length;
      for (final goal in milestoneGoals) {
        taskCount += tasks.where((t) => t.goalId == goal.id).length;
      }
    }

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _domainColor(domain).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: _domainColor(domain).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _domainIcon(domain),
                      size: 20,
                      color: _domainColor(domain),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _domainLabel(domain),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _domainColor(domain),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${domainMilestones.length} milestones • $goalCount goals • $taskCount tasks',
                  style: TextStyle(
                    fontSize: 11,
                    color: _domainColor(domain).withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Column Content (scrollable)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border.all(color: AppColors.border),
              ),
              child: domainMilestones.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.inbox,
                              size: 32,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No milestones',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: domainMilestones.length,
                      itemBuilder: (context, index) {
                        return _buildMilestoneCard(
                          domainMilestones[index],
                          goals,
                          tasks,
                          domain,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(milestone, List goals, List tasks, Domain domain) {
    final isExpanded = _expandedMilestones.contains(milestone.id);
    final milestoneGoals = goals.where((g) => g.milestoneId == milestone.id).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedMilestones.remove(milestone.id);
                  // Collapse all goals under this milestone
                  for (final goal in milestoneGoals) {
                    _expandedGoals.remove(goal.id);
                  }
                } else {
                  _expandedMilestones.add(milestone.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 16,
                    color: _domainColor(domain),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      milestone.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.externalLink, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Goals under this milestone (if expanded)
          if (isExpanded) ...[
            if (milestoneGoals.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 12, right: 12),
                child: Text(
                  'No goals yet',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...milestoneGoals.map((goal) {
                return _buildGoalCard(goal, tasks, domain);
              }),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalCard(goal, List tasks, Domain domain) {
    final isExpanded = _expandedGoals.contains(goal.id);
    final goalTasks = tasks.where((t) => t.goalId == goal.id).toList();
    final completedTasks = goalTasks.where((t) => t.isCompleted).length;

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedGoals.remove(goal.id);
                } else {
                  _expandedGoals.add(goal.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 14,
                    color: _domainColor(domain),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Progress badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _domainColor(domain).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$completedTasks/${goalTasks.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _domainColor(domain),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tasks under this goal (if expanded)
          if (isExpanded) ...[
            if (goalTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 8, right: 10),
                child: Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 8, bottom: 8),
                child: Column(
                  children: goalTasks.map((task) {
                    return _buildTaskItem(task, domain);
                  }).toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem(task, Domain domain) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: task.isCompleted ? AppColors.background.withOpacity(0.5) : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: task.isCompleted
                ? Colors.green.withOpacity(0.3)
                : _priorityColor(task.priority).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task title with status
            Row(
              children: [
                // Status checkbox
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: task.isCompleted ? Colors.green : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted ? Colors.green : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: task.isCompleted
                      ? const Icon(LucideIcons.check, size: 10, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 6),
                // Priority indicator
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                // Title
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Task metadata (if available)
            if (task.dueDate != null || task.estimatedMinutes != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  if (task.dueDate != null) ...[
                    Icon(
                      LucideIcons.calendar,
                      size: 9,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${task.dueDate!.month}/${task.dueDate!.day}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (task.estimatedMinutes != null) ...[
                    Icon(
                      LucideIcons.clock,
                      size: 9,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${task.estimatedMinutes}m',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Points
                  Text(
                    '${task.totalPoints}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: _domainColor(domain),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
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
        return 'LeetCode';
      case Domain.career:
        return 'Career';
      case Domain.gre:
        return 'GRE';
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
      case Domain.career:
        return LucideIcons.briefcase;
      case Domain.gre:
        return LucideIcons.bookOpen;
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
      case Domain.career:
        return Colors.cyan;
      case Domain.gre:
        return Colors.amber;
      case Domain.personal:
        return Colors.pink;
    }
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
}

