import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../repositories/notes_repository.dart';

// Notes repository provider
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NotesRepository(db);
});

// Current notes date (defaults to today)
final notesDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Current notes tab (journal, note, idea)
final notesTabProvider = StateProvider<String>((ref) => 'journal');

// Watch current entry based on date and tab
final currentEntryProvider = StreamProvider.autoDispose<JournalEntry?>((ref) {
  final date = ref.watch(notesDateProvider);
  final type = ref.watch(notesTabProvider);
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchEntryForDate(date, type: type);
});

// Watch all entries by type
final entriesByTypeProvider = StreamProvider.autoDispose.family<List<JournalEntry>, String>((ref, type) {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchEntriesByType(type);
});

// Action: Update entry (with debounce handled in UI)
final updateEntryProvider = Provider<Future<void> Function(String, {String? title})>((ref) {
  return (String content, {String? title}) async {
    final date = ref.read(notesDateProvider);
    final type = ref.read(notesTabProvider);
    final repo = ref.read(notesRepositoryProvider);
    await repo.upsertEntry(
      date: date,
      content: content,
      type: type,
      title: title,
    );
  };
});

// Action: Create new note/idea
final createEntryProvider = Provider<Future<JournalEntry> Function(String, String, String)>((ref) {
  return (String type, String title, String content) async {
    final repo = ref.read(notesRepositoryProvider);
    return await repo.createEntry(
      type: type,
      title: title,
      content: content,
    );
  };
});

// Action: Delete entry
final deleteEntryProvider = Provider<Future<void> Function(String)>((ref) {
  return (String entryId) async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.deleteEntry(entryId);
  };
});

