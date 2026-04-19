import 'dart:convert';
import 'package:langchain/langchain.dart';
import '../../../core/services/agents/agent_service.dart';
import '../../../core/database/tables.dart';
import '../models/mgtst_suggestion.dart';

/// AI agent for generating Mission/Goal/Task suggestions
/// 
/// Takes user description and domain, returns structured suggestions
/// that the user can review, modify, and approve.
class MGTSTCreationAgent extends AgentService {
  MGTSTCreationAgent(super.llm);
  
  /// Generate MGTST breakdown from user description
  Future<MGTSTSuggestion> suggestMGTST({
    required String userDescription,
    required Domain selectedDomain,
    required String existingContext,
  }) async {
    final prompt = _buildPrompt(
      userDescription: userDescription,
      domain: selectedDomain,
      context: existingContext,
    );
    
    try {
      final result = await llm.invoke(PromptValue.string(prompt));
      final rawOutput = result.outputAsString;
      
      // Debug output
      print('🤖 MGTST Agent Raw Output:');
      print(rawOutput);
      
      final cleaned = cleanJsonResponse(rawOutput);
      
      print('🧹 Cleaned JSON:');
      print(cleaned);
      
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return MGTSTSuggestion.fromJson(json);
    } catch (e) {
      print('❌ Error parsing MGTST suggestion: $e');
      
      // Return fallback suggestion
      return MGTSTSuggestion(
        mission: MissionSuggestion(
          suggestedTitle: _generateFallbackTitle(userDescription),
          rationale: 'Generated from your description',
        ),
        goals: [
          GoalSuggestion(
            title: 'Define objectives',
            description: 'Break down the mission into specific objectives',
            tasks: [
              const TaskSuggestion(title: 'Identify key milestones'),
              const TaskSuggestion(title: 'Set measurable goals'),
            ],
          ),
        ],
        notes: 'Error parsing AI response: $e. Using fallback structure.',
      );
    }
  }
  
  String _buildPrompt({
    required String userDescription,
    required Domain domain,
    required String context,
  }) {
    return '''SYSTEM: You are a productivity agent that breaks down high-level missions into actionable Goals and Tasks. You help users structure their ambitions into concrete, manageable work.

CONTEXT:
$context

USER REQUEST:
Domain: ${_getDomainLabel(domain)}
Description: $userDescription

OUTPUT (strict JSON - NO markdown fences):
{
  "mission": {
    "suggestedTitle": "...",
    "rationale": "1-2 sentences explaining why this title captures the mission"
  },
  "goals": [
    {
      "title": "...",
      "description": "...",
      "tasks": [
        {"title": "...", "priority": "medium", "energy": "medium"},
        {"title": "...", "priority": "high", "energy": "high"}
      ]
    }
  ],
  "notes": "2-3 sentence explanation of the breakdown strategy and rationale"
}

RULES:
1. Mission title = concise outcome (3-7 words), NOT a todo
2. Generate 4-8 goals = measurable sub-outcomes that roll up to mission
3. Each goal has 3-6 tasks = concrete actions
4. Respect domain context:
   - School: assignments, exams, projects, study sessions
   - Finance: budgets, savings, investments, expense tracking
   - Health: workouts, meal prep, sleep tracking, appointments
   - DSA: algorithm practice, problem sets, mock interviews, study plans
   - Career: networking, skill-building, applications, interviews
   - GRE: practice tests, vocab drills, essay writing, study schedules
   - Personal: habits, relationships, hobbies, self-improvement
   - Projects: planning, implementation, testing, deployment
5. Suggest realistic priorities: "low" | "medium" | "high"
6. Suggest energy levels: "low" (admin) | "medium" (execution) | "high" (deep work)
7. Tasks should be specific and actionable (not vague like "do research")
8. Avoid duplicating patterns from existing context (be novel)

PRIORITY GUIDE:
- high: Critical path items, deadlines, dependencies
- medium: Important but flexible timing
- low: Nice-to-have, can be deferred

ENERGY GUIDE:
- high: Deep focus work (coding, writing, problem-solving)
- medium: Collaborative work (meetings, reviews, implementation)
- low: Administrative (organizing, emails, scheduling)

DOMAIN-SPECIFIC PATTERNS:
School: Balance coursework, projects, exam prep, and study materials
Finance: Mix tracking (low energy) with planning (high energy)
Health: Combine habits (daily) with milestones (weight/strength goals)
DSA: Mix problem-solving (high energy) with review/patterns (medium)
Career: Mix learning (high energy) with networking (medium)
GRE: Mix timed practice (high) with review/vocab (medium)
Personal: Mix skill-building with relationship/wellness goals
Projects: Follow phases (planning → implementation → polish → launch)

OUTPUT NOW (valid JSON only, no extra text):''';
  }
  
  String _getDomainLabel(Domain domain) {
    switch (domain) {
      case Domain.school:
        return 'School/Education';
      case Domain.finance:
        return 'Finance/Money';
      case Domain.health:
        return 'Health/Fitness';
      case Domain.dsa:
        return 'DSA/Interview Prep';
      case Domain.career:
        return 'Career/Professional';
      case Domain.gre:
        return 'GRE/Test Prep';
      case Domain.personal:
        return 'Personal/Life';
      case Domain.projects:
        return 'Projects/Technical';
    }
  }
  
  String _generateFallbackTitle(String description) {
    // Extract first few words as fallback title
    final words = description.split(' ').take(5).join(' ');
    return words.length > 50 ? '${words.substring(0, 47)}...' : words;
  }
}

