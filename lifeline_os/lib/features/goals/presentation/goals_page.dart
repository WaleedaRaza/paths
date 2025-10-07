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
    final goalsAsync = ref.watch(filteredGoalsProvider);
    final milestonesAsync = ref.watch(allMilestonesProvider);
    final filterMilestone = ref.watch(goalFilterMilestoneProvider);
    final filterStatus = ref.watch(goalFilterStatusProvider);

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
                    // Milestone Filter
                    milestonesAsync.when(
                      data: (milestones) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButton<String?>(
                          value: filterMilestone,
                          hint: const Text('All Milestones', style: TextStyle(fontSize: 14)),
                          underline: const SizedBox.shrink(),
                          isDense: true,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Milestones')),
                            ...milestones.map((milestone) => DropdownMenuItem(
                              value: milestone.id,
                              child: Text(milestone.title, overflow: TextOverflow.ellipsis),
                            )),
                          ],
                          onChanged: (value) => ref.read(goalFilterMilestoneProvider.notifier).state = value,
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 12),
                    // Status Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButton<bool?>(
                        value: filterStatus,
                        hint: const Text('All Status', style: TextStyle(fontSize: 14)),
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All Status')),
                          DropdownMenuItem(value: false, child: Text('Active')),
                          DropdownMenuItem(value: true, child: Text('Completed')),
                        ],
                        onChanged: (value) => ref.read(goalFilterStatusProvider.notifier).state = value,
                      ),
                    ),
                    const Spacer(),
                    // Clear Filters
                    if (filterMilestone != null || filterStatus != null)
                      TextButton.icon(
                        onPressed: () {
                          ref.read(goalFilterMilestoneProvider.notifier).state = null;
                          ref.read(goalFilterStatusProvider.notifier).state = null;
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
    // Group goals by domain (via their parent milestone)
    final Map<Domain?, List> goalsByDomain = {};
    final List ungroupedGoals = [];

    for (final goal in goals) {
      if (goal.milestoneId == null) {
        ungroupedGoals.add(goal);
      } else {
        try {
          final milestone = milestones.firstWhere((m) => m.id == goal.milestoneId);
          goalsByDomain.putIfAbsent(milestone.domain, () => []).add(goal);
        } catch (_) {
          ungroupedGoals.add(goal);
        }
      }
    }

    // Sort domains
    final sortedDomains = goalsByDomain.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.index.compareTo(b.index);
      });

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        // Goals organized by domain sections
        ...sortedDomains.map((domain) {
          final domainGoals = goalsByDomain[domain]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain header
              _buildDomainHeader(domain!),
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
                    itemCount: domainGoals.length,
                    itemBuilder: (context, index) => _buildCompactGoalTile(context, ref, domainGoals[index], milestones),
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

  Widget _buildDomainHeader(Domain domain) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _domainColor(domain).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _domainIcon(domain),
            size: 16,
            color: _domainColor(domain),
          ),
          const SizedBox(width: 6),
          Text(
            _domainLabel(domain),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _domainColor(domain),
            ),
          ),
        ],
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
