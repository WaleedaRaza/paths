import 'dart:convert';
import 'package:langchain/langchain.dart';
import '../models/refinement_suggestion.dart';
import '../models/refinement_knobs.dart';
import 'field_prompts.dart';
import 'novelty_checker.dart';
import 'refinement_knobs_presets.dart';
import 'intent_parser.dart';

/// Service for AI-powered refinement of project plan sections
class RefinementService {
  final BaseChatModel _llm;

  RefinementService(this._llm);

  /// Regenerate a section from scratch
  Future<String> regenerateSection({
    required String sectionType,
    required String projectDescription,
    String? previousContent,
  }) async {
    final prompt = _getRegeneratePrompt(sectionType, projectDescription, previousContent);
    final result = await _llm.invoke(PromptValue.string(prompt));
    return result.outputAsString;
  }

  /// Expand section with more detail
  Future<String> expandSection({
    required String sectionType,
    required String currentContent,
    String? focus,
  }) async {
    final prompt = '''Expand the following ${_getSectionName(sectionType)} section with more technical depth${focus != null ? ' focused on: $focus' : ''}.

Current content:
$currentContent

Add more details, examples, and specific implementation guidance. Output in markdown format.''';

    final result = await _llm.invoke(PromptValue.string(prompt));
    return result.outputAsString;
  }

  /// Simplify section to key points
  Future<String> simplifySection({
    required String sectionType,
    required String currentContent,
  }) async {
    final prompt = '''Condense the following ${_getSectionName(sectionType)} section to only the essential points. Remove fluff and keep it concise.

Current content:
$currentContent

Output a simplified version in markdown format, keeping only what matters.''';

    final result = await _llm.invoke(PromptValue.string(prompt));
    return result.outputAsString;
  }

  /// Add code examples to section
  Future<String> addExamples({
    required String sectionType,
    required String currentContent,
    String? topic,
  }) async {
    final prompt = '''Add concrete code examples to the following ${_getSectionName(sectionType)} section${topic != null ? ' for: $topic' : ''}.

Current content:
$currentContent

Include practical code snippets that demonstrate the concepts. Output in markdown format with proper code blocks.''';

    final result = await _llm.invoke(PromptValue.string(prompt));
    return result.outputAsString;
  }

  /// Get context-aware refinement suggestion with notes and guidance
  Future<RefinementSuggestion> getRefinementSuggestion({
    required String action, // 'expand', 'regenerate', 'simplify'
    required String fieldName,
    required String currentContent,
    required String sectionType,
    required Map<String, String> allFieldsInSection,
    required String originalIdea,
    required String userIntent, // User's specific instructions
    List<RefinementSuggestion>? conversationHistory, // For chat continuity
    RefinementKnobs? knobs, // Optional custom knobs
  }) async {
    // Parse user intent for hard constraints
    final parsedIntent = IntentParser.parse(userIntent, action);
    
    // Get appropriate knobs (use preset if not provided)
    final effectiveKnobs = knobs ?? RefinementKnobsPresets.getKnobs(
      action: action,
      sectionType: sectionType,
      fieldName: fieldName,
      currentContent: currentContent,
    );
    
    // Override target_count if user specified numbers
    final finalKnobs = parsedIntent.isCountSpecified() 
      ? effectiveKnobs.copyWith(targetCount: parsedIntent.targetCount)
      : effectiveKnobs;

    // Get field-specific micro-prompt if exists
    final microPrompt = FieldPrompts.getMicroPrompt(sectionType, fieldName, action) ?? '';
    
    // TWO-STEP GENERATION: Planning → Execution
    final planningResult = await _planExpansion(
      parsedIntent: parsedIntent,
      fieldName: fieldName,
      currentContent: currentContent,
      sectionType: sectionType,
      originalIdea: originalIdea,
      knobs: finalKnobs,
    );
    
    final generationResult = await _generateContent(
      parsedIntent: parsedIntent,
      fieldName: fieldName,
      currentContent: currentContent,
      sectionType: sectionType,
      allFieldsInSection: allFieldsInSection,
      originalIdea: originalIdea,
      plannedItems: planningResult,
      knobs: finalKnobs,
      microPrompt: microPrompt,
      conversationHistory: conversationHistory,
    );

    return generationResult;
  }
  
