import '../../../core/models/task.dart';
import '../providers/tasks_repository.dart';
import '../models/recurring_pattern.dart';

/// Service for cloning and recurring tasks
class TaskCloner {
  /// Clone a task (useful for recurring workouts, habits, etc.)
  static Future<String> cloneTask({
    required TasksRepository repo,
    required Task sourceTask,
    DateTime? newDueDate,
    bool clearCompletionStatus = true,
  }) async {
    final newTaskId = await repo.createTask(
      title: sourceTask.title,
      description: sourceTask.description,
      priority: sourceTask.priority,
      energy: sourceTask.energy,
      estimatedMinutes: sourceTask.estimatedMinutes,
      dueDate: newDueDate ?? sourceTask.dueDate,
      goalId: sourceTask.goalId,
      basePoints: sourceTask.basePoints,
    );
    
    // Clone subtasks if any
    // Note: would need to fetch subtasks and recreate them
    // For now, just clone the main task
    
    return newTaskId;
  }
  
  /// Check if task should recur today based on pattern
  static bool shouldRecurToday(RecurringPattern pattern, DateTime lastCompleted, DateTime today) {
    switch (pattern.type) {
      case RecurringType.none:
        return false;
        
      case RecurringType.daily:
        // Recur every day after last completion
        final daysSince = today.difference(lastCompleted).inDays;
        return daysSince >= 1;
        
      case RecurringType.weekly:
        final daysSince = today.difference(lastCompleted).inDays;
        return daysSince >= 7;
        
      case RecurringType.weekdays:
        // Monday=1, Sunday=7
        final weekday = today.weekday;
        return weekday >= 1 && weekday <= 5;
        
      case RecurringType.custom:
        if (pattern.weekdays != null && pattern.weekdays!.isNotEmpty) {
          return pattern.weekdays!.contains(today.weekday);
        }
        if (pattern.intervalDays != null) {
          final daysSince = today.difference(lastCompleted).inDays;
          return daysSince >= pattern.intervalDays!;
        }
        return false;
    }
  }
}

