import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

final goalsRepositoryProvider = Provider((ref) => GoalsRepository(ref));

class GoalsRepository {
  final Ref ref;
  
  GoalsRepository(this.ref);
  
  AppDatabase get _db => ref.read(databaseProvider);

  // Create Goal
  Future<String> createGoal({
    required String title,
    String? description,
    String? milestoneId,
    String? parentGoalId,
  }) async {
    final id = const Uuid().v4();
    
    // Get max sortOrder for goals at this level
    final existing = await (_db.select(_db.goals)
          ..where((tbl) {
            if (parentGoalId != null) {
              return tbl.parentGoalId.equals(parentGoalId);
            } else {
              return tbl.parentGoalId.isNull();
            }
          }))
        .get();
    
    final maxOrder = existing.isEmpty ? 0 : existing.map((g) => g.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

    await _db.into(_db.goals).insert(
      GoalsCompanion.insert(
        id: id,
        title: title,
        description: Value(description),
        milestoneId: Value(milestoneId),
        parentGoalId: Value(parentGoalId),
        sortOrder: Value(maxOrder),
      ),
    );
    return id;
  }

  // Update Goal
  Future<void> updateGoal({
    required String id,
    String? title,
    String? description,
    String? milestoneId,
  }) async {
    await (_db.update(_db.goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description: description != null ? Value(description) : const Value.absent(),
        milestoneId: milestoneId != null ? Value(milestoneId) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Toggle Goal Completion
  Future<void> toggleGoal(String id, bool isCompleted) async {
    final goal = await (_db.select(_db.goals)..where((tbl) => tbl.id.equals(id))).getSingle();
    
    // Get all tasks for this goal
    final tasks = await (_db.select(_db.tasks)..where((tbl) => tbl.goalId.equals(id))).get();
    
    // Calculate total points from completed tasks
    int totalPoints = 0;
    if (tasks.isNotEmpty) {
      totalPoints = tasks.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.totalPoints);
    }

    await (_db.update(_db.goals)..where((tbl) => tbl.id.equals(id))).write(
      GoalsCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
        totalPoints: Value(isCompleted ? totalPoints : 0),
        updatedAt: Value(DateTime.now()),
      ),
    );
    
    // If this goal has a milestone, recalculate milestone points
    if (goal.milestoneId != null) {
      await _recalculateMilestonePoints(goal.milestoneId!);
    }
  }

  // Delete Goal
  Future<void> deleteGoal(String id) async {
    await (_db.delete(_db.goals)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Recalculate Milestone Points
  Future<void> _recalculateMilestonePoints(String milestoneId) async {
    final goals = await (_db.select(_db.goals)..where((tbl) => tbl.milestoneId.equals(milestoneId))).get();
    
    int totalPoints = 0;
    if (goals.isNotEmpty) {
      totalPoints = goals.where((g) => g.isCompleted).fold(0, (sum, g) => sum + g.totalPoints);
    }

    await (_db.update(_db.milestones)..where((tbl) => tbl.id.equals(milestoneId))).write(
      MilestonesCompanion(
        totalPoints: Value(totalPoints),
        updatedAt: Value(DateTime.now()),
      ),
    );
    
    // Check if milestone should auto-complete (all goals done)
    if (goals.isNotEmpty) {
      final completedCount = goals.where((g) => g.isCompleted).length;
      if (completedCount == goals.length) {
        await (_db.update(_db.milestones)..where((tbl) => tbl.id.equals(milestoneId))).write(
          MilestonesCompanion(
            isCompleted: const Value(true),
            completedAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }
}

