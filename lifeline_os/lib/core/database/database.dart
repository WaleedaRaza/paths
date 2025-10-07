import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Categories,
  Milestones,
  Goals,
  Tasks,
  Subtasks,
  MustWins,
  ScheduleItems,
  Logs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1 && to == 2) {
            // Add domain and metadata columns to Milestones
            await m.addColumn(milestones, milestones.domain);
            await m.addColumn(milestones, milestones.metadata);
            // Add metadata columns to Goals and Tasks
            await m.addColumn(goals, goals.metadata);
            await m.addColumn(tasks, tasks.metadata);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lifeline_os.db'));
    return NativeDatabase.createInBackground(file);
  });
}

