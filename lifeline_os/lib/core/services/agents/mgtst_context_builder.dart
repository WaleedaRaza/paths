import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../../features/milestones/providers/milestones_provider.dart';
import '../../../features/goals/providers/goals_provider.dart';
import '../../../features/tasks/providers/tasks_provider.dart';

/// Builds contextual information about user's MGTST hierarchy for AI agents
class MGTSTContextBuilder {
  /// Build comprehensive context for MGTST agents
  /// 
  /// Gathers information about existing missions, goals, tasks, and user patterns
  /// to help AI agents make contextually-aware suggestions.
  static Future<Map<String, dynamic>> buildContext(
    WidgetRef ref, {
    String? milestoneId,
    String? goalId,
  }) async {
    final context = <String, dynamic>{};
    
    // Fetch all missions
    final milestonesAsync = ref.read(allMilestonesProvider);
    await milestonesAsync.when(
      data: (milestones) async {
        context['missions'] = milestones.map((m) => {
          'id': m.id,
          'title': m.title,
          'domain': m.domain.name,
          'isCompleted': m.isCompleted,
        }).toList();
        
        // Calculate domain distribution
        final domainCounts = <String, int>{};
        for (final m in milestones) {
          domainCounts[m.domain.name] = (domainCounts[m.domain.name] ?? 0) + 1;
        }
        
        // Sort domains by frequency
        final sortedDomains = domainCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        context['patterns'] = {
          'topDomains': sortedDomains.take(3).map((e) => e.key).join(', '),
          'totalMissions': milestones.length,
          'activeMissions': milestones.where((m) => !m.isCompleted).length,
        };
      },
      loading: () {},
      error: (_, __) {},
    );
    
    // Fetch all goals
    final goalsAsync = ref.read(allGoalsProvider);
    await goalsAsync.when(
      data: (goals) async {
        context['goals'] = goals.map((g) => {
          'id': g.id,
          'title': g.title,
          'milestoneId': g.milestoneId,
          'isCompleted': g.isCompleted,
        }).toList();
        
        // If specific milestone requested, filter goals
        if (milestoneId != null) {
          final milestoneGoals = goals.where((g) => g.milestoneId == milestoneId).toList();
          context['milestoneGoals'] = milestoneGoals.map((g) => {
            'id': g.id,
            'title': g.title,
          }).toList();
        }
        
        // Calculate average goals per mission
        if (context['missions'] != null) {
          final missionCount = (context['missions'] as List).length;
          if (missionCount > 0) {
            final patterns = context['patterns'] as Map<String, dynamic>;
            patterns['avgGoalsPerMission'] = (goals.length / missionCount).toStringAsFixed(1);
          }
        }
      },
      loading: () {},
      error: (_, __) {},
    );
    
    // Fetch all tasks
    final tasksAsync = ref.read(allTasksProvider);
    await tasksAsync.when(
      data: (tasks) async {
        context['tasks'] = tasks.map((t) => {
          'id': t.id,
          'title': t.title,
          'goalId': t.goalId,
          'priority': t.priority.name,
          'energy': t.energy.name,
          'isCompleted': t.isCompleted,
        }).toList();
        
        // If specific goal requested, filter tasks
        if (goalId != null) {
          final goalTasks = tasks.where((t) => t.goalId == goalId).toList();
          context['goalTasks'] = goalTasks.map((t) => {
            'id': t.id,
            'title': t.title,
            'priority': t.priority.name,
            'energy': t.energy.name,
          }).toList();
        }
        
        // Calculate task patterns
        final priorityCounts = <String, int>{};
        final energyCounts = <String, int>{};
        
        for (final t in tasks) {
          if (t.priority.name != 'none') {
            priorityCounts[t.priority.name] = (priorityCounts[t.priority.name] ?? 0) + 1;
          }
          if (t.energy.name != 'none') {
            energyCounts[t.energy.name] = (energyCounts[t.energy.name] ?? 0) + 1;
          }
        }
        
        final patterns = context['patterns'] as Map<String, dynamic>? ?? {};
        
        if (priorityCounts.isNotEmpty) {
          final topPriority = priorityCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
          patterns['commonPriorities'] = topPriority.key;
        }
        
        if (energyCounts.isNotEmpty) {
          final topEnergy = energyCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
          patterns['commonEnergy'] = topEnergy.key;
        }
        
        // Calculate average tasks per goal
        if (context['goals'] != null) {
          final goalCount = (context['goals'] as List).length;
          if (goalCount > 0) {
            patterns['avgTasksPerGoal'] = (tasks.length / goalCount).toStringAsFixed(1);
          }
        }
        
        context['patterns'] = patterns;
      },
      loading: () {},
      error: (_, __) {},
    );
    
    return context;
  }
}

