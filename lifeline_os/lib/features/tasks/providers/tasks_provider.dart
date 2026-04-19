import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/models/task.dart' as model;
import '../../../core/models/subtask.dart' as model;
import '../../../core/providers/database_provider.dart';
import 'tasks_repository.dart';

// All tasks stream
final allTasksProvider = StreamProvider<List<model.Task>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.tasks)
        ..orderBy([
          (tbl) => OrderingTerm.asc(tbl.isCompleted),
          (tbl) => OrderingTerm.desc(tbl.createdAt),
        ]))
      .watch()
      .map((rows) => rows.map(_taskFromRow).toList());
});

// Active tasks stream (not completed)
final activeTasksProvider = StreamProvider<List<model.Task>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.tasks)
        ..where((tbl) => tbl.isCompleted.equals(false))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
      .watch()
      .map((rows) => rows.map(_taskFromRow).toList());
});

// Completed tasks stream
final completedTasksProvider = StreamProvider<List<model.Task>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.tasks)
        ..where((tbl) => tbl.isCompleted.equals(true))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)]))
      .watch()
      .map((rows) => rows.map(_taskFromRow).toList());
});

// Tasks by goal
final tasksByGoalProvider = StreamProvider.family<List<model.Task>, String>((ref, goalId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.tasks)
        ..where((tbl) => tbl.goalId.equals(goalId))
        ..orderBy([
          (tbl) => OrderingTerm.asc(tbl.isCompleted),
          (tbl) => OrderingTerm.desc(tbl.createdAt),
        ]))
      .watch()
      .map((rows) => rows.map(_taskFromRow).toList());
});

// Single task stream
final taskProvider = StreamProvider.family<model.Task, String>((ref, taskId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.tasks)..where((tbl) => tbl.id.equals(taskId)))
      .watchSingle()
      .map(_taskFromRow);
});

// Subtasks for a task
final subtasksProvider = StreamProvider.family<List<model.Subtask>, String>((ref, taskId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.subtasks)
        ..where((tbl) => tbl.taskId.equals(taskId))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
      .watch()
      .map((rows) => rows.map(_subtaskFromRow).toList());
});

// Task filter state providers
enum TaskFilter { all, active, completed }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.active);
final taskFilterGoalProvider = StateProvider<String?>((ref) => null);
final taskFilterPriorityProvider = StateProvider<model.TaskPriority?>((ref) => null);

// Filtered tasks based on all filters
final filteredTasksProvider = StreamProvider<List<model.Task>>((ref) {
  final database = ref.watch(databaseProvider);
  final statusFilter = ref.watch(taskFilterProvider);
  final goalFilter = ref.watch(taskFilterGoalProvider);
  final priorityFilter = ref.watch(taskFilterPriorityProvider);
  
  var query = database.select(database.tasks);
  
  // Apply status filter
  switch (statusFilter) {
    case TaskFilter.active:
      query = query..where((tbl) => tbl.isCompleted.equals(false));
      break;
    case TaskFilter.completed:
      query = query..where((tbl) => tbl.isCompleted.equals(true));
      break;
    case TaskFilter.all:
      break; // No status filter
  }
  
  // Apply goal filter
  if (goalFilter != null) {
    query = query..where((tbl) => tbl.goalId.equals(goalFilter));
  }
  
  // Apply priority filter
  if (priorityFilter != null) {
    query = query..where((tbl) => tbl.priority.equals(priorityFilter.index));
  }
  
  query = query..orderBy([
    (tbl) => OrderingTerm.asc(tbl.isCompleted),
    (tbl) => OrderingTerm.desc(tbl.createdAt),
  ]);
  
  return query.watch().map((rows) => rows.map(_taskFromRow).toList());
});

// Helper to convert database row to Task model
model.Task _taskFromRow(Task row) {
  return model.Task(
    id: row.id,
    title: row.title,
    description: row.description,
    goalId: row.goalId,
    categoryId: row.categoryId,
    priority: model.TaskPriority.values[row.priority],
    energy: model.TaskEnergy.values[row.energy],
    estimatedMinutes: row.estimatedMinutes,
    dueDate: row.dueDate,
    isCompleted: row.isCompleted,
    completedAt: row.completedAt,
    basePoints: row.basePoints,
    totalPoints: row.totalPoints,
    sortOrder: row.sortOrder,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

// Helper to convert database row to Subtask model
model.Subtask _subtaskFromRow(Subtask row) {
  return model.Subtask(
    id: row.id,
    taskId: row.taskId,
    title: row.title,
    isCompleted: row.isCompleted,
    completedAt: row.completedAt,
    points: row.points,
    sortOrder: row.sortOrder,
    createdAt: row.createdAt,
  );
}

