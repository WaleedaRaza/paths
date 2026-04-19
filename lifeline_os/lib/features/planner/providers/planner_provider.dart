import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/llm_provider.dart';
import '../../../core/services/llm/project_chain_service.dart';
import '../repositories/planner_repository.dart';
import '../services/refinement_service.dart';

// Planner repository provider
final plannerRepositoryProvider = Provider<PlannerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PlannerRepository(db);
});

// Project chain service provider (uses active LLM from config)
final projectChainServiceProvider = Provider<ProjectChainService?>((ref) {
  final llm = ref.watch(activeLLMProvider);
  if (llm == null) return null;
  return ProjectChainService(llm);
});

// Refinement service provider (uses active LLM from config)
final refinementServiceProvider = Provider<RefinementService?>((ref) {
  final llm = ref.watch(activeLLMProvider);
  if (llm == null) return null;
  return RefinementService(llm);
});

// Current active plan ID
final currentPlanProvider = StateProvider<String?>((ref) => null);

// Current selected section type
final currentSectionProvider = StateProvider<String>((ref) => 'info');

// Watch all plans
final allPlansProvider = StreamProvider<List<ProjectPlan>>((ref) {
  final repo = ref.watch(plannerRepositoryProvider);
  return repo.watchAllPlans();
});

// Watch sections for current plan
final sectionsProvider = StreamProvider.autoDispose<List<ProjectSection>>((ref) {
  final planId = ref.watch(currentPlanProvider);
  if (planId == null) {
    return Stream.value([]);
  }
  final repo = ref.watch(plannerRepositoryProvider);
  return repo.watchSections(planId);
});

// Action: Create new plan
final createPlanProvider = Provider<Future<ProjectPlan> Function(String, String)>((ref) {
  return (String title, String description) async {
    final repo = ref.read(plannerRepositoryProvider);
    final plan = await repo.createPlan(
      title: title,
      description: description,
    );
    ref.read(currentPlanProvider.notifier).state = plan.id;
    return plan;
  };
});

// Action: Generate project plan with LLM chaining
final generatePlanProvider = Provider<Stream<GenerationProgress> Function(String, String)>((ref) {
  return (String planId, String description) async* {
    final repo = ref.read(plannerRepositoryProvider);
    final chainService = ref.read(projectChainServiceProvider);

    if (chainService == null) {
      yield GenerationProgress(
        step: 'Error',
        progress: 0,
        status: 'failed',
        message: 'LLM not configured. Please check Settings.',
      );
      return;
    }

    // Create generation job
    final job = await repo.createGenerationJob(planId);

    try {
      await for (final progress in chainService.generateFullPlan(description)) {
        // Update job progress
        await repo.updateJobProgress(
          jobId: job.id,
          status: progress.status,
          currentStep: progress.step,
          progress: progress.progress,
          errorMessage: progress.message,
        );

        // Save section content when available
        if (progress.content != null && progress.sectionType != null) {
          await repo.upsertSection(
            planId: planId,
            sectionType: progress.sectionType!,
            content: progress.content!,
          );
        }

        yield progress;
      }
    } catch (e) {
      await repo.updateJobProgress(
        jobId: job.id,
        status: 'failed',
        errorMessage: e.toString(),
      );
      rethrow;
    }
  };
});

// Action: Update section content
final updateSectionProvider = Provider<Future<void> Function(String, String, String)>((ref) {
  return (String planId, String sectionType, String content) async {
    final repo = ref.read(plannerRepositoryProvider);
    await repo.upsertSection(
      planId: planId,
      sectionType: sectionType,
      content: content,
    );
  };
});

// Action: Delete plan
final deletePlanProvider = Provider<Future<void> Function(String)>((ref) {
  return (String planId) async {
    final repo = ref.read(plannerRepositoryProvider);
    await repo.deletePlan(planId);
    
    if (ref.read(currentPlanProvider) == planId) {
      ref.read(currentPlanProvider.notifier).state = null;
    }
  };
});

// Action: Regenerate section
final regenerateSectionProvider = Provider<Future<String> Function(String, String)>((ref) {
  return (String sectionType, String projectDescription) async {
    final service = ref.read(refinementServiceProvider);
    if (service == null) {
      throw Exception('LLM not configured. Please check Settings.');
    }
    return await service.regenerateSection(
      sectionType: sectionType,
      projectDescription: projectDescription,
    );
  };
});

// Action: Expand section
final expandSectionProvider = Provider<Future<String> Function(String, String, {String? focus})>((ref) {
  return (String sectionType, String currentContent, {String? focus}) async {
    final service = ref.read(refinementServiceProvider);
    if (service == null) {
      throw Exception('LLM not configured. Please check Settings.');
    }
    return await service.expandSection(
      sectionType: sectionType,
      currentContent: currentContent,
      focus: focus,
    );
  };
});

// Action: Simplify section
final simplifySectionProvider = Provider<Future<String> Function(String, String)>((ref) {
  return (String sectionType, String currentContent) async {
    final service = ref.read(refinementServiceProvider);
    if (service == null) {
      throw Exception('LLM not configured. Please check Settings.');
    }
    return await service.simplifySection(
      sectionType: sectionType,
      currentContent: currentContent,
    );
  };
});

