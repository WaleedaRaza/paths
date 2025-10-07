import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/models/task.dart';
import '../../goals/presentation/goal_detail_page.dart';
import '../../goals/providers/goals_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/tasks_repository.dart';
import 'task_detail_page.dart';
import 'widgets/task_modal.dart';

enum TaskFilterStatus { all, active, completed }
enum TaskFilterPriority { all, high, medium, low }

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  TaskFilterStatus _statusFilter = TaskFilterStatus.active;
  TaskFilterPriority _priorityFilter = TaskFilterPriority.all;
  final Set<String> _expandedGoals = {};

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(allTasksProvider);
    final goalsAsync = ref.watch(allGoalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                
                // Priority Filter
                _buildPriorityFilter(),
                const SizedBox(width: 12),
                
                // Status Filter
                _buildStatusFilter(),
              ],
            ),
            
            const SizedBox(height: 8),
            
            tasksAsync.when(
              data: (allTasks) {
                // Apply filters
                var filteredTasks = _applyFilters(allTasks);
                
                return goalsAsync.when(
                  data: (goals) {
                    return Expanded(
                      child: filteredTasks.isEmpty
                          ? _buildEmptyState()
                          : _buildGroupedTaskList(filteredTasks, goals),
                    );
                  },
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Expanded(
                    child: Center(child: Text('Error loading goals')),
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Expanded(
                child: Center(child: Text('Error loading tasks')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TaskModal(),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildFilterButton('All', TaskFilterStatus.all),
          _buildFilterButton('Active', TaskFilterStatus.active),
          _buildFilterButton('Done', TaskFilterStatus.completed),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, TaskFilterStatus status) {
    final isActive = _statusFilter == status;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityFilter() {
    return PopupMenuButton<TaskFilterPriority>(
      initialValue: _priorityFilter,
      onSelected: (value) => setState(() => _priorityFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.filter,
              size: 16,
              color: _priorityFilter == TaskFilterPriority.all
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              _priorityFilter == TaskFilterPriority.all
                  ? 'Priority'
                  : _priorityLabel(_priorityFilter),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _priorityFilter == TaskFilterPriority.all
                    ? AppColors.textSecondary
                    : AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: _priorityFilter == TaskFilterPriority.all
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildPriorityMenuItem('All', TaskFilterPriority.all),
        _buildPriorityMenuItem('High', TaskFilterPriority.high),
        _buildPriorityMenuItem('Medium', TaskFilterPriority.medium),
        _buildPriorityMenuItem('Low', TaskFilterPriority.low),
      ],
    );
  }

  PopupMenuItem<TaskFilterPriority> _buildPriorityMenuItem(
    String label,
    TaskFilterPriority priority,
  ) {
    return PopupMenuItem(
      value: priority,
      child: Row(
        children: [
          if (_priorityFilter == priority)
            const Icon(LucideIcons.check, size: 16, color: AppColors.primary)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  List<Task> _applyFilters(List<Task> tasks) {
    return tasks.where((task) {
      // Status filter
      if (_statusFilter == TaskFilterStatus.active && task.isCompleted) {
        return false;
      }
      if (_statusFilter == TaskFilterStatus.completed && !task.isCompleted) {
        return false;
      }

      // Priority filter
      if (_priorityFilter != TaskFilterPriority.all) {
        final priorityMatch = {
          TaskFilterPriority.high: TaskPriority.high,
          TaskFilterPriority.medium: TaskPriority.medium,
          TaskFilterPriority.low: TaskPriority.low,
        };
        if (task.priority != priorityMatch[_priorityFilter]) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Widget _buildGroupedTaskList(List<Task> tasks, List goals) {
    // Group tasks by goal
    final Map<String?, List<Task>> groupedTasks = {};
    for (final task in tasks) {
      groupedTasks.putIfAbsent(task.goalId, () => []).add(task);
    }

    // Sort: ungrouped first, then by goal
    final ungroupedTasks = groupedTasks[null] ?? [];
    final groupedEntries = groupedTasks.entries
        .where((e) => e.key != null)
        .toList()
      ..sort((a, b) {
        try {
          final goalA = goals.firstWhere((g) => g.id == a.key);
          final goalB = goals.firstWhere((g) => g.id == b.key);
          return goalA.title.compareTo(goalB.title);
        } catch (_) {
          return 0;
        }
      });

    return ListView(
      children: [
        // Count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${tasks.length} tasks',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // Ungrouped section
        if (ungroupedTasks.isNotEmpty) ...[
          _buildGoalHeader(null, ungroupedTasks),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ungroupedTasks.length,
            itemBuilder: (context, index) => _buildCompactTaskTile(ungroupedTasks[index]),
          ),
          const SizedBox(height: 32),
        ],

        // Grouped tasks by goal
        ...groupedEntries.map((entry) {
          try {
            final goal = goals.firstWhere((g) => g.id == entry.key);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGoalHeader(goal, entry.value),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) => _buildCompactTaskTile(entry.value[index]),
                ),
                const SizedBox(height: 32),
              ],
            );
          } catch (_) {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Widget _buildGoalHeader(goal, List<Task> tasks) {
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return Row(
      children: [
        if (goal != null)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GoalDetailPage(goalId: goal.id),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    goal.isCompleted ? LucideIcons.check : LucideIcons.target,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    LucideIcons.externalLink,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          )
        else
          Row(
            children: [
              const Icon(
                LucideIcons.inbox,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ungrouped',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation(
                goal?.isCompleted == true ? AppColors.secondary : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$completedCount/${tasks.length}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: goal?.isCompleted == true ? AppColors.secondary : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalGroupTile(goal, List<Task> tasks) {
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;
    final overdueCount = tasks.where((t) {
      return t.dueDate != null &&
          t.dueDate!.isBefore(DateTime.now()) &&
          !t.isCompleted;
    }).length;

    return InkWell(
      onTap: () {
        if (goal != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GoalDetailPage(goalId: goal.id),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: overdueCount > 0
                ? AppColors.error.withOpacity(0.3)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  goal == null ? LucideIcons.inbox : LucideIcons.target,
                  size: 18,
                  color: goal == null
                      ? AppColors.textSecondary
                      : AppColors.primary,
                ),
                const Spacer(),
                if (overdueCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$overdueCount',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Expanded(
              child: Text(
                goal?.title ?? 'Ungrouped Tasks',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation(
                  overdueCount > 0 ? AppColors.error : AppColors.secondary,
                ),
                minHeight: 4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount/${tasks.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: overdueCount > 0 ? AppColors.error : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUngroupedSection(List<Task> tasks) {
    final isExpanded = _expandedGoals.contains('ungrouped');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedGoals.remove('ungrouped');
                } else {
                  _expandedGoals.add('ungrouped');
                }
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    LucideIcons.inbox,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ungrouped Tasks',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tasks Grid
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) => _buildCompactTaskTile(tasks[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalGroup(goal, List<Task> tasks) {
    final isExpanded = _expandedGoals.contains(goal.id);
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        goal.isCompleted ? LucideIcons.check : LucideIcons.target,
                        size: 18,
                        color: goal.isCompleted ? AppColors.secondary : AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          goal.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: goal.isCompleted
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                            decoration: goal.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$completedCount/${tasks.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Progress bar
                  if (!isExpanded) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Tasks Grid
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) => _buildCompactTaskTile(tasks[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactTaskTile(Task task) {
    final repo = ref.read(tasksRepositoryProvider);
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOverdue
                ? AppColors.error.withOpacity(0.4)
                : task.isCompleted
                    ? AppColors.secondary.withOpacity(0.3)
                    : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: checkbox + indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => repo.toggleTask(task.id, !task.isCompleted),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: task.isCompleted
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        width: 1.5,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(LucideIcons.check, size: 9, color: Colors.white)
                        : null,
                  ),
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Priority indicator
                    if (task.priority != TaskPriority.none)
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _priorityColor(task.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                    
                    // Overdue indicator
                    if (isOverdue) ...[
                      if (task.priority != TaskPriority.none) const SizedBox(width: 3),
                      const Icon(
                        Icons.warning_rounded,
                        size: 10,
                        color: AppColors.error,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 6),
            
            // Title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: task.isCompleted
                      ? AppColors.textTertiary
                      : AppColors.textPrimary,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Time estimate
            if (task.estimatedMinutes != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 8,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${task.estimatedMinutes}m',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.check,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _statusFilter == TaskFilterStatus.completed
                ? 'No completed tasks yet'
                : 'No tasks yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _priorityLabel(TaskFilterPriority priority) {
    switch (priority) {
      case TaskFilterPriority.high:
        return 'High';
      case TaskFilterPriority.medium:
        return 'Medium';
      case TaskFilterPriority.low:
        return 'Low';
      default:
        return 'All';
    }
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.secondary;
      default:
        return AppColors.textTertiary;
    }
  }
}
