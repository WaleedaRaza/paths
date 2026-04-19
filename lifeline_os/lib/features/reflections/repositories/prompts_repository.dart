import 'package:drift/drift.dart';
import '../../../core/database/database.dart';

/// Repository for managing expert prompts
class PromptsRepository {
  final AppDatabase db;

  PromptsRepository(this.db);

  /// Get prompt for an expert (custom or default)
  Future<ExpertPrompt?> getPrompt(String expertId) async {
    final results = await (db.select(db.expertPrompts)
          ..where((p) => p.expertId.equals(expertId)))
        .get();
    
    return results.isEmpty ? null : results.first;
  }

  /// Watch prompt for an expert
  Stream<ExpertPrompt?> watchPrompt(String expertId) {
    return (db.select(db.expertPrompts)
          ..where((p) => p.expertId.equals(expertId)))
        .watchSingleOrNull();
  }

  /// Save custom prompt
  Future<void> savePrompt(String expertId, String systemPrompt) async {
    final existing = await getPrompt(expertId);
    final now = DateTime.now();

    if (existing != null) {
      // Update existing
      await (db.update(db.expertPrompts)
            ..where((p) => p.expertId.equals(expertId)))
          .write(ExpertPromptsCompanion(
        systemPrompt: Value(systemPrompt),
        isCustom: const Value(true),
        updatedAt: Value(now),
      ));
    } else {
      // Create new
      final prompt = ExpertPromptsCompanion.insert(
        expertId: expertId,
        systemPrompt: systemPrompt,
        isCustom: const Value(true),
        updatedAt: Value(now),
      );
      await db.into(db.expertPrompts).insert(prompt);
    }
  }

  /// Reset to default prompt (delete custom)
  Future<void> resetToDefault(String expertId) async {
    await (db.delete(db.expertPrompts)
          ..where((p) => p.expertId.equals(expertId)))
        .go();
  }

  /// Get all custom prompts
  Future<List<ExpertPrompt>> getAllCustomPrompts() async {
    return await (db.select(db.expertPrompts)
          ..where((p) => p.isCustom.equals(true))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .get();
  }
}

