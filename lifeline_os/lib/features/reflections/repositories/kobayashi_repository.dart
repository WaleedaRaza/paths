import 'package:drift/drift.dart';
import 'dart:convert';
import '../../../core/database/database.dart';
import '../../../core/models/kobayashi_scenario.dart';
import '../../../core/models/kobayashi_analysis.dart';

class KobayashiRepository {
  final AppDatabase db;

  KobayashiRepository(this.db);

  // Create scenario for a session
  Future<KobayashiScenario> createScenario({
    required String sessionId,
    required String role,
    required String context,
    required String traits,
    required String goals,
    String? winConditions,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final scenario = KobayashiScenario(
      id: id,
      sessionId: sessionId,
      role: role,
      context: context,
      traits: traits,
      goals: goals,
      winConditions: winConditions,
      createdAt: DateTime.now(),
    );

    await db.into(db.kobayashiScenarios).insert(
      KobayashiScenariosCompanion(
        id: Value(scenario.id),
        sessionId: Value(scenario.sessionId),
        role: Value(scenario.role),
        context: Value(scenario.context),
        traits: Value(scenario.traits),
        goals: Value(scenario.goals),
        winConditions: Value(scenario.winConditions),
        createdAt: Value(scenario.createdAt),
      ),
    );

    return scenario;
  }

  // Get scenario for a session
  Future<KobayashiScenario?> getScenario(String sessionId) async {
    final query = db.select(db.kobayashiScenarios)
      ..where((tbl) => tbl.sessionId.equals(sessionId));
    
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return KobayashiScenario(
      id: row.id,
      sessionId: row.sessionId,
      role: row.role,
      context: row.context,
      traits: row.traits,
      goals: row.goals,
      winConditions: row.winConditions,
      createdAt: row.createdAt,
    );
  }

  // Watch scenario for a session (reactive)
  Stream<KobayashiScenario?> watchScenario(String sessionId) {
    final query = db.select(db.kobayashiScenarios)
      ..where((tbl) => tbl.sessionId.equals(sessionId));
    
    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return KobayashiScenario(
        id: row.id,
        sessionId: row.sessionId,
        role: row.role,
        context: row.context,
        traits: row.traits,
        goals: row.goals,
        winConditions: row.winConditions,
        createdAt: row.createdAt,
      );
    });
  }

  // Save analysis for a session
  Future<KobayashiAnalysis> saveAnalysis({
    required String sessionId,
    required int overallScore,
    required List<String> strengths,
    required List<String> weaknesses,
    required List<String> recommendations,
    required String transcript,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final analysis = KobayashiAnalysis(
      id: id,
      sessionId: sessionId,
      overallScore: overallScore,
      strengths: strengths,
      weaknesses: weaknesses,
      recommendations: recommendations,
      transcript: transcript,
      createdAt: DateTime.now(),
    );

    await db.into(db.kobayashiAnalyses).insert(
      KobayashiAnalysesCompanion(
        id: Value(analysis.id),
        sessionId: Value(analysis.sessionId),
        overallScore: Value(analysis.overallScore),
        strengths: Value(jsonEncode(analysis.strengths)),
        weaknesses: Value(jsonEncode(analysis.weaknesses)),
        recommendations: Value(jsonEncode(analysis.recommendations)),
        transcript: Value(analysis.transcript),
        createdAt: Value(analysis.createdAt),
      ),
    );

    return analysis;
  }

  // Get analysis for a session
  Future<KobayashiAnalysis?> getAnalysis(String sessionId) async {
    final query = db.select(db.kobayashiAnalyses)
      ..where((tbl) => tbl.sessionId.equals(sessionId));
    
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return KobayashiAnalysis(
      id: row.id,
      sessionId: row.sessionId,
      overallScore: row.overallScore,
      strengths: List<String>.from(jsonDecode(row.strengths)),
      weaknesses: List<String>.from(jsonDecode(row.weaknesses)),
      recommendations: List<String>.from(jsonDecode(row.recommendations)),
      transcript: row.transcript,
      createdAt: row.createdAt,
    );
  }

  // Check if session has analysis
  Future<bool> hasAnalysis(String sessionId) async {
    final query = db.select(db.kobayashiAnalyses)
      ..where((tbl) => tbl.sessionId.equals(sessionId));
    
    final count = await query.get();
    return count.isNotEmpty;
  }

  // Watch analysis for a session (reactive)
  Stream<KobayashiAnalysis?> watchAnalysis(String sessionId) {
    final query = db.select(db.kobayashiAnalyses)
      ..where((tbl) => tbl.sessionId.equals(sessionId));
    
    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return KobayashiAnalysis(
        id: row.id,
        sessionId: row.sessionId,
        overallScore: row.overallScore,
        strengths: List<String>.from(jsonDecode(row.strengths)),
        weaknesses: List<String>.from(jsonDecode(row.weaknesses)),
        recommendations: List<String>.from(jsonDecode(row.recommendations)),
        transcript: row.transcript,
        createdAt: row.createdAt,
      );
    });
  }
}

