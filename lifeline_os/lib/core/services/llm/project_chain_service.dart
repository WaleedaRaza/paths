import 'dart:async';
import 'package:langchain/langchain.dart';
import 'project_prompts.dart';

class GenerationProgress {
  final String step;
  final int progress; // 0-100
  final String status; // 'pending', 'running', 'completed', 'failed'
  final String? message;
  final String? content;
  final String? sectionType;

  GenerationProgress({
    required this.step,
    required this.progress,
    required this.status,
    this.message,
    this.content,
    this.sectionType,
  });
}

class ProjectChainService {
  final BaseChatModel _llm;

  ProjectChainService(this._llm);

  /// Main orchestrator - generates all sections with field-level detail
  Stream<GenerationProgress> generateFullPlan(String projectIdea) async* {
    try {
      // Step 1: Project Info (5 fields)
      yield GenerationProgress(step: 'Project Info', progress: 0, status: 'running');
      final info = await _generateProjectInfo(projectIdea);
      yield GenerationProgress(
        step: 'Project Info',
        progress: 20,
        status: 'completed',
        message: 'Project info generated',
        content: info,
        sectionType: 'info',
      );

      // Step 2: Research & Stack (5 fields, uses info context)
      yield GenerationProgress(step: 'Research', progress: 20, status: 'running');
      final research = await _generateResearch(projectIdea, info);
      yield GenerationProgress(
        step: 'Research',
        progress: 40,
        status: 'completed',
        message: 'Tech research complete',
        content: research,
        sectionType: 'research',
      );

      // Step 3: Technical Architecture (6 fields, uses research context)
      yield GenerationProgress(step: 'Architecture', progress: 40, status: 'running');
      final architecture = await _generateArchitecture(projectIdea, info, research);
      yield GenerationProgress(
        step: 'Architecture',
        progress: 60,
        status: 'completed',
        message: 'Architecture designed',
        content: architecture,
        sectionType: 'architecture',
      );

      // Step 4: Feature Breakdown (4 fields, uses all previous context)
      yield GenerationProgress(step: 'Features', progress: 60, status: 'running');
      final features = await _generateFeatures(projectIdea, info, research, architecture);
      yield GenerationProgress(
        step: 'Features',
        progress: 80,
        status: 'completed',
        message: 'Features mapped out',
        content: features,
        sectionType: 'features',
      );

      // Step 5: Division of Labor (4 fields, uses all previous context)
      yield GenerationProgress(step: 'Labor', progress: 80, status: 'running');
      final labor = await _generateLabor(projectIdea, info, research, architecture, features);
      yield GenerationProgress(
        step: 'Labor',
        progress: 100,
        status: 'completed',
        message: 'Timeline estimated',
        content: labor,
        sectionType: 'labor',
      );

    } catch (e) {
      yield GenerationProgress(
        step: 'Error',
        progress: 0,
        status: 'failed',
        message: e.toString(),
      );
    }
  }

  /// STEP 1: Project Info (Foundation)
  Future<String> _generateProjectInfo(String idea) async {
    final chain = LLMChain(
      llm: _llm,
      prompt: ProjectPrompts.projectInfo,
    );

    final result = await chain.call({'idea': idea});
    // LangChain returns the output in 'output' or 'text' key
    return (result['output'] ?? result['text'] ?? '').toString();
  }

  /// STEP 2: Research & Stack (Technical foundation)
  Future<String> _generateResearch(String idea, String projectInfo) async {
    final chain = LLMChain(
      llm: _llm,
      prompt: ProjectPrompts.research,
    );

    final result = await chain.call({'project_info': projectInfo});
    return (result['output'] ?? result['text'] ?? '').toString();
  }

  /// STEP 3: Technical Architecture (System design)
  Future<String> _generateArchitecture(String idea, String info, String research) async {
    final chain = LLMChain(
      llm: _llm,
      prompt: ProjectPrompts.architecture,
    );

    final result = await chain.call({
      'project_info': info,
      'research': research,
    });
    return (result['output'] ?? result['text'] ?? '').toString();
  }

  /// STEP 4: Feature Breakdown (What to build)
  Future<String> _generateFeatures(String idea, String info, String research, String architecture) async {
    final chain = LLMChain(
      llm: _llm,
      prompt: ProjectPrompts.features,
    );

    final result = await chain.call({
      'project_info': info,
      'architecture': architecture,
    });
    return (result['output'] ?? result['text'] ?? '').toString();
  }

  /// STEP 5: Division of Labor (Who does what)
  Future<String> _generateLabor(String idea, String info, String research, String architecture, String features) async {
    final chain = LLMChain(
      llm: _llm,
      prompt: ProjectPrompts.labor,
    );

    final result = await chain.call({
      'project_info': info,
      'research': research,
      'architecture': architecture,
      'features': features,
    });
    return (result['output'] ?? result['text'] ?? '').toString();
  }
}