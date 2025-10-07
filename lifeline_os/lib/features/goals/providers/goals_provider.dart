import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/models/goal.dart' as model;
import '../../../core/providers/database_provider.dart';

// All goals stream
final allGoalsProvider = StreamProvider<List<model.Goal>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.goals)
        ..orderBy([
          (tbl) => OrderingTerm.asc(tbl.sortOrder),
          (tbl) => OrderingTerm.desc(tbl.createdAt),
        ]))
      .watch()
      .map((rows) => rows.map(_goalFromRow).toList());
});

// Goals by milestone
final goalsByMilestoneProvider = StreamProvider.family<List<model.Goal>, String>((ref, milestoneId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.goals)
        ..where((tbl) => tbl.milestoneId.equals(milestoneId))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
      .watch()
      .map((rows) => rows.map(_goalFromRow).toList());
});

// Root goals (no parent)
final rootGoalsProvider = StreamProvider<List<model.Goal>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.goals)
        ..where((tbl) => tbl.parentGoalId.isNull())
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
      .watch()
      .map((rows) => rows.map(_goalFromRow).toList());
});

// Child goals of a parent goal
final childGoalsProvider = StreamProvider.family<List<model.Goal>, String>((ref, parentId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.goals)
        ..where((tbl) => tbl.parentGoalId.equals(parentId))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
      .watch()
      .map((rows) => rows.map(_goalFromRow).toList());
});

// Single goal
final goalProvider = StreamProvider.family<model.Goal, String>((ref, goalId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.goals)..where((tbl) => tbl.id.equals(goalId)))
      .watchSingle()
      .map(_goalFromRow);
});

// Helper to convert database row to Goal model
model.Goal _goalFromRow(Goal row) {
  return model.Goal(
    id: row.id,
    title: row.title,
    description: row.description,
    milestoneId: row.milestoneId,
    parentGoalId: row.parentGoalId,
    sortOrder: row.sortOrder,
    isCompleted: row.isCompleted,
    completedAt: row.completedAt,
    totalPoints: row.totalPoints,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

