import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../core/models/must_win.dart' as model;
import '../../../core/providers/database_provider.dart';

final mustWinsProvider = StreamProvider.family<List<model.MustWin>, DateTime>((ref, date) {
  final database = ref.watch(databaseProvider);
  
  // Get start and end of day
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  return (database.select(database.mustWins)
        ..where((tbl) => tbl.date.isBiggerOrEqualValue(startOfDay) & tbl.date.isSmallerOrEqualValue(endOfDay))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
      .watch()
      .map((rows) => rows.map((row) => model.MustWin(
            id: row.id,
            date: row.date,
            taskId: row.taskId,
            title: row.title,
            isCompleted: row.isCompleted,
            completedAt: row.completedAt,
            sortOrder: row.sortOrder,
            createdAt: row.createdAt,
          )).toList());
});

final mustWinsRepositoryProvider = Provider((ref) => MustWinsRepository(ref));

class MustWinsRepository {
  final Ref ref;
  
  MustWinsRepository(this.ref);
  
  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> addMustWin(DateTime date, String title, {String? taskId}) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final existing = await (_db.select(_db.mustWins)
          ..where((tbl) => tbl.date.isBiggerOrEqualValue(startOfDay) & tbl.date.isSmallerOrEqualValue(endOfDay)))
        .get();
    
    if (existing.length >= 3) {
      throw Exception('Cannot add more than 3 Must-Wins per day');
    }

    await _db.into(_db.mustWins).insert(
      MustWinsCompanion.insert(
        id: const Uuid().v4(),
        date: date,
        title: title,
        taskId: Value(taskId),
        sortOrder: Value(existing.length),
      ),
    );
  }

  Future<void> toggleMustWin(String id, bool isCompleted) async {
    await (_db.update(_db.mustWins)..where((tbl) => tbl.id.equals(id))).write(
      MustWinsCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
      ),
    );
  }

  Future<void> updateMustWinTitle(String id, String title) async {
    await (_db.update(_db.mustWins)..where((tbl) => tbl.id.equals(id))).write(
      MustWinsCompanion(
        title: Value(title),
      ),
    );
  }

  Future<void> deleteMustWin(String id) async {
    await (_db.delete(_db.mustWins)..where((tbl) => tbl.id.equals(id))).go();
  }
}

