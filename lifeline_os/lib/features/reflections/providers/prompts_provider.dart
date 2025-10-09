import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../repositories/prompts_repository.dart';

// Prompts repository provider
final promptsRepositoryProvider = Provider<PromptsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PromptsRepository(db);
});

// Watch prompt for an expert
final expertPromptProvider = StreamProvider.autoDispose.family<ExpertPrompt?, String>((ref, expertId) {
  final repo = ref.watch(promptsRepositoryProvider);
  return repo.watchPrompt(expertId);
});

// Action: Save custom prompt
final savePromptProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (String expertId, String systemPrompt) async {
    final repo = ref.read(promptsRepositoryProvider);
    await repo.savePrompt(expertId, systemPrompt);
  };
});

// Action: Reset to default
final resetPromptProvider = Provider<Future<void> Function(String)>((ref) {
  return (String expertId) async {
    final repo = ref.read(promptsRepositoryProvider);
    await repo.resetToDefault(expertId);
  };
});

