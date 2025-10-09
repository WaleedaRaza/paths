import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import '../../database/database.dart';
import '../../constants/experts.dart';

/// Builds dynamic context for LLM prompts based on expert needs
class ContextBuilder {
  final AppDatabase db;

  ContextBuilder(this.db);

  /// Build complete context string for an expert
  Future<String> buildContext({
    required Expert expert,
    String? sessionId,
  }) async {
    final sections = <String>[];

    // Always include core identity
    if (expert.contextNeeds.coreIdentity) {
      sections.add(_buildCoreIdentity());
    }

    // Current state (tasks, goals, deadlines)
    if (expert.contextNeeds.currentState) {
      final currentState = await _buildCurrentState(expert);
      if (currentState.isNotEmpty) {
        sections.add(currentState);
      }
    }

    // Recent activity
    if (expert.contextNeeds.recentActivity) {
      final recentActivity = await _buildRecentActivity();
      if (recentActivity.isNotEmpty) {
        sections.add(recentActivity);
      }
    }

    // Domain-specific data
    if (expert.contextNeeds.domainData.isNotEmpty) {
      final domainData = await _buildDomainData(expert.contextNeeds.domainData);
      if (domainData.isNotEmpty) {
        sections.add(domainData);
      }
    }

    // Active memories
    final memories = await _buildMemories(expert.id);
    if (memories.isNotEmpty) {
      sections.add(memories);
    }

    // Chat history (if session exists)
    if (sessionId != null) {
      final chatHistory = await _buildChatHistory(sessionId);
      if (chatHistory.isNotEmpty) {
        sections.add(chatHistory);
      }
    }

    return sections.join('\n\n---\n\n');
  }

  String _buildCoreIdentity() {
    return '''## Core Identity

User: Waleed
Role: Student-founder, ambitious builder
Traits: ADHD/executive dysfunction (initiation cost high, hyperfocus with novelty/pressure/meaning)
Strengths: Pattern recognition, deep focus when engaged, technical aptitude
Challenges: Context switching tax, discipline drift under low motivation, impatience
Values: Autonomy, visible progress, meaningful work, real stakes
Current Focus: Building personal AI productivity system, shipping projects, academic goals''';
  }

  Future<String> _buildCurrentState(Expert expert) async {
    final sections = <String>[];

    // Incomplete tasks with approaching deadlines
    final sevenDaysFromNow = DateTime.now().add(const Duration(days: 7));
    final upcomingTasks = await (db.select(db.tasks)
          ..where((t) => t.isCompleted.equals(false) & t.dueDate.isSmallerOrEqualValue(sevenDaysFromNow))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .get();

    if (upcomingTasks.isNotEmpty) {
      final tasksList = upcomingTasks.take(10).map((task) {
        final dueStr = task.dueDate != null
            ? DateFormat('MMM d').format(task.dueDate!)
            : 'No deadline';
        final priority = ['None', 'Low', 'Medium', 'High'][task.priority];
        return '  - ${task.title} [$priority] (Due: $dueStr)';
      }).join('\n');
      
      sections.add('## Current Tasks (Next 7 Days)\n\n$tasksList');
    }

    // Active goals
    final activeGoals = await (db.select(db.goals)
          ..where((g) => g.isCompleted.equals(false))
          ..orderBy([(g) => OrderingTerm.desc(g.updatedAt)])
          ..limit(5))
        .get();

    if (activeGoals.isNotEmpty) {
      final goalsList = activeGoals.map((goal) {
        return '  - ${goal.title} (${goal.totalPoints} pts)';
      }).join('\n');
      
      sections.add('## Active Goals\n\n$goalsList');
    }

    // Today's must-wins
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    final mustWins = await (db.select(db.mustWins)
          ..where((m) => m.date.isBiggerOrEqualValue(todayStart) & m.date.isSmallerThanValue(todayEnd))
          ..orderBy([(m) => OrderingTerm.asc(m.sortOrder)]))
        .get();

    if (mustWins.isNotEmpty) {
      final mustWinsList = mustWins.map((mw) {
        final status = mw.isCompleted ? '✓' : '○';
        return '  $status ${mw.title}';
      }).join('\n');
      
      sections.add('## Today\'s Must-Wins\n\n$mustWinsList');
    }

    return sections.join('\n\n');
  }

  Future<String> _buildRecentActivity() async {
    // Last 10 completed tasks
    final recentTasks = await (db.select(db.tasks)
          ..where((t) => t.isCompleted.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
          ..limit(10))
        .get();

    if (recentTasks.isEmpty) {
      return '';
    }

    final tasksList = recentTasks.map((task) {
      final completedStr = task.completedAt != null
          ? DateFormat('MMM d').format(task.completedAt!)
          : 'Recently';
      return '  - ${task.title} (Completed: $completedStr, +${task.totalPoints} pts)';
    }).join('\n');

    return '## Recent Activity\n\n$tasksList';
  }

  Future<String> _buildDomainData(List<String> domainKeys) async {
    final sections = <String>[];

    for (final key in domainKeys) {
      switch (key) {
        case 'goals':
        case 'projects':
          // Already handled in current state
          break;
          
        case 'patterns':
          // Could aggregate completion patterns
          sections.add('## Patterns\n\n(Pattern analysis placeholder - to be implemented)');
          break;
          
        case 'progress':
          // Points and completion stats
          final totalPoints = await _getTotalPoints();
          sections.add('## Progress\n\nTotal Points Earned: $totalPoints');
          break;
          
        case 'tasks':
          // Handled in current state
          break;
          
        case 'deadlines':
          // Handled in current state
          break;
          
        case 'blockers':
          // Could filter for blocked/stuck tasks
          break;
          
        default:
          // Unknown domain data key
          break;
      }
    }

    return sections.join('\n\n');
  }

  Future<int> _getTotalPoints() async {
    final query = db.selectOnly(db.tasks)
      ..addColumns([db.tasks.totalPoints.sum()])
      ..where(db.tasks.isCompleted.equals(true));
    
    final result = await query.getSingleOrNull();
    if (result == null) return 0;
    return result.read(db.tasks.totalPoints.sum()) ?? 0;
  }

  Future<String> _buildMemories(String expertId) async {
    final memories = await (db.select(db.memories)
          ..where((m) => m.isActive.equals(true))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();

    if (memories.isEmpty) {
      return '';
    }

    // Filter for memories related to this expert or global
    final relevantMemories = memories.where((m) {
      if (m.relatedExpertIds == null || m.relatedExpertIds!.isEmpty) {
        return true; // Global memory
      }
      return m.relatedExpertIds!.contains(expertId);
    }).toList();

    if (relevantMemories.isEmpty) {
      return '';
    }

    final memoriesList = relevantMemories.take(10).map((memory) {
      return '  - ${memory.content}';
    }).join('\n');

    return '## Persistent Memories\n\n$memoriesList';
  }

  Future<String> _buildChatHistory(String sessionId) async {
    final messages = await (db.select(db.chatMessages)
          ..where((m) => m.sessionId.equals(sessionId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();

    if (messages.isEmpty) {
      return '';
    }

    // Take last 20 messages to avoid token overflow
    final recentMessages = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : messages;

    final historyLines = recentMessages.map((msg) {
      final role = msg.role == 'user' ? 'User' : 'Assistant';
      return '$role: ${msg.content}';
    }).join('\n\n');

    return '## Chat History\n\n$historyLines';
  }
}

