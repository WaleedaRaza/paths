import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../core/models/schedule_item.dart' as model;
import '../../../core/providers/database_provider.dart';

final scheduleProvider = StreamProvider.family<List<model.ScheduleItem>, DateTime>((ref, date) {
  final database = ref.watch(databaseProvider);
  
  // Get start and end of day
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  return (database.select(database.scheduleItems)
        ..where((tbl) => tbl.date.isBiggerOrEqualValue(startOfDay) & tbl.date.isSmallerOrEqualValue(endOfDay))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.startTime)]))
      .watch()
      .map((rows) => rows.map((row) => model.ScheduleItem(
            id: row.id,
            date: row.date,
            taskId: row.taskId,
            title: row.title,
            startTime: row.startTime,
            endTime: row.endTime,
            isCompleted: row.isCompleted,
            completedAt: row.completedAt,
            createdAt: row.createdAt,
          )).toList());
});

final scheduleRepositoryProvider = Provider((ref) => ScheduleRepository(ref));

class ScheduleRepository {
  final Ref ref;
  
  ScheduleRepository(this.ref);
  
  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> addScheduleItem({
    required DateTime date,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? taskId,
  }) async {
    await _db.into(_db.scheduleItems).insert(
      ScheduleItemsCompanion.insert(
        id: const Uuid().v4(),
        date: date,
        title: title,
        startTime: startTime,
        endTime: endTime,
        taskId: Value(taskId),
      ),
    );
  }

  Future<void> toggleScheduleItem(String id, bool isCompleted) async {
    // Get the schedule item to check if it has a linked task
    final scheduleItem = await (_db.select(_db.scheduleItems)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    
    if (scheduleItem != null) {
      // Update the schedule item
      await (_db.update(_db.scheduleItems)..where((tbl) => tbl.id.equals(id))).write(
        ScheduleItemsCompanion(
          isCompleted: Value(isCompleted),
          completedAt: Value(isCompleted ? DateTime.now() : null),
        ),
      );
      
      // If there's a linked task, update it too
      if (scheduleItem.taskId != null) {
        await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(scheduleItem.taskId!))).write(
          TasksCompanion(
            isCompleted: Value(isCompleted),
            completedAt: Value(isCompleted ? DateTime.now() : null),
          ),
        );
      }
    }
  }

  Future<void> updateScheduleItem({
    required String id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    await (_db.update(_db.scheduleItems)..where((tbl) => tbl.id.equals(id))).write(
      ScheduleItemsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        startTime: startTime != null ? Value(startTime) : const Value.absent(),
        endTime: endTime != null ? Value(endTime) : const Value.absent(),
      ),
    );
  }

  Future<void> updateScheduleItemTime(String id, DateTime startTime, DateTime endTime) async {
    await (_db.update(_db.scheduleItems)..where((tbl) => tbl.id.equals(id))).write(
      ScheduleItemsCompanion(
        startTime: Value(startTime),
        endTime: Value(endTime),
      ),
    );
  }

  Future<void> deleteScheduleItem(String id) async {
    await (_db.delete(_db.scheduleItems)..where((tbl) => tbl.id.equals(id))).go();
  }
}

