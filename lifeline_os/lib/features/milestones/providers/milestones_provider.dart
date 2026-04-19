import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/database/tables.dart';
import '../../../core/models/milestone.dart' as model;
import '../../../core/providers/database_provider.dart';

// All milestones stream
final allMilestonesProvider = StreamProvider<List<model.Milestone>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.milestones)
        ..orderBy([
          (tbl) => OrderingTerm.asc(tbl.isCompleted),
          (tbl) => OrderingTerm.desc(tbl.createdAt),
        ]))
      .watch()
      .map((rows) => rows.map(_milestoneFromRow).toList());
});

// Active milestones (not completed)
final activeMilestonesProvider = StreamProvider<List<model.Milestone>>((ref) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.milestones)
        ..where((tbl) => tbl.isCompleted.equals(false))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
      .watch()
      .map((rows) => rows.map(_milestoneFromRow).toList());
});

// Single milestone
final milestoneProvider = StreamProvider.family<model.Milestone, String>((ref, milestoneId) {
  final database = ref.watch(databaseProvider);
  
  return (database.select(database.milestones)..where((tbl) => tbl.id.equals(milestoneId)))
      .watchSingle()
      .map(_milestoneFromRow);
});

// Alias for milestone provider (for clarity in goal_card.dart)
final milestoneByIdProvider = milestoneProvider;

// Filter state providers
final milestoneFilterDomainProvider = StateProvider<Domain?>((ref) => null);
final milestoneFilterStatusProvider = StateProvider<bool?>((ref) => null); // null = all, true = completed, false = active

// Filtered milestones based on current filters
final filteredMilestonesProvider = StreamProvider<List<model.Milestone>>((ref) {
  final database = ref.watch(databaseProvider);
  final filterDomain = ref.watch(milestoneFilterDomainProvider);
  final filterStatus = ref.watch(milestoneFilterStatusProvider);
  
  var query = database.select(database.milestones);
  
  // Apply domain filter
  if (filterDomain != null) {
    query = query..where((tbl) => tbl.domain.equals(filterDomain.index));
  }
  
  // Apply status filter
  if (filterStatus != null) {
    query = query..where((tbl) => tbl.isCompleted.equals(filterStatus));
  }
  
  query = query..orderBy([
    (tbl) => OrderingTerm.asc(tbl.isCompleted),
    (tbl) => OrderingTerm.desc(tbl.createdAt),
  ]);
  
  return query.watch().map((rows) => rows.map(_milestoneFromRow).toList());
});

// Helper to convert database row to Milestone model
model.Milestone _milestoneFromRow(Milestone row) {
  return model.Milestone(
    id: row.id,
    title: row.title,
    description: row.description,
    categoryId: row.categoryId,
    domain: row.domain,
    metadata: row.metadata,
    deadline: row.deadline,
    isCompleted: row.isCompleted,
    completedAt: row.completedAt,
    totalPoints: row.totalPoints,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

