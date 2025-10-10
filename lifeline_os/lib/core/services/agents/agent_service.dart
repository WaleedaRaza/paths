import 'package:langchain/langchain.dart';

/// Base class for all AI agent services
/// 
/// Agents generate suggestions that require user approval before being applied.
/// This ensures users maintain control over AI-generated content.
abstract class AgentService {
  final BaseChatModel llm;
  
  AgentService(this.llm);
  
  /// Build context string for MGTST (Mission/Goal/Task/Subtask) hierarchy
  /// 
  /// Subclasses can override to customize context building
  String buildMGTSTContext(Map<String, dynamic> context) {
    final buffer = StringBuffer();
    
    // Add missions context
    if (context.containsKey('missions')) {
      final missions = context['missions'] as List<Map<String, dynamic>>;
      buffer.writeln('EXISTING MISSIONS (${missions.length}):');
      for (final m in missions) {
        buffer.writeln('- ${m['title']} (${m['domain']})');
      }
      buffer.writeln();
    }
    
    // Add goals context
    if (context.containsKey('goals')) {
      final goals = context['goals'] as List<Map<String, dynamic>>;
      buffer.writeln('EXISTING GOALS (${goals.length}):');
      for (final g in goals) {
        buffer.writeln('- ${g['title']}');
      }
      buffer.writeln();
    }
    
    // Add tasks context
    if (context.containsKey('tasks')) {
      final tasks = context['tasks'] as List<Map<String, dynamic>>;
      buffer.writeln('EXISTING TASKS (${tasks.length}):');
      for (final t in tasks) {
        buffer.writeln('- ${t['title']}');
      }
      buffer.writeln();
    }
    
    // Add user patterns
    if (context.containsKey('patterns')) {
      final patterns = context['patterns'] as Map<String, dynamic>;
      buffer.writeln('USER PATTERNS:');
      if (patterns.containsKey('topDomains')) {
        buffer.writeln('- Most used domains: ${patterns['topDomains']}');
      }
      if (patterns.containsKey('avgTasksPerGoal')) {
        buffer.writeln('- Average tasks per goal: ${patterns['avgTasksPerGoal']}');
      }
      if (patterns.containsKey('commonPriorities')) {
        buffer.writeln('- Common priorities: ${patterns['commonPriorities']}');
      }
    }
    
    return buffer.toString();
  }
  
  /// Helper to safely parse JSON from LLM responses
  /// 
  /// Strips markdown code fences if present
  String cleanJsonResponse(String raw) {
    String cleaned = raw.trim();
    
    // Remove markdown code fences
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.replaceFirst('```json', '').trim();
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst('```', '').trim();
    }
    
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.lastIndexOf('```')).trim();
    }
    
    return cleaned;
  }
}