  /// STEP 1: Planning phase - what to add/change (just titles)
  Future<List<String>> _planExpansion({
    required IntentParser parsedIntent,
    required String fieldName,
    required String currentContent,
    required String sectionType,
    required String originalIdea,
    required RefinementKnobs knobs,
  }) async {
    final prompt = '''You are planning what to add to a documentation field.
Your task: Generate a list of EXACTLY ${parsedIntent.targetCount} distinct items to ${parsedIntent.verb}.

CONTEXT:
Project: $originalIdea
Field: $fieldName (${_getSectionName(sectionType)})
Current content: $currentContent

USER INTENT: ${parsedIntent.cleanedIntent}
COUNT REQUIREMENT: ${parsedIntent.getCountConstraint()}

OUTPUT FORMAT (plain text list, NO markdown, NO JSON):
- Item 1 title (3-6 words)
- Item 2 title (3-6 words)
...
- Item N title (3-6 words)

RULES:
1. Output EXACTLY ${parsedIntent.targetCount} items, no more, no less
2. Each item is just a SHORT TITLE (not full description)
3. No duplicates or near-duplicates
4. Be specific and diverse
5. ${parsedIntent.verb == 'add' ? 'Do NOT repeat existing items from current content' : 'Reframe existing concepts with new angles'}

OUTPUT NOW (${parsedIntent.targetCount} items):''';

    final result = await _llm.invoke(PromptValue.string(prompt));
    final rawOutput = result.outputAsString;
    
    print('=== PLANNING OUTPUT ===');
    print(rawOutput);
    print('=== END PLANNING ===');
    
    // Parse titles from output
    final lines = rawOutput
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.startsWith('-') || l.startsWith('•') || l.startsWith('*'))
        .map((l) => l.replaceFirst(RegExp(r'^[-•*]\s*'), ''))
        .where((l) => l.isNotEmpty)
        .toList();
    
    print('Parsed ${lines.length} items (target: ${parsedIntent.targetCount})');
    
    // Validate count
    if (parsedIntent.minCount != null && lines.length < parsedIntent.minCount!) {
      print('⚠️ Got ${lines.length} items but needed at least ${parsedIntent.minCount}');
    }
    
