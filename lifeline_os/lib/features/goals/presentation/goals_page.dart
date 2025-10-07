import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/tables.dart';
import '../../milestones/presentation/milestone_detail_page.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../providers/goals_provider.dart';
import 'goal_detail_page.dart';
import 'widgets/goal_modal.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(allGoalsProvider); // Use all goals, we'll filter by milestone
    final milestonesAsync = ref.watch(allMilestonesProvider);
    final filterDomain = ref.watch(milestoneFilterDomainProvider); // Use milestone domain filter

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Filters
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Goals',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const GoalModal(),
                        );
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('New Goal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Row
                Row(
                  children: [
                    // Domain/Type Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButton<Domain?>(
                        value: filterDomain,
                        hint: const Text('All Types', style: TextStyle(fontSize: 14)),
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Types')),
                          ...Domain.values.map((domain) => DropdownMenuItem(
                            value: domain,
                            child: Text(_domainLabel(domain)),
                          )),
                        ],
                        onChanged: (value) => ref.read(milestoneFilterDomainProvider.notifier).state = value,
                      ),
                    ),
                    const Spacer(),
                    // Clear Filters
                    if (filterDomain != null)
                      TextButton.icon(
                        onPressed: () {
                          ref.read(milestoneFilterDomainProvider.notifier).state = null;
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Goals Grid
          Expanded(
            child: goalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.target,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No goals found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create a goal or adjust your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return milestonesAsync.when(
                  data: (milestones) => _buildGroupedGoalsList(context, ref, goals, milestones),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildSimpleGoalsList(context, ref, goals),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedGoalsList(BuildContext context, WidgetRef ref, List goals, List milestones) {
    // Apply domain filter if set
    final filterDomain = ref.watch(milestoneFilterDomainProvider);
    
    // Filter milestones by domain if needed
    var filteredMilestones = milestones;
    if (filterDomain != null) {
      filteredMilestones = milestones.where((m) => m.domain == filterDomain).toList();
    }
    
    // Group goals by milestone
    final Map<String, List> goalsByMilestone = {};
    final List ungroupedGoals = [];

    for (final goal in goals) {
      if (goal.milestoneId == null) {
        ungroupedGoals.add(goal);
      } else {
        // Only include if milestone matches filter (or no filter)
        if (filterDomain == null || filteredMilestones.any((m) => m.id == goal.milestoneId)) {
          goalsByMilestone.putIfAbsent(goal.milestoneId, () => []).add(goal);
        }
      }
    }

    // Sort milestones
    final sortedMilestoneIds = goalsByMilestone.keys.toList()
      ..sort((a, b) {
        try {
          final milestoneA = milestones.firstWhere((m) => m.id == a);
          final milestoneB = milestones.firstWhere((m) => m.id == b);
          return milestoneB.createdAt.compareTo(milestoneA.createdAt); // Newest first
        } catch (_) {
          return 0;
        }
      });

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        // Goals organized by milestone sections
        ...sortedMilestoneIds.map((milestoneId) {
          final milestoneGoals = goalsByMilestone[milestoneId]!;
          dynamic milestone;
          try {
            milestone = milestones.firstWhere((m) => m.id == milestoneId);
          } catch (_) {}
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Milestone header
              _buildMilestoneHeader(context, milestone),
              const SizedBox(height: 12),

              // Goals grid - responsive 4-5 per row
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  if (constraints.maxWidth > 1600) {
                    crossAxisCount = 5;
                  } else if (constraints.maxWidth < 1000) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: milestoneGoals.length,
                    itemBuilder: (context, index) => _buildCompactGoalTile(context, ref, milestoneGoals[index], milestones),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          );
        }),

        // Ungrouped section
        if (ungroupedGoals.isNotEmpty) ...[
          Row(
            children: [
              const Icon(LucideIcons.inbox, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Ungrouped',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth > 1600) {
                crossAxisCount = 5;
              } else if (constraints.maxWidth < 1000) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: ungroupedGoals.length,
                itemBuilder: (context, index) => _buildCompactGoalTile(context, ref, ungroupedGoals[index], milestones),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSimpleGoalsList(BuildContext context, WidgetRef ref, List goals) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth > 1600) {
          crossAxisCount = 5;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: goals.length,
          itemBuilder: (context, index) => _buildCompactGoalTile(context, ref, goals[index], []),
        );
      },
    );
  }

  Widget _buildMilestoneHeader(BuildContext context, dynamic milestone) {
    if (milestone == null) {
      return Row(
        children: [
          const Icon(LucideIcons.inbox, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          const Text(
            'No Milestone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }
    
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Domain icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _domainColor(milestone.domain).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _domainIcon(milestone.domain),
                size: 16,
                color: _domainColor(milestone.domain),
              ),
            ),
            const SizedBox(width: 12),
            // Milestone title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (milestone.description != null && milestone.description!.isNotEmpty)
                    Text(
                      milestone.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Navigate icon
            const Icon(
              LucideIcons.externalLink,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactGoalTile(BuildContext context, WidgetRef ref, goal, List milestones) {
    // Find milestone for badge
    dynamic milestone;
    try {
      if (goal.milestoneId != null && milestones.isNotEmpty) {
        milestone = milestones.firstWhere((m) => m.id == goal.milestoneId);
      }
    } catch (_) {}

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalDetailPage(goalId: goal.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: goal.isCompleted ? Colors.green.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with milestone badge
            Row(
              children: [
                if (milestone != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _domainColor(milestone.domain).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        _domainIcon(milestone.domain),
                        size: 10,
                        color: _domainColor(milestone.domain),
                      ),
                    ),
                  ),
                const Spacer(),
                if (goal.isCompleted)
                  const Icon(LucideIcons.check, size: 14, color: Colors.green),
              ],
            ),
            const SizedBox(height: 8),

            // Goal title
            Expanded(
              child: Text(
                goal.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 0.0, // Placeholder - would compute from tasks
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isCompleted ? Colors.green : AppColors.primary,
                ),
                minHeight: 3,
              ),
            ),

            const SizedBox(height: 6),

            // Points
            Text(
              '${goal.totalPoints} pts',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _domainLabel(Domain domain) {
    switch (domain) {
      case Domain.school:
        return 'School';
      case Domain.projects:
        return 'Projects';
      case Domain.finance:
        return 'Finance';
      case Domain.health:
        return 'Health';
      case Domain.dsa:
        return 'DSA';
      case Domain.personal:
        return 'Personal';
    }
  }

  IconData _domainIcon(Domain domain) {
    switch (domain) {
      case Domain.school:
        return LucideIcons.graduationCap;
      case Domain.projects:
        return LucideIcons.code;
      case Domain.finance:
        return LucideIcons.dollarSign;
      case Domain.health:
        return LucideIcons.heart;
      case Domain.dsa:
        return LucideIcons.cpu;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _domainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return Colors.indigo;
      case Domain.projects:
        return Colors.purple;
      case Domain.finance:
        return Colors.teal;
      case Domain.health:
        return Colors.orange;
      case Domain.dsa:
        return Colors.blue;
      case Domain.personal:
        return Colors.pink;
    }
  }
}
