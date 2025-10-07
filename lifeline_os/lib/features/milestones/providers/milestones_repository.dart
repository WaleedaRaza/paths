import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';

final milestonesRepositoryProvider = Provider((ref) => MilestonesRepository(ref));

class MilestonesRepository {
  final Ref ref;
  
  MilestonesRepository(this.ref);
  
  AppDatabase get _db => ref.read(databaseProvider);

  // Create Milestone
  Future<String> createMilestone({
    required String title,
    String? description,
    String? categoryId,
    DateTime? deadline,
  }) async {
    final id = const Uuid().v4();
    await _db.into(_db.milestones).insert(
      MilestonesCompanion.insert(
        id: id,
        title: title,
        description: Value(description),
        categoryId: Value(categoryId),
        deadline: Value(deadline),
      ),
    );
    return id;
  }

  // Update Milestone
  Future<void> updateMilestone({
    required String id,
    String? title,
    String? description,
    String? categoryId,
    DateTime? deadline,
  }) async {
    await (_db.update(_db.milestones)..where((tbl) => tbl.id.equals(id))).write(
      MilestonesCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description: description != null ? Value(description) : const Value.absent(),
        categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
        deadline: deadline != null ? Value(deadline) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Toggle Milestone Completion
  Future<void> toggleMilestone(String id, bool isCompleted) async {
    await (_db.update(_db.milestones)..where((tbl) => tbl.id.equals(id))).write(
      MilestonesCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Delete Milestone
  Future<void> deleteMilestone(String id) async {
    await (_db.delete(_db.milestones)..where((tbl) => tbl.id.equals(id))).go();
  }
}

