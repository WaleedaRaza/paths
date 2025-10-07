import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/models/task.dart' as model;
import '../../../core/models/subtask.dart' as model;
import '../../../core/providers/database_provider.dart';

final tasksRepositoryProvider = Provider((ref) => TasksRepository(ref));

class TasksRepository {
  final Ref ref;
  
  TasksRepository(this.ref);
  
  AppDatabase get _db => ref.read(databaseProvider);

  // Create Task
  Future<String> createTask({
    required String title,
    String? description,
    String? goalId,
    String? categoryId,
    model.TaskPriority priority = model.TaskPriority.none,
    model.TaskEnergy energy = model.TaskEnergy.none,
    int? estimatedMinutes,
    DateTime? dueDate,
    int basePoints = 10,
  }) async {
    final id = const Uuid().v4();
    await _db.into(_db.tasks).insert(
      TasksCompanion.insert(
        id: id,
        title: title,
        description: Value(description),
        goalId: Value(goalId),
        categoryId: Value(categoryId),
        priority: Value(priority.index),
        energy: Value(energy.index),
        estimatedMinutes: Value(estimatedMinutes),
        dueDate: Value(dueDate),
        basePoints: Value(basePoints),
      ),
    );
    return id;
  }

  // Update Task
  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    String? goalId,
    String? categoryId,
    model.TaskPriority? priority,
    model.TaskEnergy? energy,
    int? estimatedMinutes,
    DateTime? dueDate,
    int? basePoints,
  }) async {
    await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(id))).write(
      TasksCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description: description != null ? Value(description) : const Value.absent(),
        goalId: goalId != null ? Value(goalId) : const Value.absent(),
        categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
        priority: priority != null ? Value(priority.index) : const Value.absent(),
        energy: energy != null ? Value(energy.index) : const Value.absent(),
        estimatedMinutes: estimatedMinutes != null ? Value(estimatedMinutes) : const Value.absent(),
        dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
        basePoints: basePoints != null ? Value(basePoints) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Toggle Task Completion
  Future<void> toggleTask(String id, bool isCompleted) async {
    final task = await (_db.select(_db.tasks)..where((tbl) => tbl.id.equals(id))).getSingle();
    
    // Get all subtasks for this task
    final subtasks = await (_db.select(_db.subtasks)..where((tbl) => tbl.taskId.equals(id))).get();
    
    // Calculate total points: basePoints + sum of subtask points
    int totalPoints = task.basePoints;
    if (subtasks.isNotEmpty) {
      totalPoints = subtasks.where((s) => s.isCompleted).fold(0, (sum, s) => sum + s.points);
    }

    await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(id))).write(
      TasksCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
        totalPoints: Value(isCompleted ? totalPoints : 0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Delete Task
  Future<void> deleteTask(String id) async {
    await (_db.delete(_db.tasks)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Bulk Delete Tasks
  Future<void> bulkDeleteTasks(List<String> ids) async {
    await (_db.delete(_db.tasks)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  // Bulk Complete Tasks
  Future<void> bulkCompleteTasks(List<String> ids, bool isCompleted) async {
    for (final id in ids) {
      await toggleTask(id, isCompleted);
    }
  }

  // Create Subtask
  Future<String> createSubtask({
    required String taskId,
    required String title,
    int points = 5,
  }) async {
    final id = const Uuid().v4();
    
    // Get current max sortOrder for this task
    final existing = await (_db.select(_db.subtasks)..where((tbl) => tbl.taskId.equals(taskId))).get();
    final maxOrder = existing.isEmpty ? 0 : existing.map((s) => s.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

    await _db.into(_db.subtasks).insert(
      SubtasksCompanion.insert(
        id: id,
        taskId: taskId,
        title: title,
        points: Value(points),
        sortOrder: Value(maxOrder),
      ),
    );
    
    // Recalculate task totalPoints
    await _recalculateTaskPoints(taskId);
    
    return id;
  }

  // Toggle Subtask Completion
  Future<void> toggleSubtask(String subtaskId, bool isCompleted) async {
    final subtask = await (_db.select(_db.subtasks)..where((tbl) => tbl.id.equals(subtaskId))).getSingle();
    
    await (_db.update(_db.subtasks)..where((tbl) => tbl.id.equals(subtaskId))).write(
      SubtasksCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
      ),
    );
    
    // Recalculate task totalPoints
    await _recalculateTaskPoints(subtask.taskId);
  }

  // Delete Subtask
  Future<void> deleteSubtask(String subtaskId) async {
    final subtask = await (_db.select(_db.subtasks)..where((tbl) => tbl.id.equals(subtaskId))).getSingle();
    await (_db.delete(_db.subtasks)..where((tbl) => tbl.id.equals(subtaskId))).go();
    
    // Recalculate task totalPoints
    await _recalculateTaskPoints(subtask.taskId);
  }

  // Recalculate Task Total Points (sum of completed subtasks or basePoints if no subtasks)
  Future<void> _recalculateTaskPoints(String taskId) async {
    final task = await (_db.select(_db.tasks)..where((tbl) => tbl.id.equals(taskId))).getSingle();
    final subtasks = await (_db.select(_db.subtasks)..where((tbl) => tbl.taskId.equals(taskId))).get();
    
    int totalPoints = task.basePoints;
    if (subtasks.isNotEmpty) {
      final completedSubtasks = subtasks.where((s) => s.isCompleted).toList();
      totalPoints = completedSubtasks.fold(0, (sum, s) => sum + s.points);
    }

    await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(taskId))).write(
      TasksCompanion(
        totalPoints: Value(totalPoints),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

