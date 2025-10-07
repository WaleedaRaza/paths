import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

final totalPointsProvider = StreamProvider<int>((ref) {
  final database = ref.watch(databaseProvider);
  
  // Sum all task points
  final taskPoints = database.selectOnly(database.tasks)
    ..addColumns([database.tasks.totalPoints.sum()]);
  
  return taskPoints.watch().map((rows) {
    final sum = rows.first.read(database.tasks.totalPoints.sum());
    return sum ?? 0;
  });
});

final streakProvider = StreamProvider<int>((ref) async* {
  final database = ref.watch(databaseProvider);
  
  // Get all completed Must-Wins, ordered by date descending
  final completedMustWins = await (database.select(database.mustWins)
        ..where((tbl) => tbl.isCompleted.equals(true))
        ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.date)]))
      .get();
  
  if (completedMustWins.isEmpty) {
    yield 0;
    return;
  }

  int streak = 0;
  DateTime? lastDate;

  for (final mustWin in completedMustWins) {
    final mustWinDate = DateTime(
      mustWin.date.year,
      mustWin.date.month,
      mustWin.date.day,
    );

    if (lastDate == null) {
      // First iteration
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      // Check if the most recent completion was today or yesterday
      if (mustWinDate == todayDate || 
          mustWinDate == todayDate.subtract(const Duration(days: 1))) {
        lastDate = mustWinDate;
        streak++;
      } else {
        // Streak is broken
        break;
      }
    } else {
      // Check if this date is exactly one day before the last date
      final expectedDate = lastDate.subtract(const Duration(days: 1));
      if (mustWinDate == expectedDate) {
        lastDate = mustWinDate;
        streak++;
      } else if (mustWinDate == lastDate) {
        // Same day, don't increment streak but continue
        continue;
      } else {
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

