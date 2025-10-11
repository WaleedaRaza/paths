import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/llm_provider.dart';
import '../../../core/models/kobayashi_scenario.dart';
import '../../../core/models/kobayashi_analysis.dart';
import '../repositories/kobayashi_repository.dart';
import '../repositories/chat_repository.dart';
import '../services/kobayashi_analysis_service.dart';
import 'chat_provider.dart';

// Repository provider
final kobayashiRepositoryProvider = Provider<KobayashiRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return KobayashiRepository(db);
});

// Watch scenario for current session
final kobayashiScenarioProvider = StreamProvider.autoDispose<KobayashiScenario?>((ref) {
  final sessionId = ref.watch(currentSessionProvider);
  if (sessionId == null) return Stream.value(null);

  final repo = ref.watch(kobayashiRepositoryProvider);
  return repo.watchScenario(sessionId);
});

// Watch analysis for current session
final kobayashiAnalysisProvider = StreamProvider.autoDispose<KobayashiAnalysis?>((ref) {
  final sessionId = ref.watch(currentSessionProvider);
  if (sessionId == null) return Stream.value(null);

  final repo = ref.watch(kobayashiRepositoryProvider);
  return repo.watchAnalysis(sessionId);
});

// Generate analysis action
final generateKobayashiAnalysisProvider = Provider<Future<KobayashiAnalysis> Function(String)>((ref) {
  return (String sessionId) async {
    final llm = ref.read(activeLLMProvider);
    if (llm == null) {
      throw Exception('No LLM configured');
    }

    final kobayashiRepo = ref.read(kobayashiRepositoryProvider);
    final chatRepo = ref.read(chatRepositoryProvider);

    // Get scenario
    final scenario = await kobayashiRepo.getScenario(sessionId);
    if (scenario == null) {
      throw Exception('No scenario found for session');
    }

    // Get messages
    final messages = await chatRepo.watchMessages(sessionId).first;

    // Analyze
    final service = KobayashiAnalysisService(llm);
    final analysis = await service.analyzeSession(
      sessionId: sessionId,
      messages: messages,
      scenario: scenario,
    );

    // Save analysis
    await kobayashiRepo.saveAnalysis(
      sessionId: sessionId,
      overallScore: analysis.overallScore,
      strengths: analysis.strengths,
      weaknesses: analysis.weaknesses,
      recommendations: analysis.recommendations,
      transcript: analysis.transcript,
    );

    return analysis;
  };
});

