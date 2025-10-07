import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/tables.dart';
import '../../milestones/presentation/milestone_detail_page.dart';
import '../../milestones/providers/milestones_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import '../providers/goals_provider.dart';
import 'goal_detail_page.dart';
import 'widgets/goal_modal.dart';

enum GoalFilterStatus { all, active, completed }

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  GoalFilterStatus _statusFilter = GoalFilterStatus.active;
  Domain? _domainFilter;
  final Set<String> _expandedMilestones = {};

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(allGoalsProvider);
    final milestonesAsync = ref.watch(allMilestonesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Goals',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                
                // Domain Filter
                _buildDomainFilter(),
                const SizedBox(width: 12),
                
                // Status Filter
                _buildStatusFilter(),
                const SizedBox(width: 16),
                
                // Add Goal Button
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            goalsAsync.when(
              data: (allGoals) {
                var filteredGoals = _applyFilters(allGoals);
                
                return milestonesAsync.when(
                  data: (milestones) {
                    return Expanded(
                      child: filteredGoals.isEmpty
                          ? _buildEmptyState()
                          : _buildGroupedGoalList(filteredGoals, milestones),
                    );
                  },
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Expanded(
                    child: Center(child: Text('Error loading milestones')),
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Expanded(
                child: Center(child: Text('Error loading goals')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildFilterButton('All', GoalFilterStatus.all),
          _buildFilterButton('Active', GoalFilterStatus.active),
          _buildFilterButton('Done', GoalFilterStatus.completed),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, GoalFilterStatus status) {
    final isActive = _statusFilter == status;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDomainFilter() {
    return PopupMenuButton<Domain?>(
      initialValue: _domainFilter,
      onSelected: (value) => setState(() => _domainFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.filter,
              size: 16,
              color: _domainFilter == null
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              _domainFilter == null ? 'Domain' : _domainLabel(_domainFilter!),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _domainFilter == null
                    ? AppColors.textSecondary
                    : AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: _domainFilter == null
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildDomainMenuItem('All', null),
        _buildDomainMenuItem('School', Domain.school),
        _buildDomainMenuItem('Projects', Domain.projects),
        _buildDomainMenuItem('Finance', Domain.finance),
        _buildDomainMenuItem('Health', Domain.health),
        _buildDomainMenuItem('DSA', Domain.dsa),
        _buildDomainMenuItem('Personal', Domain.personal),
      ],
    );
  }

  PopupMenuItem<Domain?> _buildDomainMenuItem(String label, Domain? domain) {
    return PopupMenuItem(
      value: domain,
      child: Row(
        children: [
          if (_domainFilter == domain)
            const Icon(LucideIcons.check, size: 16, color: AppColors.primary)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  List _applyFilters(List goals) {
    return goals.where((goal) {
      // Status filter
      if (_statusFilter == GoalFilterStatus.active && goal.isCompleted) {
        return false;
      }
      if (_statusFilter == GoalFilterStatus.completed && !goal.isCompleted) {
        return false;
      }

      // Domain filter (via parent milestone)
      if (_domainFilter != null) {
        // This will be checked in the grouped view
        return true;
      }

      return true;
    }).toList();
  }

  Widget _buildGroupedGoalList(List goals, List milestones) {
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
      children: [
        // Count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${goals.length} goals',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // Goals organized by domain sections
        ...sortedDomains.map((domain) {
          final domainGoals = goalsByDomain[domain]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain header
              _buildDomainHeader(domain!),
              const SizedBox(height: 12),
              
              // Goals grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: domainGoals.length,
                itemBuilder: (context, index) => _buildCompactGoalTile(domainGoals[index]),
              ),
              
              const SizedBox(height: 32),
            ],
          );
        }),

        // Ungrouped section
        if (ungroupedGoals.isNotEmpty) ...[
          _buildDomainHeader(null),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ungroupedGoals.length,
            itemBuilder: (context, index) => _buildCompactGoalTile(ungroupedGoals[index]),
          ),
        ],
      ],
    );
  }

  Widget _buildDomainHeader(Domain? domain) {
    return Row(
      children: [
        if (domain != null)
          Container(
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
          )
        else
          Row(
            children: [
              const Icon(
                LucideIcons.inbox,
                size: 16,
                color: AppColors.textSecondary,
              ),
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
      ],
    );
  }

  Widget _buildMilestoneGroupTile(milestone, List goals) {
    final completedCount = goals.where((g) => g.isCompleted).length;
    final progress = goals.isEmpty ? 0.0 : completedCount / goals.length;

    return InkWell(
      onTap: () {
        if (milestone != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MilestoneDetailPage(milestoneId: milestone.id),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (milestone != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _domainColor(milestone.domain).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _domainIcon(milestone.domain),
                      size: 14,
                      color: _domainColor(milestone.domain),
                    ),
                  )
                else
                  Icon(
                    LucideIcons.inbox,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                const Spacer(),
                Text(
                  '${goals.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Expanded(
              child: Text(
                milestone?.title ?? 'Ungrouped Goals',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                minHeight: 4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount/${goals.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUngroupedSection(List goals) {
    final isExpanded = _expandedMilestones.contains('ungrouped');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedMilestones.remove('ungrouped');
                } else {
                  _expandedMilestones.add('ungrouped');
                }
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    LucideIcons.inbox,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ungrouped Goals',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${goals.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Goals Grid
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: goals.length,
                itemBuilder: (context, index) => _buildCompactGoalTile(goals[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMilestoneGroup(milestone, List goals) {
    final isExpanded = _expandedMilestones.contains(milestone.id);
    final completedCount = goals.where((g) => g.isCompleted).length;
    final progress = goals.isEmpty ? 0.0 : completedCount / goals.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedMilestones.remove(milestone.id);
                } else {
                  _expandedMilestones.add(milestone.id);
                }
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      
                      // Domain badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _domainColor(milestone.domain).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _domainIcon(milestone.domain),
                              size: 12,
                              color: _domainColor(milestone.domain),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _domainLabel(milestone.domain),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _domainColor(milestone.domain),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: milestone.isCompleted
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                            decoration: milestone.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$completedCount/${goals.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Progress bar
                  if (!isExpanded) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Goals Grid
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: goals.length,
                itemBuilder: (context, index) => _buildCompactGoalTile(goals[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactGoalTile(goal) {
    final milestones = ref.watch(allMilestonesProvider);
    
    return milestones.when(
      data: (milestonesList) {
        // Find parent milestone
        dynamic parentMilestone;
        try {
          if (goal.milestoneId != null) {
            parentMilestone = milestonesList.firstWhere((m) => m.id == goal.milestoneId);
          }
        } catch (_) {}

        // Get tasks for this goal
        final tasksAsync = ref.watch(tasksByGoalProvider(goal.id));
        
        return tasksAsync.when(
          data: (tasks) {
            final completedTasks = tasks.where((t) => t.isCompleted).length;
            final totalTasks = tasks.length;
            final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

            return InkWell(
              onTap: () {
                // Navigate to goal detail page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GoalDetailPage(goalId: goal.id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: goal.isCompleted
                        ? AppColors.secondary.withOpacity(0.3)
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          goal.isCompleted ? LucideIcons.check : LucideIcons.target,
                          size: 12,
                          color: goal.isCompleted
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                        if (totalTasks > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$totalTasks',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Title
                    Expanded(
                      child: Text(
                        goal.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: goal.isCompleted
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                          decoration: goal.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Progress bar
                    if (totalTasks > 0) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.border.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation(
                            goal.isCompleted ? AppColors.secondary : AppColors.primary,
                          ),
                          minHeight: 3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedTasks/$totalTasks',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    
                    // Milestone badge (clickable link)
                    if (parentMilestone != null) ...[
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          // Navigate to milestone detail page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MilestoneDetailPage(
                                milestoneId: parentMilestone.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: _domainColor(parentMilestone.domain).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _domainColor(parentMilestone.domain).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.flag,
                                size: 8,
                                color: _domainColor(parentMilestone.domain),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  parentMilestone.title,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: _domainColor(parentMilestone.domain),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                LucideIcons.externalLink,
                                size: 7,
                                color: _domainColor(parentMilestone.domain),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          loading: () => _buildGoalTileSkeleton(goal),
          error: (_, __) => _buildGoalTileSkeleton(goal),
        );
      },
      loading: () => _buildGoalTileSkeleton(goal),
      error: (_, __) => _buildGoalTileSkeleton(goal),
    );
  }

  Widget _buildGoalTileSkeleton(goal) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            goal.isCompleted ? LucideIcons.check : LucideIcons.target,
            size: 12,
            color: AppColors.primary,
          ),
          Expanded(
            child: Center(
              child: Text(
                goal.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.target,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _statusFilter == GoalFilterStatus.completed
                ? 'No completed goals yet'
                : 'No goals yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ],
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
        return LucideIcons.binary;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _domainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return AppColors.primary;
      case Domain.projects:
        return AppColors.secondary;
      case Domain.finance:
        return const Color(0xFF10B981);
      case Domain.health:
        return const Color(0xFFEF4444);
      case Domain.dsa:
        return const Color(0xFF8B5CF6);
      case Domain.personal:
        return const Color(0xFF06B6D4);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(date.year, date.month, date.day);
    
    final diff = targetDay.difference(today).inDays;
    
    if (diff < 0) return '${diff.abs()}d ago';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 7) return '${diff}d';
    if (diff < 30) return '${(diff / 7).floor()}w';
    return '${(diff / 30).floor()}mo';
  }
}
