import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

final totalPointsProvider = StreamProvider<int>((ref) {
  final database = ref.watch(databaseProvider);
  
  // Sum only completed task points
  final taskPoints = database.selectOnly(database.tasks)
    ..where(database.tasks.isCompleted.equals(true))
    ..addColumns([database.tasks.totalPoints.sum()]);
  
  return taskPoints.watch().map((rows) {
    final sum = rows.first.read(database.tasks.totalPoints.sum());
    return sum ?? 0;
  });
});

final streakProvider = StreamProvider<int>((ref) async* {
  final database = ref.watch(databaseProvider);
  
  // Get all completed tasks, ordered by completedAt descending
  final completedTasks = await (database.select(database.tasks)
        ..where((tbl) => tbl.isCompleted.equals(true) & tbl.completedAt.isNotNull())
        ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.completedAt)]))
      .get();
  
  if (completedTasks.isEmpty) {
    yield 0;
    return;
  }

  int streak = 0;
  DateTime? lastDate;
  final Set<String> countedDates = {}; // Track unique dates

  for (final task in completedTasks) {
    if (task.completedAt == null) continue;
    
    final taskDate = DateTime(
      task.completedAt!.year,
      task.completedAt!.month,
      task.completedAt!.day,
    );
    
    final dateKey = '${taskDate.year}-${taskDate.month}-${taskDate.day}';

    if (lastDate == null) {
      // First iteration
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      // Check if the most recent completion was today or yesterday
      if (taskDate == todayDate || 
          taskDate == todayDate.subtract(const Duration(days: 1))) {
        lastDate = taskDate;
        countedDates.add(dateKey);
        streak++;
      } else {
        // Streak is broken
        break;
      }
    } else {
      // Check if this date is exactly one day before the last date
      final expectedDate = lastDate.subtract(const Duration(days: 1));
      if (taskDate == expectedDate && !countedDates.contains(dateKey)) {
        lastDate = taskDate;
        countedDates.add(dateKey);
        streak++;
      } else if (taskDate == lastDate) {
        // Same day, already counted - continue
        continue;
      } else if (taskDate.isBefore(expectedDate)) {
        // Streak is broken
        break;
      }
    }
  }

  yield streak;
});

final todayStatsProvider = StreamProvider<TodayStats>((ref) async* {
  final database = ref.watch(databaseProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

  // Get today's Must-Wins
  final mustWins = await (database.select(database.mustWins)
        ..where((tbl) => tbl.date.isBetweenValues(startOfDay, endOfDay)))
      .get();

  final completedMustWins = mustWins.where((mw) => mw.isCompleted).length;
  final totalMustWins = mustWins.length;

  // Get today's schedule items
  final scheduleItems = await (database.select(database.scheduleItems)
        ..where((tbl) => tbl.date.isBetweenValues(startOfDay, endOfDay)))
      .get();

  final completedScheduleItems = scheduleItems.where((si) => si.isCompleted).length;
  final totalScheduleItems = scheduleItems.length;

  // Get total points
  final totalPoints = await ref.watch(totalPointsProvider.future);

  // Get streak
  final streak = await ref.watch(streakProvider.future);

  yield TodayStats(
    completedMustWins: completedMustWins,
    totalMustWins: totalMustWins,
    completedScheduleItems: completedScheduleItems,
    totalScheduleItems: totalScheduleItems,
    totalPoints: totalPoints,
    streak: streak,
  );
});

class TodayStats {
  final int completedMustWins;
  final int totalMustWins;
  final int completedScheduleItems;
  final int totalScheduleItems;
  final int totalPoints;
  final int streak;

  TodayStats({
    required this.completedMustWins,
    required this.totalMustWins,
    required this.completedScheduleItems,
    required this.totalScheduleItems,
    required this.totalPoints,
    required this.streak,
  });
}

