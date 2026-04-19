import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/llm_provider.dart';
import '../../../core/services/llm/llm_config.dart';
import '../../../core/models/kobayashi_scenario.dart' as models;
import '../../../core/models/kobayashi_analysis.dart' as models;
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
final kobayashiScenarioProvider = StreamProvider.autoDispose<models.KobayashiScenario?>((ref) {
  final sessionId = ref.watch(currentSessionProvider);
  if (sessionId == null) return Stream.value(null);

  final repo = ref.watch(kobayashiRepositoryProvider);
  return repo.watchScenario(sessionId);
});

// Watch analysis for current session
final kobayashiAnalysisProvider = StreamProvider.autoDispose<models.KobayashiAnalysis?>((ref) {
  final sessionId = ref.watch(currentSessionProvider);
  if (sessionId == null) return Stream.value(null);

  final repo = ref.watch(kobayashiRepositoryProvider);
  return repo.watchAnalysis(sessionId);
});

// Generate analysis action
final generateKobayashiAnalysisProvider = Provider<Future<models.KobayashiAnalysis> Function(String)>((ref) {
  return (String sessionId) async {
    // Check LLM config first
    final configAsync = ref.read(llmConfigProvider);
    final config = configAsync.valueOrNull;
    
    if (config == null) {
      throw Exception('LLM configuration not loaded. Please check Settings → AI Models.');
    }

    final llm = ref.read(activeLLMProvider);
    if (llm == null) {
      // Provide more specific error based on provider
      String errorMsg = 'LLM not configured. ';
      switch (config.provider) {
        case LLMProvider.local:
          errorMsg += 'Please ensure Ollama is running (http://localhost:11434) and model "${config.localModel}" is available.';
          break;
        case LLMProvider.openai:
          errorMsg += 'Please add your OpenAI API key in Settings → AI Models.';
          break;
        case LLMProvider.claude:
          errorMsg += 'Please add your Claude API key in Settings → AI Models.';
          break;
      }
      throw Exception(errorMsg);
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

