import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';

/// Repository for managing project plans
class PlannerRepository {
  final AppDatabase db;
  final _uuid = const Uuid();

  PlannerRepository(this.db);

  /// Create a new project plan
  Future<ProjectPlan> createPlan({
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    final plan = ProjectPlansCompanion.insert(
      id: _uuid.v4(),
      title: title,
      description: description,
      status: 'draft',
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await db.into(db.projectPlans).insert(plan);
    
    return await (db.select(db.projectPlans)
          ..where((p) => p.id.equals(plan.id.value)))
        .getSingle();
  }

  /// Get a specific plan
  Future<ProjectPlan> getPlan(String planId) async {
    return await (db.select(db.projectPlans)
          ..where((p) => p.id.equals(planId)))
        .getSingle();
  }

  /// Watch all plans
  Stream<List<ProjectPlan>> watchAllPlans() {
    return (db.select(db.projectPlans)
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .watch();
  }

  /// Update plan status
  Future<void> updatePlanStatus(String planId, String status) async {
    await (db.update(db.projectPlans)
          ..where((p) => p.id.equals(planId)))
        .write(ProjectPlansCompanion(
      status: Value(status),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Delete a plan
  Future<void> deletePlan(String planId) async {
    await (db.delete(db.projectPlans)
          ..where((p) => p.id.equals(planId)))
        .go();
  }

  /// Create or update a section
  Future<void> upsertSection({
    required String planId,
    required String sectionType,
    required String content,
  }) async {
    final existing = await (db.select(db.projectSections)
          ..where((s) => s.planId.equals(planId) & s.sectionType.equals(sectionType)))
        .getSingleOrNull();

    if (existing != null) {
      // Update existing
      await (db.update(db.projectSections)
            ..where((s) => s.id.equals(existing.id)))
          .write(ProjectSectionsCompanion(
        content: Value(content),
        version: Value(existing.version + 1),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      // Create new
      final section = ProjectSectionsCompanion.insert(
        id: _uuid.v4(),
        planId: planId,
        sectionType: sectionType,
        content: content,
        version: const Value(1),
        updatedAt: Value(DateTime.now()),
      );
      await db.into(db.projectSections).insert(section);
    }

    // Update plan's updatedAt
    await (db.update(db.projectPlans)
          ..where((p) => p.id.equals(planId)))
        .write(ProjectPlansCompanion(updatedAt: Value(DateTime.now())));
  }

  /// Watch sections for a plan
  Stream<List<ProjectSection>> watchSections(String planId) {
    return (db.select(db.projectSections)
          ..where((s) => s.planId.equals(planId)))
        .watch();
  }

  /// Get all sections for a plan
  Future<List<ProjectSection>> getSections(String planId) async {
    return await (db.select(db.projectSections)
          ..where((s) => s.planId.equals(planId)))
        .get();
  }

  /// Create generation job
  Future<GenerationJob> createGenerationJob(String planId) async {
    final job = GenerationJobsCompanion.insert(
      id: _uuid.v4(),
      planId: planId,
      status: 'pending',
      currentStep: const Value(null),
      progress: const Value(0),
      errorMessage: const Value(null),
      startedAt: Value(DateTime.now()),
      completedAt: const Value(null),
    );

    await db.into(db.generationJobs).insert(job);
    
    return await (db.select(db.generationJobs)
          ..where((j) => j.id.equals(job.id.value)))
        .getSingle();
  }

  /// Update generation job progress
  Future<void> updateJobProgress({
    required String jobId,
    required String status,
    String? currentStep,
    int? progress,
    String? errorMessage,
  }) async {
    await (db.update(db.generationJobs)
          ..where((j) => j.id.equals(jobId)))
        .write(GenerationJobsCompanion(
      status: Value(status),
      currentStep: Value(currentStep),
      progress: progress != null ? Value(progress) : const Value.absent(),
      errorMessage: Value(errorMessage),
      completedAt: status == 'completed' || status == 'failed'
          ? Value(DateTime.now())
          : const Value(null),
    ));
  }

  /// Watch generation job
  Stream<GenerationJob?> watchJob(String jobId) {
    return (db.select(db.generationJobs)
          ..where((j) => j.id.equals(jobId)))
        .watchSingleOrNull();
  }
}

