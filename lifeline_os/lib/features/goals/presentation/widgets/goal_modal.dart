import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../providers/goals_provider.dart';
import '../../providers/goals_repository.dart';
import '../../providers/goal_stats_provider.dart';
import '../../../tasks/providers/tasks_provider.dart' as tasks_providers;
import '../../../tasks/providers/tasks_repository.dart';
import '../../../milestones/providers/milestones_provider.dart';

class GoalModal extends ConsumerStatefulWidget {
  final String? goalId;

  const GoalModal({super.key, this.goalId});

  @override
  ConsumerState<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends ConsumerState<GoalModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  String? _selectedMilestoneId;
  DateTime? _selectedDeadline;
  final List<Map<String, String>> _pendingTasks = []; // For new goals

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _addPendingTask() {
    showDialog(
      context: context,
      builder: (context) {
        final taskTitleController = TextEditingController();
        final taskDescController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskTitleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: taskDescController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskTitleController.text.trim().isNotEmpty) {
                  setState(() {
                    _pendingTasks.add({
                      'title': taskTitleController.text.trim(),
                      'description': taskDescController.text.trim(),
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(goalsRepositoryProvider);
    final milestonesAsync = ref.watch(activeMilestonesProvider);

    if (widget.goalId != null) {
      final goalAsync = ref.watch(goalProvider(widget.goalId!));
      final statsAsync = ref.watch(goalStatsProvider(widget.goalId!));
      final tasksAsync = ref.watch(tasks_providers.tasksByGoalProvider(widget.goalId!));
      
      return goalAsync.when(
        data: (goal) {
          if (_titleController.text.isEmpty) {
            _titleController.text = goal.title;
            _descriptionController.text = goal.description ?? '';
            _selectedMilestoneId = goal.milestoneId;
          }
          return _buildDialog(context, repo, goal, tasksAsync, statsAsync, milestonesAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      );
    }

    return _buildDialog(context, repo, null, const AsyncValue.data([]), const AsyncValue.loading(), milestonesAsync);
  }

  Widget _buildDialog(
    BuildContext context,
    GoalsRepository repo,
    dynamic goal,
    AsyncValue tasksAsync,
    AsyncValue statsAsync,
    AsyncValue milestonesAsync,
  ) {
    return Dialog(
      child: Container(
        width: 650,
        constraints: const BoxConstraints(maxHeight: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.goalId == null ? 'New Goal' : 'Edit Goal',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: widget.goalId == null,
            ),
            const SizedBox(height: 16),
            
            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Milestone Dropdown
            milestonesAsync.when(
              data: (milestones) => DropdownButtonFormField<String>(
                value: _selectedMilestoneId,
                decoration: const InputDecoration(
                  labelText: 'Milestone (optional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('No milestone'),
                  ),
                  ...milestones.map((milestone) {
                    return DropdownMenuItem<String>(
                      value: milestone.id,
                      child: Text(milestone.title),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => _selectedMilestoneId = value);
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Deadline
            TextField(
              controller: _deadlineController,
              decoration: InputDecoration(
                labelText: 'Deadline (optional)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.calendar),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDeadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDeadline = picked;
                        _deadlineController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
              ),
              readOnly: true,
            ),

            // Tasks Section (for new goals only)
            if (widget.goalId == null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _addPendingTask,
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('Add Task'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_pendingTasks.isEmpty)
                const Text(
                  'No tasks added yet. Add tasks to help break down this goal.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                )
              else
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _pendingTasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = _pendingTasks[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.circle, size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (task['description']!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      task['description']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.trash2, size: 16),
                              onPressed: () {
                                setState(() => _pendingTasks.removeAt(index));
                              },
                              color: AppColors.error,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
            
            // Stats (if editing)
            if (widget.goalId != null) ...[
              const SizedBox(height: 16),
              statsAsync.when(
                data: (stats) {
                  if (stats.totalTasks == 0 && stats.totalSubGoals == 0) {
                    return const Text(
                      'No tasks or sub-goals attached yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progress: ${(stats.progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.zap, size: 12, color: AppColors.success),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${stats.totalPoints} pts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: stats.progress,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (stats.totalTasks > 0) ...[
                              Icon(LucideIcons.listChecks, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text(
                                '${stats.completedTasks}/${stats.totalTasks} tasks',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 16),
                            ],
                            if (stats.totalSubGoals > 0) ...[
                              Icon(LucideIcons.target, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text(
                                '${stats.completedSubGoals}/${stats.totalSubGoals} sub-goals',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              
              // Attached Tasks
              const Text(
                'Attached Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Text(
                      'No tasks attached. Create tasks and assign them to this goal in the Tasks page.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  
                  return SizedBox(
                    height: 150,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _buildTaskListItem(task);
                      },
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading tasks'),
              ),
            ],
            
            const Spacer(),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _saveGoal(context, repo),
                  child: Text(widget.goalId == null ? 'Create' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListItem(dynamic task) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.success.withOpacity(0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted ? LucideIcons.check : LucideIcons.circle,
            size: 16,
            color: task.isCompleted ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 13,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
              ),
            ),
          ),
          if (task.totalPoints > 0)
            Text(
              '${task.totalPoints} pts',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveGoal(BuildContext context, GoalsRepository repo) async {
    if (_titleController.text.trim().isEmpty) return;

    if (widget.goalId == null) {
      // Create new goal
      final goalId = await repo.createGoal(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        milestoneId: _selectedMilestoneId,
      );

      // Create all pending tasks for the new goal
      if (_pendingTasks.isNotEmpty && goalId != null) {
        final tasksRepo = ref.read(tasksRepositoryProvider);
        for (final taskData in _pendingTasks) {
          await tasksRepo.createTask(
            title: taskData['title']!,
            description: taskData['description']!.isEmpty ? null : taskData['description'],
            goalId: goalId,
          );
        }
      }
    } else {
      // Update existing goal
      await repo.updateGoal(
        id: widget.goalId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        milestoneId: _selectedMilestoneId,
      );
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
