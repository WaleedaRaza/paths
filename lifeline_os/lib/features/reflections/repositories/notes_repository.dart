import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';

/// Repository for managing journal entries (notes panel)
class NotesRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  NotesRepository(this.db);

  /// Get entry for a specific date and type
  Future<JournalEntry?> getEntryForDate(DateTime date, {String type = 'journal'}) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final results = await (db.select(db.journalEntries)
          ..where((e) => e.date.isBiggerOrEqualValue(dayStart) & 
                         e.date.isSmallerThanValue(dayEnd) & 
                         e.type.equals(type)))
        .get();

    return results.isEmpty ? null : results.first;
  }

  /// Watch entry for a specific date and type
  Stream<JournalEntry?> watchEntryForDate(DateTime date, {String type = 'journal'}) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return (db.select(db.journalEntries)
          ..where((e) => e.date.isBiggerOrEqualValue(dayStart) & 
                         e.date.isSmallerThanValue(dayEnd) & 
                         e.type.equals(type)))
        .watchSingleOrNull();
  }

  /// Watch all entries of a specific type
  Stream<List<JournalEntry>> watchEntriesByType(String type) {
    return (db.select(db.journalEntries)
          ..where((e) => e.type.equals(type))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  /// Create or update entry
  Future<void> upsertEntry({
    required DateTime date,
    required String content,
    required String type,
    String? title,
    List<String>? tags,
  }) async {
    final now = DateTime.now();
    final dayStart = DateTime(date.year, date.month, date.day);

    // Check if entry exists
    final existing = await getEntryForDate(date, type: type);

    if (existing != null) {
      // Update existing
      await (db.update(db.journalEntries)
            ..where((e) => e.id.equals(existing.id)))
          .write(JournalEntriesCompanion(
        title: Value(title),
        content: Value(content),
        tags: Value(tags?.join(',') ?? ''),
        updatedAt: Value(now),
      ));
    } else {
      // Create new
      final entry = JournalEntriesCompanion.insert(
        id: _uuid.v4(),
        date: dayStart,
        type: type,
        title: Value(title),
        content: content,
        tags: Value(tags?.join(',') ?? ''),
        updatedAt: Value(now),
      );
      await db.into(db.journalEntries).insert(entry);
    }
  }

  /// Create a standalone note or idea
  Future<JournalEntry> createEntry({
    required String type,
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    final now = DateTime.now();
    final entry = JournalEntriesCompanion.insert(
      id: _uuid.v4(),
      date: now,
      type: type,
      title: Value(title),
      content: content,
      tags: Value(tags?.join(',') ?? ''),
      updatedAt: Value(now),
    );
    
    await db.into(db.journalEntries).insert(entry);
    
    return await (db.select(db.journalEntries)
          ..where((e) => e.id.equals(entry.id.value)))
        .getSingle();
  }

  /// Get all journal entries
  Future<List<JournalEntry>> getAllEntries() async {
    return await (db.select(db.journalEntries)
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  /// Search journal entries by content
  Future<List<JournalEntry>> searchEntries(String query) async {
    return await (db.select(db.journalEntries)
          ..where((e) => e.content.contains(query))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  /// Update an existing entry
  Future<void> updateEntry(String entryId, String title, String content) async {
    await (db.update(db.journalEntries)
          ..where((e) => e.id.equals(entryId)))
        .write(JournalEntriesCompanion(
      title: Value(title),
      content: Value(content),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Delete an entry
  Future<void> deleteEntry(String entryId) async {
    await (db.delete(db.journalEntries)
          ..where((e) => e.id.equals(entryId)))
        .go();
  }
}

