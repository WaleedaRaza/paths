import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:drift/drift.dart' as drift;

import '../../../app/theme.dart';
import '../../../core/database/database.dart';
import '../../../core/database/tables.dart';
import '../../../core/models/task.dart' as model;
import '../../../core/providers/database_provider.dart';
import '../../milestones/presentation/milestone_detail_page.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import '../providers/goals_provider.dart';
import 'goal_detail_page.dart';
import 'widgets/goal_modal.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  final Set<String> _collapsedMilestones = {};

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(allGoalsProvider);
    final milestonesAsync = ref.watch(allMilestonesProvider);
    final filterDomain = ref.watch(milestoneFilterDomainProvider);

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
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.secondary.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Canvas View • Scroll to Zoom',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
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

          // Goals Board View with Interactive Zoom/Pan
          Expanded(
            child: goalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.target,
                          size: 64,
                          color: AppColors.secondary.withOpacity(0.3),
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
                  data: (milestones) => InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(2000),
                    minScale: 0.3,
                    maxScale: 2.0,
                    constrained: false,
                    child: _buildBoardView(context, goals, milestones),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildSimpleGoalGrid(context, goals),
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

  Widget _buildBoardView(BuildContext context, List goals, List milestones) {
    // Build hierarchy: Milestone → Goals
    final Map<String, List> hierarchy = {};
    final List orphanedGoals = [];

    for (final goal in goals) {
      if (goal.milestoneId == null) {
        orphanedGoals.add(goal);
        continue;
      }

      hierarchy.putIfAbsent(goal.milestoneId!, () => []);
      hierarchy[goal.milestoneId]!.add(goal);
    }

    // Get domains for columns
    final Map<Domain, List<String>> columnsByDomain = {};
    for (final milestoneId in hierarchy.keys) {
      try {
        final milestone = milestones.firstWhere((m) => m.id == milestoneId);
        columnsByDomain.putIfAbsent(milestone.domain, () => []).add(milestoneId);
      } catch (_) {}
    }

    // Define column order: School | Projects | DSA | Career | Finance | Health
    final orderedDomains = [
      Domain.school,
      Domain.projects,
      Domain.dsa,
      Domain.career,
      Domain.finance,
      Domain.health,
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain columns with dividers (in specific order)
          ...orderedDomains.where((domain) => columnsByDomain.containsKey(domain)).expand((domain) {
            final milestoneIds = columnsByDomain[domain]!;
            return [
              _buildDomainColumn(context, domain, milestoneIds, hierarchy, milestones),
              // Vertical divider
              Container(
                width: 2,
                height: 1000,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _domainColor(domain).withOpacity(0.0),
                      _domainColor(domain).withOpacity(0.4),
                      _domainColor(domain).withOpacity(0.4),
                      _domainColor(domain).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ];
          }).toList()..removeLast(), // Remove last divider
          // Orphaned goals column (if any)
          if (orphanedGoals.isNotEmpty) ...[
            Container(
              width: 2,
              height: 1000,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.border.withOpacity(0.0),
                    AppColors.border,
                    AppColors.border,
                    AppColors.border.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            _buildOrphanedColumn(context, orphanedGoals),
          ],
        ],
      ),
    );
  }

  Widget _buildDomainColumn(BuildContext context, Domain domain, List<String> milestoneIds, Map<String, List> hierarchy, List milestones) {
    // Count total goals in this domain
    int totalGoals = 0;
    for (final milestoneId in milestoneIds) {
      totalGoals += hierarchy[milestoneId]!.length;
    }

    final domainColor = _domainColor(domain);

    return SizedBox(
      width: 440,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (unique color per domain)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  domainColor.withOpacity(0.2),
                  domainColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: domainColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _domainIcon(domain),
                  size: 24,
                  color: domainColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _domainLabel(domain),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: domainColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: domainColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$totalGoals',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: domainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Column Content
          ...milestoneIds.expand((milestoneId) {
            dynamic milestone;
            try {
              milestone = milestones.firstWhere((m) => m.id == milestoneId);
            } catch (_) {}

            final milestoneGoals = hierarchy[milestoneId]!;
            final isMilestoneCollapsed = _collapsedMilestones.contains(milestoneId);
            
            return [
              // Milestone Heading (BIGGER, ORANGE)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.flag,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        milestone?.title ?? 'No Milestone',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${milestoneGoals.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Collapse button
                    IconButton(
                      icon: Icon(
                        isMilestoneCollapsed ? LucideIcons.chevronRight : LucideIcons.chevronDown,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          if (isMilestoneCollapsed) {
                            _collapsedMilestones.remove(milestoneId);
                          } else {
                            _collapsedMilestones.add(milestoneId);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    // Open in window button
                    if (milestone != null)
                      IconButton(
                        icon: const Icon(
                          LucideIcons.externalLink,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Goal Tiles Grid (if not collapsed) - SQUARE TILES
              if (!isMilestoneCollapsed)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: milestoneGoals.length,
                  itemBuilder: (context, index) => _buildGoalTile(context, milestoneGoals[index]),
                ),

              const SizedBox(height: 24),
            ];
          }),
        ],
      ),
    );
  }

  Widget _buildOrphanedColumn(BuildContext context, List orphanedGoals) {
    return SizedBox(
      width: 440,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header (neutral)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.inbox,
                  size: 24,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Ungrouped',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Text(
                  '${orphanedGoals.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Column Content - SQUARE TILES
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: orphanedGoals.length,
            itemBuilder: (context, index) => _buildGoalTile(context, orphanedGoals[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTile(BuildContext context, goal) {
    // Get completion status emoji
    final statusEmoji = goal.isCompleted ? '✅' : '🎯';

    return Material(
      color: Colors.transparent,
      child: InkWell(
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
              color: AppColors.secondary.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status emoji + Goal title
              Row(
                children: [
                  Text(
                    statusEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: goal.isCompleted 
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration: goal.isCompleted 
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.2,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Completion indicator
                  if (goal.isCompleted)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Divider
              Container(
                height: 1,
                color: AppColors.border.withOpacity(0.3),
              ),
              
              const SizedBox(height: 8),

              // Task Preview Section (Scrollable)
              Expanded(
                child: _GoalTaskPreview(goalId: goal.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleGoalGrid(BuildContext context, List goals) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: goals.length,
      itemBuilder: (context, index) => _buildGoalTile(context, goals[index]),
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
        return 'LeetCode';
      case Domain.career:
        return 'Career';
      case Domain.gre:
        return 'GRE';
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
      case Domain.career:
        return LucideIcons.briefcase;
      case Domain.gre:
        return LucideIcons.bookOpen;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _domainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return Colors.indigo.shade400;
      case Domain.projects:
        return Colors.purple.shade400;
      case Domain.finance:
        return Colors.teal.shade400;
      case Domain.health:
        return Colors.orange.shade400;
      case Domain.dsa:
        return Colors.blue.shade400;
      case Domain.career:
        return Colors.cyan.shade400;
      case Domain.gre:
        return Colors.amber.shade400;
      case Domain.personal:
        return Colors.pink.shade400;
    }
  }
}

// Task Preview Widget for Goal Tiles
class _GoalTaskPreview extends ConsumerWidget {
  final String goalId;

  const _GoalTaskPreview({required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    
    return FutureBuilder<List<Task>>(
      future: (database.select(database.tasks)
            ..where((tbl) => tbl.goalId.equals(goalId))
            ..orderBy([
              (tbl) => drift.OrderingTerm.asc(tbl.isCompleted),
              (tbl) => drift.OrderingTerm.desc(tbl.createdAt),
            ])
            ..limit(5))
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        final tasks = snapshot.data!;

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final task = tasks[index];
            final priorityColor = _getPriorityColor(task.priority);
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: task.isCompleted 
                    ? AppColors.border.withOpacity(0.1)
                    : AppColors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: task.isCompleted
                      ? AppColors.border.withOpacity(0.2)
                      : priorityColor.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  // Priority dot
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: task.isCompleted 
                          ? AppColors.textTertiary
                          : priorityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Task title
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: task.isCompleted 
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough
                            : null,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Energy/Points indicator
                  if (!task.isCompleted) ...[
                    const SizedBox(width: 4),
                    Text(
                      _getEnergyEmoji(task.energy),
                      style: const TextStyle(fontSize: 10),
                    ),
                    if (task.totalPoints > 0) ...[
                      const SizedBox(width: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${task.totalPoints}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(int priorityIndex) {
    if (priorityIndex >= model.TaskPriority.values.length) {
      return AppColors.textTertiary;
    }
    final priority = model.TaskPriority.values[priorityIndex];
    if (priority == model.TaskPriority.high) {
      return Colors.red.shade400;
    } else if (priority == model.TaskPriority.medium) {
      return Colors.orange.shade400;
    } else if (priority == model.TaskPriority.low) {
      return Colors.yellow.shade600;
    } else {
      return AppColors.textTertiary;
    }
  }

  String _getEnergyEmoji(int energyIndex) {
    if (energyIndex >= model.TaskEnergy.values.length) {
      return '○';
    }
    final energy = model.TaskEnergy.values[energyIndex];
    if (energy == model.TaskEnergy.high) {
      return '⚡';
    } else if (energy == model.TaskEnergy.medium) {
      return '💪';
    } else if (energy == model.TaskEnergy.low) {
      return '🌙';
    } else {
      return '○';
    }
  }
}
