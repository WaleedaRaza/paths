import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

// Milestone statistics
class MilestoneStats {
  final int totalGoals;
  final int completedGoals;
  final int totalTasks;
  final int completedTasks;
  final int totalPoints;
  final double progress; // 0.0 to 1.0

  MilestoneStats({
    required this.totalGoals,
    required this.completedGoals,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalPoints,
    required this.progress,
  });
}

final milestoneStatsProvider = StreamProvider.family<MilestoneStats, String>((ref, milestoneId) async* {
  final database = ref.watch(databaseProvider);
  
  // Get goals for this milestone
  final goals = await (database.select(database.goals)
        ..where((tbl) => tbl.milestoneId.equals(milestoneId)))
      .get();
  
  final completedGoals = goals.where((g) => g.isCompleted).length;
  
  // Get all tasks for these goals
  int totalTasks = 0;
  int completedTasks = 0;
  int totalPoints = 0;
  
  for (final goal in goals) {
    final tasks = await (database.select(database.tasks)
          ..where((tbl) => tbl.goalId.equals(goal.id)))
        .get();
    
    totalTasks += tasks.length;
    completedTasks += tasks.where((t) => t.isCompleted).length;
    totalPoints += tasks.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.totalPoints);
  }
  
  // Calculate progress based on completed goals
  final progress = goals.isNotEmpty ? completedGoals / goals.length : 0.0;
  
  yield MilestoneStats(
    totalGoals: goals.length,
    completedGoals: completedGoals,
    totalTasks: totalTasks,
    completedTasks: completedTasks,
    totalPoints: totalPoints,
    progress: progress,
  );
});


