import 'dart:convert';
import 'package:langchain/langchain.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database.dart' as db;
import '../../../core/models/kobayashi_scenario.dart';
import '../../../core/models/kobayashi_analysis.dart';

class KobayashiAnalysisService {
  final BaseChatModel llm;

  KobayashiAnalysisService(this.llm);

  Future<KobayashiAnalysis> analyzeSession({
    required String sessionId,
    required List<db.ChatMessage> messages,
    required KobayashiScenario scenario,
  }) async {
    final transcript = messages
        .map((m) => '${m.role.toUpperCase()}: ${m.content}')
        .join('\n\n');

    final analysisPrompt = '''You are an expert social dynamics coach analyzing a practice conversation.

SCENARIO:
Role: ${scenario.role}
Context: ${scenario.context}
Traits: ${scenario.traits}
Goals: ${scenario.goals}
${scenario.winConditions != null ? 'Win Conditions: ${scenario.winConditions}' : ''}

TRANSCRIPT:
$transcript

Analyze the USER's performance in this confrontational interaction. Provide:

1. OVERALL SCORE (1-10): How effectively did they handle the situation?
2. STRENGTHS (3-5 items): What did they do well?
3. WEAKNESSES (3-5 items): Where did they struggle or get outmaneuvered?
4. RECOMMENDATIONS (3-5 items): Specific, actionable tactics to improve

Output ONLY valid JSON in this exact format:
{
  "overallScore": 7,
  "strengths": ["maintained frame", "used reciprocity", "stayed calm"],
  "weaknesses": ["conceded too early", "missed power move", "defensive tone"],
  "recommendations": ["use tactical silence", "reframe with higher-order benefit", "anchor first"]
}''';

    final result = await llm.invoke(PromptValue.string(analysisPrompt));
    final outputText = result.outputAsString.trim();
    
    // Try to extract JSON from the output
    String jsonText = outputText;
    
    // If output is wrapped in markdown code blocks, extract it
    if (outputText.contains('```json')) {
      final startIdx = outputText.indexOf('```json') + 7;
      final endIdx = outputText.indexOf('```', startIdx);
      if (endIdx > startIdx) {
        jsonText = outputText.substring(startIdx, endIdx).trim();
      }
    } else if (outputText.contains('```')) {
      final startIdx = outputText.indexOf('```') + 3;
      final endIdx = outputText.indexOf('```', startIdx);
      if (endIdx > startIdx) {
        jsonText = outputText.substring(startIdx, endIdx).trim();
      }
    }
    
    // Find first { and last }
    final firstBrace = jsonText.indexOf('{');
    final lastBrace = jsonText.lastIndexOf('}');
    if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
      jsonText = jsonText.substring(firstBrace, lastBrace + 1);
    }

    final json = jsonDecode(jsonText);

    return KobayashiAnalysis(
      id: const Uuid().v4(),
      sessionId: sessionId,
      overallScore: json['overallScore'] as int,
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      recommendations: List<String>.from(json['recommendations']),
      transcript: transcript,
      createdAt: DateTime.now(),
    );
  }
}

