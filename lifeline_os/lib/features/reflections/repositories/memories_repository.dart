import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';

/// Repository for managing persistent memories for LLM context
class MemoriesRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  MemoriesRepository(this.db);

  /// Create a new memory
  Future<Memory> createMemory({
    required String content,
    required String source,
    List<String>? relatedExpertIds,
  }) async {
    final memory = MemoriesCompanion.insert(
      id: _uuid.v4(),
      content: content,
      source: source,
      relatedExpertIds: Value(relatedExpertIds?.join(',') ?? ''),
      createdAt: Value(DateTime.now()),
      isActive: const Value(true),
    );

    await db.into(db.memories).insert(memory);
    
    return await (db.select(db.memories)
          ..where((m) => m.id.equals(memory.id.value)))
        .getSingle();
  }

  /// Watch all active memories
  Stream<List<Memory>> watchActiveMemories() {
    return (db.select(db.memories)
          ..where((m) => m.isActive.equals(true))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .watch();
  }

  /// Get all active memories
  Future<List<Memory>> getActiveMemories() async {
    return await (db.select(db.memories)
          ..where((m) => m.isActive.equals(true))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Update memory content
  Future<void> updateMemory(String memoryId, String content) async {
    await (db.update(db.memories)
          ..where((m) => m.id.equals(memoryId)))
        .write(MemoriesCompanion(content: Value(content)));
  }

  /// Archive a memory (soft delete)
  Future<void> archiveMemory(String memoryId) async {
    await (db.update(db.memories)
          ..where((m) => m.id.equals(memoryId)))
        .write(const MemoriesCompanion(isActive: Value(false)));
  }

  /// Restore an archived memory
  Future<void> restoreMemory(String memoryId) async {
    await (db.update(db.memories)
          ..where((m) => m.id.equals(memoryId)))
        .write(const MemoriesCompanion(isActive: Value(true)));
  }

  /// Delete a memory permanently
  Future<void> deleteMemory(String memoryId) async {
    await (db.delete(db.memories)
          ..where((m) => m.id.equals(memoryId)))
        .go();
  }

  /// Get memories related to specific expert
  Future<List<Memory>> getMemoriesForExpert(String expertId) async {
    final allMemories = await getActiveMemories();
    return allMemories.where((m) {
      if (m.relatedExpertIds == null || m.relatedExpertIds!.isEmpty) {
        return true; // Global memory
      }
      return m.relatedExpertIds!.split(',').contains(expertId);
    }).toList();
  }
}

