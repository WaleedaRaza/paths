import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

// Goal statistics
class GoalStats {
  final int totalTasks;
  final int completedTasks;
  final int totalSubGoals;
  final int completedSubGoals;
  final int totalPoints;
  final double progress; // 0.0 to 1.0

  GoalStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.totalSubGoals,
    required this.completedSubGoals,
    required this.totalPoints,
    required this.progress,
  });
}

final goalStatsProvider = StreamProvider.family<GoalStats, String>((ref, goalId) async* {
  final database = ref.watch(databaseProvider);
  
  // Get tasks for this goal
  final tasks = await (database.select(database.tasks)
        ..where((tbl) => tbl.goalId.equals(goalId)))
      .get();
  
  final completedTasks = tasks.where((t) => t.isCompleted).length;
  final totalPoints = tasks.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.totalPoints);
  
  // Get sub-goals
  final subGoals = await (database.select(database.goals)
        ..where((tbl) => tbl.parentGoalId.equals(goalId)))
      .get();
  
  final completedSubGoals = subGoals.where((g) => g.isCompleted).length;
  
  // Calculate progress
  final totalItems = tasks.length + subGoals.length;
  final completedItems = completedTasks + completedSubGoals;
  final progress = totalItems > 0 ? completedItems / totalItems : 0.0;
  
  yield GoalStats(
    totalTasks: tasks.length,
    completedTasks: completedTasks,
    totalSubGoals: subGoals.length,
    completedSubGoals: completedSubGoals,
    totalPoints: totalPoints,
    progress: progress,
  );
});

// Tasks for a specific goal
final tasksByGoalProvider = StreamProvider.family((ref, String goalId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.tasks)
        ..where((tbl) => tbl.goalId.equals(goalId)))
      .watch();
});


