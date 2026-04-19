import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../core/models/subtask.dart' as model;
import '../../../core/providers/database_provider.dart';

/// Watch subtasks for a schedule item's linked task
final scheduleSubtasksProvider = StreamProvider.family<List<model.Subtask>?, String>((ref, scheduleItemId) {
  final database = ref.watch(databaseProvider);
  
  // First get the schedule item to find its taskId
  return (database.select(database.scheduleItems)
        ..where((tbl) => tbl.id.equals(scheduleItemId)))
      .watchSingleOrNull()
      .asyncMap((scheduleItem) async {
        if (scheduleItem?.taskId == null) return null;
        
        // Get subtasks for the linked task
        final subtasks = await (database.select(database.subtasks)
              ..where((tbl) => tbl.taskId.equals(scheduleItem!.taskId!))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
            .get();
        
        return subtasks.map((row) => model.Subtask(
          id: row.id,
          taskId: row.taskId,
          title: row.title,
          isCompleted: row.isCompleted,
          completedAt: row.completedAt,
          points: row.points,
          sortOrder: row.sortOrder,
          createdAt: row.createdAt,
        )).toList();
      });
});

