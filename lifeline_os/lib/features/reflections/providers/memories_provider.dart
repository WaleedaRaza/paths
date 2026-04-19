import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../repositories/memories_repository.dart';

// Memories repository provider
final memoriesRepositoryProvider = Provider<MemoriesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MemoriesRepository(db);
});

// Watch all active memories
final activeMemoriesProvider = StreamProvider<List<Memory>>((ref) {
  final repo = ref.watch(memoriesRepositoryProvider);
  return repo.watchActiveMemories();
});

// Action: Create memory
final createMemoryProvider = Provider<Future<Memory> Function({
  required String content,
  required String source,
  List<String>? relatedExpertIds,
})>((ref) {
  return ({
    required String content,
    required String source,
    List<String>? relatedExpertIds,
  }) async {
    final repo = ref.read(memoriesRepositoryProvider);
    return await repo.createMemory(
      content: content,
      source: source,
      relatedExpertIds: relatedExpertIds,
    );
  };
});

// Action: Update memory
final updateMemoryProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (String memoryId, String content) async {
    final repo = ref.read(memoriesRepositoryProvider);
    await repo.updateMemory(memoryId, content);
  };
});

// Action: Archive memory
final archiveMemoryProvider = Provider<Future<void> Function(String)>((ref) {
  return (String memoryId) async {
    final repo = ref.read(memoriesRepositoryProvider);
    await repo.archiveMemory(memoryId);
  };
});

// Action: Delete memory permanently
final deleteMemoryProvider = Provider<Future<void> Function(String)>((ref) {
  return (String memoryId) async {
    final repo = ref.read(memoriesRepositoryProvider);
    await repo.deleteMemory(memoryId);
  };
});

