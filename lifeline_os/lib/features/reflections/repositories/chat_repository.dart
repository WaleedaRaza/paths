import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';

/// Repository for managing chat sessions and messages
class ChatRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  ChatRepository(this.db);

  /// Create a new chat session
  Future<ChatSession> createSession(String expertId) async {
    final now = DateTime.now();
    final session = ChatSessionsCompanion.insert(
      id: _uuid.v4(),
      expertId: expertId,
      title: Value(null),
      createdAt: Value(now),
      lastMessageAt: Value(now),
    );

    await db.into(db.chatSessions).insert(session);
    return await getSession(session.id.value);
  }

  /// Get a specific session
  Future<ChatSession> getSession(String sessionId) async {
    return await (db.select(db.chatSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingle();
  }

  /// Watch all sessions for an expert
  Stream<List<ChatSession>> watchSessions(String expertId) {
    return (db.select(db.chatSessions)
          ..where((s) => s.expertId.equals(expertId))
          ..orderBy([(s) => OrderingTerm.desc(s.lastMessageAt)]))
        .watch();
  }

  /// Watch all sessions (for multi-expert filtering)
  Stream<List<ChatSession>> watchAllSessions() {
    return (db.select(db.chatSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.lastMessageAt)]))
        .watch();
  }

  /// Watch messages for a session
  Stream<List<ChatMessage>> watchMessages(String sessionId) {
    return (db.select(db.chatMessages)
          ..where((m) => m.sessionId.equals(sessionId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Add a message to a session
  Future<ChatMessage> addMessage({
    required String sessionId,
    required String expertId,
    required String role,
    required String content,
  }) async {
    final now = DateTime.now();
    
    final message = ChatMessagesCompanion.insert(
      id: _uuid.v4(),
      sessionId: sessionId,
      expertId: expertId,
      role: role,
      content: content,
      createdAt: Value(now),
    );

    await db.into(db.chatMessages).insert(message);

    // Update session lastMessageAt
    await (db.update(db.chatSessions)
          ..where((s) => s.id.equals(sessionId)))
        .write(ChatSessionsCompanion(lastMessageAt: Value(now)));

    return await (db.select(db.chatMessages)
          ..where((m) => m.id.equals(message.id.value)))
        .getSingle();
  }

  /// Update session title
  Future<void> updateSessionTitle(String sessionId, String title) async {
    await (db.update(db.chatSessions)
          ..where((s) => s.id.equals(sessionId)))
        .write(ChatSessionsCompanion(title: Value(title)));
  }

  /// Delete a session and all its messages
  Future<void> deleteSession(String sessionId) async {
    await (db.delete(db.chatSessions)
          ..where((s) => s.id.equals(sessionId)))
        .go();
    // Messages cascade delete automatically
  }

  /// Get messages count for a session
  Future<int> getMessageCount(String sessionId) async {
    final query = db.selectOnly(db.chatMessages)
      ..addColumns([db.chatMessages.id.count()])
      ..where(db.chatMessages.sessionId.equals(sessionId));
    
    final result = await query.getSingle();
    return result.read(db.chatMessages.id.count()) ?? 0;
  }

}

