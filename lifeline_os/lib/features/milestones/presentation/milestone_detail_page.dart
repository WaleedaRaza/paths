import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets/domain_metadata/domain_metadata_widget.dart';
import '../providers/milestones_provider.dart';
import '../providers/milestones_repository.dart';
import '../providers/milestone_stats_provider.dart';
import '../../goals/providers/goals_provider.dart';
import '../../goals/presentation/goal_detail_page.dart';
import '../../tasks/providers/tasks_provider.dart';
import 'widgets/milestone_modal.dart';

class MilestoneDetailPage extends ConsumerWidget {
  final String milestoneId;

  const MilestoneDetailPage({super.key, required this.milestoneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestoneAsync = ref.watch(milestoneProvider(milestoneId));
    final statsAsync = ref.watch(milestoneStatsProvider(milestoneId));
    final goalsAsync = ref.watch(goalsByMilestoneProvider(milestoneId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Milestone Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MilestoneModal(milestoneId: milestoneId),
              );
            },
            tooltip: 'Edit Milestone',
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () => _showDeleteConfirmation(context, ref),
            tooltip: 'Delete Milestone',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: milestoneAsync.when(
        data: (milestone) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.flag, size: 14),
                    label: const Text('Milestones'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Domain Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDomainColor(milestone.domain).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getDomainIcon(milestone.domain),
                            size: 16,
                            color: _getDomainColor(milestone.domain),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            milestone.domain.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _getDomainColor(milestone.domain),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      milestone.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    if (milestone.description != null && milestone.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        milestone.description!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Stats
                    statsAsync.when(
                      data: (stats) => Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildStatCard(
                            icon: LucideIcons.target,
                            label: 'Goals',
                            value: '${stats.completedGoals}/${stats.totalGoals}',
                            color: AppColors.secondary,
                          ),
                          _buildStatCard(
                            icon: LucideIcons.listChecks,
                            label: 'Tasks',
                            value: '${stats.completedTasks}/${stats.totalTasks}',
                            color: AppColors.primary,
                          ),
                          _buildStatCard(
                            icon: LucideIcons.zap,
                            label: 'Points',
                            value: '${milestone.totalPoints}',
                            color: AppColors.accent,
                          ),
                          _buildStatCard(
                            icon: LucideIcons.percent,
                            label: 'Progress',
                            value: '${(stats.progress * 100).toInt()}%',
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Goals with Progress Chart (Merged)
              goalsAsync.when(
                data: (goals) {
                  if (goals.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text(
                          'No goals yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Goals',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProgressChart(context, ref, goals),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading goals'),
              ),

              const SizedBox(height: 24),

              // Domain Metadata (Full View)
              if (milestone.metadata != null && milestone.metadata!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DomainMetadataWidget(
                    domain: milestone.domain,
                    metadataJson: milestone.metadata,
                    compact: false, // Full view
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading milestone')),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getDomainIcon(domain) {
    switch (domain.toString()) {
      case 'Domain.school':
        return LucideIcons.graduationCap;
      case 'Domain.projects':
        return LucideIcons.code;
      case 'Domain.finance':
        return LucideIcons.dollarSign;
      case 'Domain.health':
        return LucideIcons.heart;
      default:
        return LucideIcons.flag;
    }
  }

  Color _getDomainColor(domain) {
    switch (domain.toString()) {
      case 'Domain.school':
        return const Color(0xFF6366F1);
      case 'Domain.projects':
        return const Color(0xFF10B981);
      case 'Domain.finance':
        return const Color(0xFFF59E0B);
      case 'Domain.health':
        return const Color(0xFFEF4444);
      default:
        return AppColors.primary;
    }
  }

  Widget _buildProgressChart(BuildContext context, WidgetRef ref, List goals) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: goals.map<Widget>((goal) {
          final tasksAsync = ref.watch(tasksByGoalProvider(goal.id));
          
          return tasksAsync.when(
            data: (tasks) {
              final completedTasks = tasks.where((t) => t.isCompleted).length;
              final totalTasks = tasks.length;
              final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
              
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GoalDetailPage(goalId: goal.id),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  goal.isCompleted ? LucideIcons.check : LucideIcons.target,
                                  size: 14,
                                  color: goal.isCompleted
                                      ? AppColors.secondary
                                      : AppColors.primary,
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
                                          : TextDecoration.none,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              if (!goal.isCompleted && totalTasks > 0)
                                Text(
                                  '$completedTasks/$totalTasks',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: goal.isCompleted
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 14,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Progress bar
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Container(
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.border.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: 28,
                                width: constraints.maxWidth * progress,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: goal.isCompleted
                                        ? [AppColors.secondary, AppColors.secondary.withOpacity(0.7)]
                                        : [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: goal.isCompleted
                                          ? AppColors.secondary.withOpacity(0.3)
                                          : AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 40),
            error: (_, __) => const SizedBox.shrink(),
          );
        }).toList(),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Milestone?'),
        content: const Text('This will delete the milestone and all associated goals and tasks. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Close dialog first
              final repo = ref.read(milestonesRepositoryProvider);
              await repo.deleteMilestone(milestoneId);
              if (context.mounted) {
                Navigator.pop(context); // Then close detail page
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

