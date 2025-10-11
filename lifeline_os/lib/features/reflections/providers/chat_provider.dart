import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/llm/ollama_client.dart';
import '../../../core/services/llm/context_builder.dart';
import '../../../core/constants/experts.dart';
import '../repositories/chat_repository.dart';
import 'prompts_provider.dart';
import 'kobayashi_provider.dart';

// Database provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChatRepository(db);
});

// Current active session ID
final currentSessionProvider = StateProvider<String?>((ref) => null);

// Current selected expert
final currentExpertProvider = StateProvider<String>((ref) => 'founder-engineer');

// Chat history filter (multi-select experts)
final chatHistoryFilterProvider = StateProvider<Set<String>>((ref) {
  // Default to currently selected expert
  final currentExpert = ref.watch(currentExpertProvider);
  return {currentExpert};
});

// Ollama client provider
final ollamaClientProvider = Provider<OllamaClient>((ref) {
  return OllamaClient();
});

// Context builder provider
final contextBuilderProvider = Provider<ContextBuilder>((ref) {
  final db = ref.watch(databaseProvider);
  return ContextBuilder(db);
});

// Streaming message state (accumulates tokens during streaming)
final streamingMessageProvider = StateProvider<String?>((ref) => null);

// Watch all sessions (for filtering)
final allSessionsProvider = StreamProvider<List<ChatSession>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchAllSessions();
});

// Watch sessions for current expert (deprecated - use allSessionsProvider with filter)
final sessionsProvider = StreamProvider.autoDispose<List<ChatSession>>((ref) {
  final expertId = ref.watch(currentExpertProvider);
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchSessions(expertId);
});

// Watch messages for current session
final messagesProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref) {
  final sessionId = ref.watch(currentSessionProvider);
  if (sessionId == null) {
    return Stream.value([]);
  }
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchMessages(sessionId);
});

// Action: Create new session
final createSessionProvider = Provider<Future<String> Function()>((ref) {
  return () async {
    final expertId = ref.read(currentExpertProvider);
    final repo = ref.read(chatRepositoryProvider);
    final session = await repo.createSession(expertId);
    ref.read(currentSessionProvider.notifier).state = session.id;
    return session.id;
  };
});

// Action: Send message and get streaming response
final sendMessageProvider = Provider<Future<void> Function(String)>((ref) {
  return (String content) async {
    try {
      // Ensure we have a session
      var sessionId = ref.read(currentSessionProvider);
      if (sessionId == null) {
        sessionId = await ref.read(createSessionProvider)();
      }

      final expertId = ref.read(currentExpertProvider);
      final expert = ExpertRegistry.getById(expertId);
      if (expert == null) {
        throw Exception('Expert not found: $expertId');
      }

      final repo = ref.read(chatRepositoryProvider);
      final ollamaClient = ref.read(ollamaClientProvider);
      final contextBuilder = ref.read(contextBuilderProvider);
      final promptsRepo = ref.read(promptsRepositoryProvider);

      // Save user message
      await repo.addMessage(
        sessionId: sessionId,
        expertId: expertId,
        role: 'user',
        content: content,
      );

      // Get custom prompt if exists, otherwise use default
      final customPrompt = await promptsRepo.getPrompt(expertId);
      var systemPrompt = customPrompt?.systemPrompt ?? expert.systemPrompt;

      // Check if this is Kobayashi Maru session and inject scenario
      if (expertId == 'kobayashi-maru') {
        final kobayashiRepo = ref.read(kobayashiRepositoryProvider);
        final scenario = await kobayashiRepo.getScenario(sessionId);
        if (scenario != null) {
          // Inject scenario into system prompt
          final scenarioContext = '''

---SCENARIO PARAMETERS---
ROLE: ${scenario.role}
CONTEXT: ${scenario.context}
TRAITS TO EMBODY: ${scenario.traits}
YOUR GOALS: ${scenario.goals}
${scenario.winConditions != null ? 'WIN CONDITIONS: ${scenario.winConditions}' : ''}
---END SCENARIO---

Stay in character. The practice session has begun.''';
          systemPrompt = '$systemPrompt$scenarioContext';
        }
      }

      // Build context
      final context = await contextBuilder.buildContext(
        expert: expert,
        sessionId: sessionId,
      );

      // Get chat history for LLM
      final messages = await repo.watchMessages(sessionId).first;
      final llmMessages = messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      // Start streaming response
      ref.read(streamingMessageProvider.notifier).state = '';
      final streamingBuffer = StringBuffer();

      await for (final token in ollamaClient.generateStream(
        systemPrompt: '$systemPrompt\n\n---\n\n$context',
        messages: llmMessages,
      )) {
        streamingBuffer.write(token);
        ref.read(streamingMessageProvider.notifier).state = streamingBuffer.toString();
      }

      // Save complete assistant message
      final completeMessage = streamingBuffer.toString();
      await repo.addMessage(
        sessionId: sessionId,
        expertId: expertId,
        role: 'assistant',
        content: completeMessage,
      );

      // Clear streaming state
      ref.read(streamingMessageProvider.notifier).state = null;

      // Auto-generate title if this is the first exchange
      final messageCount = await repo.getMessageCount(sessionId);
      if (messageCount <= 2) {
        // Generate title from first user message
        final title = content.length > 50
            ? '${content.substring(0, 47)}...'
            : content;
        await repo.updateSessionTitle(sessionId, title);
      }
    } catch (e) {
      // Clear streaming state on error
      ref.read(streamingMessageProvider.notifier).state = null;
      rethrow;
    }
  };
});

// Action: Delete session
final deleteSessionProvider = Provider<Future<void> Function(String)>((ref) {
  return (String sessionId) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.deleteSession(sessionId);
    
    // If this was the current session, clear it
    if (ref.read(currentSessionProvider) == sessionId) {
      ref.read(currentSessionProvider.notifier).state = null;
    }
  };
});

// Action: Switch to session
final switchToSessionProvider = Provider<void Function(String)>((ref) {
  return (String sessionId) {
    ref.read(currentSessionProvider.notifier).state = sessionId;
  };
});