    return lines;
  }
  
  /// STEP 2: Generation phase - expand titles into full content
  Future<RefinementSuggestion> _generateContent({
    required IntentParser parsedIntent,
    required String fieldName,
    required String currentContent,
    required String sectionType,
    required Map<String, String> allFieldsInSection,
    required String originalIdea,
    required List<String> plannedItems,
    required RefinementKnobs knobs,
    required String microPrompt,
    List<RefinementSuggestion>? conversationHistory,
  }) async {
    final prompt = '''SYSTEM:
You are a senior technical writer expanding planned items into final documentation.
Be precise, specific, and format-faithful.

CONTEXT:
• Project: $originalIdea
• Section: ${_getSectionName(sectionType)}
• Field: $fieldName
• Current content: $currentContent

PLANNED ITEMS (${plannedItems.length} items to expand):
${plannedItems.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

USER INTENT: ${parsedIntent.cleanedIntent}
COUNT REQUIREMENT: OUTPUT MUST CONTAIN ${parsedIntent.getCountConstraint()}

${_buildConversationContext(conversationHistory)}

OUTPUT CONTRACT (STRICT JSON - NO MARKDOWN FENCES):
{
  "notes": "2-3 sentences: what you added and why",
  "guidance": ["Tip 1", "Tip 2", "Tip 3"],
  "proposedContentLines": ["line 1", "line 2", "..."],
  "reasoning": "1-2 sentence rationale"
}

CRITICAL RULES:
1. proposedContentLines MUST contain ${parsedIntent.targetCount} lines minimum
2. Each line = 1-2 sentences expanding one planned item
3. If list_only=${knobs.listOnly}, use bullet format: "- Feature: Description"
4. NO line may exceed 160 characters
5. NO duplicates vs current content
6. ${knobs.includeExamples ? 'Include concrete examples in parentheses' : 'No examples needed'}
7. Forbid phrases: ${knobs.forbidPhrases.isEmpty ? 'none' : knobs.forbidPhrases.join(', ')}

$microPrompt

OUTPUT JSON NOW (${parsedIntent.targetCount} lines):''';
    
    final result = await _llm.invoke(PromptValue.string(prompt));
    final rawOutput = result.outputAsString;
    
    print('=== GENERATION OUTPUT ===');
    print(rawOutput);
    print('=== END GENERATION ===');
    
    final jsonStr = _extractJson(rawOutput);
    
    print('=== EXTRACTED JSON ===');
    print(jsonStr);
    print('=== END EXTRACTED ===');
    
    RefinementSuggestion suggestion;
    
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      suggestion = RefinementSuggestion.fromJson({
        ...json,
        'action': parsedIntent.action,
        'fieldName': fieldName,
      });
    } catch (e, stack) {
      print('=== JSON PARSE ERROR ===');
      print('Error: $e');
      print('Stack: $stack');
      print('Attempted to parse: $jsonStr');
      print('=== END ERROR ===');
      
      // Fallback: return error suggestion
      return RefinementSuggestion(
        action: parsedIntent.action,
        fieldName: fieldName,
        notes: 'Failed to parse LLM response: $e',
        guidance: ['Check LLM output format', 'Verify JSON structure'],
        proposedContentLines: currentContent.split('\n'),
        reasoning: 'Partial parsing due to JSON error',
      );
    }
    
    // VALIDATE COUNT
    final actualCount = suggestion.proposedContentLines.length;
    print('Count check: got $actualCount, target ${parsedIntent.targetCount}');
    
    if (parsedIntent.minCount != null && actualCount < parsedIntent.minCount!) {
      print('⚠️ COUNT VALIDATION FAILED: Got $actualCount but needed ${parsedIntent.minCount}');
      
      // RETRY with more explicit prompt
      if (conversationHistory == null || conversationHistory.length < 2) {
        print('Retrying with stricter count enforcement...');
        return _generateContent(
          parsedIntent: parsedIntent,
          fieldName: fieldName,
          currentContent: currentContent,
          sectionType: sectionType,
          allFieldsInSection: allFieldsInSection,
          originalIdea: originalIdea,
          plannedItems: plannedItems,
          knobs: knobs,
          microPrompt: '$microPrompt\n\nCRITICAL: You generated $actualCount items, but user DEMANDS ${parsedIntent.minCount}. Try again.',
          conversationHistory: [...?conversationHistory, suggestion],
        );
      }
    }

    // Novelty check for regenerate action
    if (parsedIntent.action == 'regenerate' && conversationHistory != null && conversationHistory.length < 3) {
      if (!NoveltyChecker.isNovelEnough(
        currentContent,
        suggestion.proposedContentLines,
        knobs.noveltyThreshold,
      )) {
        print('❌ Novelty check failed! Retrying with higher constraints...');
        
        // Extract top trigrams to forbid
        final topTrigrams = NoveltyChecker.getTopTrigrams(currentContent, 5);
        final newKnobs = knobs.copyWith(
          forbidPhrases: [...knobs.forbidPhrases, ...topTrigrams],
          temperature: (knobs.temperature + 0.15).clamp(0.0, 1.0),
          noveltyThreshold: (knobs.noveltyThreshold + 0.1).clamp(0.0, 1.0),
        );
        
        // Retry once with enhanced knobs
        return getRefinementSuggestion(
          action: parsedIntent.action,
          fieldName: fieldName,
          currentContent: currentContent,
          sectionType: sectionType,
          allFieldsInSection: allFieldsInSection,
          originalIdea: originalIdea,
          userIntent: '${parsedIntent.cleanedIntent} (retrying for more novelty)',
          conversationHistory: [...conversationHistory, suggestion],
          knobs: newKnobs,
        );
      } else {
        print('✅ Novelty check passed!');
      }
    }
    
    return suggestion;
  }

  /// Extract JSON from LLM output (handles markdown code blocks)
  String _extractJson(String llmOutput) {
    // Remove markdown code blocks if present
    final codeBlockPattern = RegExp(r'```(?:json)?\s*(\{[\s\S]*?\})\s*```');
    final codeBlockMatch = codeBlockPattern.firstMatch(llmOutput);
    if (codeBlockMatch != null) {
      return codeBlockMatch.group(1)!;
    }

    // Try to find JSON object directly
    final jsonPattern = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonPattern.firstMatch(llmOutput);
    if (jsonMatch != null) {
      return jsonMatch.group(0)!;
    }

    // Fallback: assume entire output is JSON
    return llmOutput.trim();
  }

  /// Truncate text to maxLength with ellipsis
  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Build conversation context from history
  String _buildConversationContext(List<RefinementSuggestion>? history) {
    if (history == null || history.isEmpty) return '';
    
    final context = StringBuffer('CONVERSATION HISTORY:\n');
    for (var i = 0; i < history.length; i++) {
      final item = history[i];
      context.writeln('Iteration ${i + 1}:');
      context.writeln('  User requested: ${item.action}');
      context.writeln('  AI notes: ${_truncate(item.notes, 100)}');
    }
    return context.toString();
  }

  String _getSectionName(String sectionType) {
    switch (sectionType) {
      case 'info':
        return 'Project Info';
      case 'research':
        return 'Research & Stack';
      case 'architecture':
        return 'Technical Architecture';
      case 'features':
        return 'Feature Breakdown';
      case 'labor':
        return 'Division of Labor';
      default:
        return 'section';
    }
  }

  String _getRegeneratePrompt(String sectionType, String projectDescription, String? previousContent) {
    final context = previousContent != null
        ? '\n\nPrevious version (use as reference but rewrite fresh):\n$previousContent'
        : '';

    switch (sectionType) {
      case 'info':
        return '''Generate a Project Info section for this project:

$projectDescription$context

Include:
- Project name and tagline
- Target users/audience
- Core value proposition
- Key differentiators

Output in clear markdown format.''';

      case 'research':
        return '''Generate a Research & Stack section for this project:

$projectDescription$context

Include:
- Recommended tech stack with justification
- Key dependencies and libraries
- Best practices for this stack
- Common pitfalls and how to avoid them
- Security considerations

Output in markdown format.''';

      case 'architecture':
        return '''Generate a Technical Architecture document for this project:

$projectDescription$context

Include:
- System overview (architecture diagram in ASCII or description)
- Data models and relationships
- API contracts and endpoints
- Authentication/authorization strategy
- Deployment and infrastructure
- Scalability considerations

Output in detailed markdown format.''';

      case 'features':
        return '''Generate a Feature Breakdown for this project:

$projectDescription$context

Include:
- MVP features (essential for first release)
- V1 features (makes it production-ready)
- Future enhancements
- Time estimates for each feature

Output in structured markdown format.''';

      case 'labor':
        return '''Generate a Division of Labor and Timeline for this project:

$projectDescription$context

Include:
- Solo developer timeline with phases
- Team of 2 timeline with role division
- Team of 3+ timeline with optimal structure
- Critical path and dependencies

Output in markdown format with specific time estimates.''';

      default:
        return 'Regenerate this section.';
    }
  }
}

