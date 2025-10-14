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
  ChatSessions,
  ChatMessages,
  JournalEntries,
  ExpertPrompts,
  Memories,
  ProjectPlans,
  ProjectSections,
  GenerationJobs,
  KobayashiScenarios,
  KobayashiAnalyses,
  GitRepos,
  SpotifyListens,
  MusicStats,
  SmartPlaylists,
  MusicInsights,
  SpotifyTokens,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

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
          if (from <= 2 && to >= 3) {
            // Add LLM infrastructure tables
            await m.createTable(chatSessions);
            await m.createTable(chatMessages);
            await m.createTable(journalEntries);
            await m.createTable(expertPrompts);
            await m.createTable(memories);
          }
          if (from == 3 && to == 4) {
            // Add Project Planner tables
            await m.createTable(projectPlans);
            await m.createTable(projectSections);
            await m.createTable(generationJobs);
          }
          if (from == 4 && to == 5) {
            // Add Kobayashi Maru social practice tables
            await m.createTable(kobayashiScenarios);
            await m.createTable(kobayashiAnalyses);
          }
          if (from == 5 && to == 6) {
            // Add Git Quick Commit table
            await m.createTable(gitRepos);
          }
          if (from == 6 && to == 7) {
            // Add Music Intelligence tables
            await m.createTable(spotifyListens);
            await m.createTable(musicStats);
            await m.createTable(smartPlaylists);
            await m.createTable(musicInsights);
            await m.createTable(spotifyTokens);
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

