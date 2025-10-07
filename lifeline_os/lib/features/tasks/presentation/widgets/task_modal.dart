import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../providers/tasks_provider.dart';
import '../../providers/tasks_repository.dart';
import '../../../goals/providers/goals_provider.dart';

class TaskModal extends ConsumerStatefulWidget {
  final String? taskId; // null for creating new task

  const TaskModal({super.key, this.taskId});

  @override
  ConsumerState<TaskModal> createState() => _TaskModalState();
}

class _TaskModalState extends ConsumerState<TaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  
  TaskPriority _priority = TaskPriority.none;
  TaskEnergy _energy = TaskEnergy.none;
  DateTime? _dueDate;
  String? _selectedGoalId;
  
  // For new tasks: store subtasks locally before task is created
  final List<String> _pendingSubtasks = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(tasksRepositoryProvider);
    final goalsAsync = ref.watch(rootGoalsProvider);
    
    // If editing, load task data
    if (widget.taskId != null) {
      final taskAsync = ref.watch(taskProvider(widget.taskId!));
      final subtasksAsync = ref.watch(subtasksProvider(widget.taskId!));

      return taskAsync.when(
        data: (task) {
          // Initialize controllers with task data (only once)
          if (_titleController.text.isEmpty && task.title.isNotEmpty) {
            _titleController.text = task.title;
            _descriptionController.text = task.description ?? '';
            _priority = task.priority;
            _energy = task.energy;
            _dueDate = task.dueDate;
            _selectedGoalId = task.goalId;
          }

          return _buildDialog(context, repo, task, subtasksAsync, goalsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      );
    }

    // Creating new task
    return _buildDialog(context, repo, null, const AsyncValue.data([]), goalsAsync);
  }

  Widget _buildDialog(
    BuildContext context,
    TasksRepository repo,
    Task? existingTask,
    AsyncValue subtasksAsync,
    AsyncValue goalsAsync,
  ) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text(
                  existingTask == null ? 'New Task' : 'Edit Task',
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
            
            // Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            
            // Description Input
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Priority and Energy Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskPriority>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(_priorityLabel(priority)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<TaskEnergy>(
                    value: _energy,
                    decoration: const InputDecoration(
                      labelText: 'Energy',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskEnergy.values.map((energy) {
                      return DropdownMenuItem(
                        value: energy,
                        child: Text(_energyLabel(energy)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _energy = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Goal Dropdown
            goalsAsync.when(
              data: (goals) => DropdownButtonFormField<String>(
                value: _selectedGoalId,
                decoration: const InputDecoration(
                  labelText: 'Goal (optional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('No goal'),
                  ),
                  ...goals.map((goal) {
                    return DropdownMenuItem<String>(
                      value: goal.id,
                      child: Text(goal.title),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => _selectedGoalId = value);
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            
            // Due Date
            OutlinedButton.icon(
              onPressed: () => _selectDueDate(context),
              icon: const Icon(LucideIcons.calendar),
              label: Text(_dueDate == null ? 'Set Due Date' : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
            ),
            
            // Subtasks Section (for both new and existing tasks)
            const SizedBox(height: 24),
            const Text(
              'Subtasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            // Show existing subtasks OR pending subtasks
            if (existingTask != null)
              subtasksAsync.when(
                data: (subtasks) => SizedBox(
                  height: 150,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: subtasks.length + 1,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == subtasks.length) {
                        // Add subtask input for existing task
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _subtaskController,
                                decoration: const InputDecoration(
                                  hintText: 'Add subtask...',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onSubmitted: (_) => _addSubtask(repo, existingTask.id),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.plus),
                              onPressed: () => _addSubtask(repo, existingTask.id),
                              color: AppColors.primary,
                            ),
                          ],
                        );
                      }

                      final subtask = subtasks[index];
                      return Row(
                        children: [
                          Checkbox(
                            value: subtask.isCompleted,
                            onChanged: (value) => repo.toggleSubtask(subtask.id, value ?? false),
                          ),
                          Expanded(
                            child: Text(
                              subtask.title,
                              style: TextStyle(
                                decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          Text('${subtask.points} pts', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 16),
                            onPressed: () => repo.deleteSubtask(subtask.id),
                            color: AppColors.textTertiary,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading subtasks'),
              )
            else
              // For new tasks: show pending subtasks
              SizedBox(
                height: 150,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _pendingSubtasks.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index == _pendingSubtasks.length) {
                      // Add subtask input for new task
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _subtaskController,
                              decoration: const InputDecoration(
                                hintText: 'Add subtask...',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onSubmitted: (_) => _addPendingSubtask(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.plus),
                            onPressed: _addPendingSubtask,
                            color: AppColors.primary,
                          ),
                        ],
                      );
                    }

                    final subtaskTitle = _pendingSubtasks[index];
                    return Row(
                      children: [
                        const Icon(Icons.check_box_outline_blank, size: 20, color: AppColors.textTertiary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(subtaskTitle),
                        ),
                        const Text('+1 pt', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                        IconButton(
                          icon: const Icon(LucideIcons.trash2, size: 16),
                          onPressed: () {
                            setState(() {
                              _pendingSubtasks.removeAt(index);
                            });
                          },
                          color: AppColors.textTertiary,
                        ),
                      ],
                    );
                  },
                ),
              ),
            
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
                  onPressed: () => _saveTask(context, repo, existingTask),
                  child: Text(existingTask == null ? 'Create' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.none:
        return 'None';
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  String _energyLabel(TaskEnergy energy) {
    switch (energy) {
      case TaskEnergy.none:
        return 'None';
      case TaskEnergy.low:
        return 'Low 🔥';
      case TaskEnergy.medium:
        return 'Medium 🔥🔥';
      case TaskEnergy.high:
        return 'High 🔥🔥🔥';
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveTask(BuildContext context, TasksRepository repo, Task? existingTask) async {
    if (_titleController.text.trim().isEmpty) return;

    if (existingTask == null) {
      // Create new task
      final taskId = await repo.createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        priority: _priority,
        energy: _energy,
        dueDate: _dueDate,
        goalId: _selectedGoalId,
      );
      
      // Create all pending subtasks
      for (final subtaskTitle in _pendingSubtasks) {
        await repo.createSubtask(
          taskId: taskId,
          title: subtaskTitle,
        );
      }
    } else {
      // Update existing task
      await repo.updateTask(
        id: existingTask.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        priority: _priority,
        energy: _energy,
        dueDate: _dueDate,
        goalId: _selectedGoalId,
      );
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _addSubtask(TasksRepository repo, String taskId) async {
    if (_subtaskController.text.trim().isEmpty) return;

    await repo.createSubtask(
      taskId: taskId,
      title: _subtaskController.text.trim(),
    );
    _subtaskController.clear();
  }
  
  void _addPendingSubtask() {
    if (_subtaskController.text.trim().isEmpty) return;
    
    setState(() {
      _pendingSubtasks.add(_subtaskController.text.trim());
    });
    _subtaskController.clear();
  }
}

