import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/goal.dart';
import '../../../../core/models/task.dart';
import '../../../../core/database/tables.dart';
import '../../../../shared/widgets/domain_metadata/domain_metadata_widget.dart';
import '../../../milestones/providers/milestones_provider.dart';
import '../../../tasks/providers/tasks_provider.dart' as tasks_providers;
import '../../providers/goals_repository.dart';
import '../../providers/goals_provider.dart';
import '../../providers/goal_stats_provider.dart';
import 'goal_modal.dart';

enum GoalCardExpansion { collapsed, preview, expanded }

class GoalCard extends ConsumerStatefulWidget {
  final Goal goal;
  final int level;

  const GoalCard({
    super.key,
    required this.goal,
    this.level = 0,
  });

  @override
  ConsumerState<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<GoalCard> {
  GoalCardExpansion _expansion = GoalCardExpansion.collapsed;

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(goalsRepositoryProvider);
    final childGoalsAsync = ref.watch(childGoalsProvider(widget.goal.id));
    final statsAsync = ref.watch(goalStatsProvider(widget.goal.id));
    final tasksAsync = ref.watch(tasks_providers.tasksByGoalProvider(widget.goal.id));
    
    // Get parent milestone if exists
    final milestoneAsync = widget.goal.milestoneId != null
        ? ref.watch(milestoneByIdProvider(widget.goal.milestoneId!))
        : null;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (_expansion == GoalCardExpansion.collapsed) {
              setState(() => _expansion = GoalCardExpansion.preview);
            } else if (_expansion == GoalCardExpansion.preview) {
              setState(() => _expansion = GoalCardExpansion.collapsed);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(left: widget.level * 24.0, bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.goal.isCompleted
                  ? AppColors.secondary.withOpacity(0.05)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _expansion != GoalCardExpansion.collapsed
                    ? AppColors.secondary.withOpacity(0.5)
                    : widget.goal.isCompleted
                        ? AppColors.secondary.withOpacity(0.3)
                        : AppColors.border,
                width: _expansion != GoalCardExpansion.collapsed ? 2 : 1.5,
              ),
              boxShadow: _expansion != GoalCardExpansion.collapsed
                  ? [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Parent Milestone + Expand Icon
                if (milestoneAsync != null)
                  milestoneAsync.when(
                    data: (milestone) => _buildParentMilestoneBadge(milestone),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                
                const SizedBox(height: 10),
                
                // Title Row with Checkbox
                Row(
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: () => repo.toggleGoal(widget.goal.id, !widget.goal.isCompleted),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: widget.goal.isCompleted
                              ? AppColors.secondary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.goal.isCompleted
                                ? AppColors.secondary
                                : AppColors.textTertiary,
                            width: 2.5,
                          ),
                        ),
                        child: widget.goal.isCompleted
                            ? const Icon(
                                LucideIcons.check,
                                size: 18,
                                color: Colors.white,
                              ).animate().scale(duration: 200.ms)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    // Title
                    Expanded(
                      child: Text(
                        widget.goal.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: widget.goal.isCompleted
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                          decoration: widget.goal.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          height: 1.3,
                        ),
                      ),
                    ),
                    
                    // Expand Icon
                    Icon(
                      _expansion == GoalCardExpansion.collapsed
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronUp,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Progress + Stats
                statsAsync.when(
                  data: (stats) => _buildProgressAndStats(stats, tasksAsync),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                
                // Domain Metadata Preview
                if (widget.goal.metadata != null && widget.goal.metadata!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  // Get domain from parent milestone (for now, using mock)
                  DomainMetadataWidget(
                    domain: Domain.school, // TODO: get from parent milestone
                    metadataJson: widget.goal.metadata,
                    compact: true,
                  ),
                ],
                
                // Inline Task List (preview/expanded)
                if (_expansion != GoalCardExpansion.collapsed) ...[
                  const SizedBox(height: 14),
                  tasksAsync.when(
                    data: (tasks) => _buildTaskList(tasks),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Error loading tasks'),
                  ),
                ],
                
                const SizedBox(height: 12),
                
                // Bottom Row: Points + Quick Actions
                _buildBottomRow(),
                
                // Quick Action Bar
                if (_expansion != GoalCardExpansion.collapsed) ...[
                  const SizedBox(height: 12),
                  _buildQuickActions(),
                ],
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: -0.05, end: 0, duration: 300.ms),
        
        // Child goals (sub-goals)
        childGoalsAsync.when(
          data: (children) {
            if (children.isEmpty) return const SizedBox.shrink();
            return Column(
              children: children.map((child) {
                return GoalCard(goal: child, level: widget.level + 1);
              }).toList(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildParentMilestoneBadge(milestone) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to milestone detail
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.flag,
              size: 12,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Milestone: ${milestone.title}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              LucideIcons.externalLink,
              size: 10,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressAndStats(GoalStats stats, AsyncValue<List<Task>> tasksAsync) {
    // Count overdue tasks
    final overdueTasks = tasksAsync.maybeWhen(
      data: (tasks) => tasks.where((t) {
        return !t.isCompleted &&
            t.dueDate != null &&
            t.dueDate!.isBefore(DateTime.now());
      }).length,
      orElse: () => 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar with %
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(stats.progress * 100).toStringAsFixed(0)}% Complete',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${stats.completedTasks}/${stats.totalTasks} tasks',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: stats.progress,
            backgroundColor: AppColors.border.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              stats.progress > 0.8
                  ? Colors.green
                  : stats.progress > 0.5
                      ? AppColors.secondary
                      : AppColors.primary,
            ),
            minHeight: 8,
          ),
        ),
        
        // Stats badges
        if (stats.totalTasks > 0 || stats.totalSubGoals > 0) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (stats.totalTasks > 0)
                _buildStatBadge(
                  icon: LucideIcons.listChecks,
                  label: '${stats.completedTasks} done',
                  color: AppColors.secondary,
                ),
              if (overdueTasks > 0)
                _buildStatBadge(
                  icon: Icons.warning_rounded,
                  label: '$overdueTasks overdue',
                  color: AppColors.error,
                ),
              if (stats.totalSubGoals > 0)
                _buildStatBadge(
                  icon: LucideIcons.target,
                  label: '${stats.totalSubGoals} sub-goals',
                  color: AppColors.accent,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.listChecks, size: 14, color: AppColors.textTertiary),
            SizedBox(width: 8),
            Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    final displayTasks = _expansion == GoalCardExpansion.preview
        ? tasks.take(5).toList()
        : tasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tasks',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${tasks.length}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const Spacer(),
            if (tasks.length > 5 && _expansion == GoalCardExpansion.preview)
              TextButton(
                onPressed: () => setState(() => _expansion = GoalCardExpansion.expanded),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+${tasks.length - 5} more',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...displayTasks.map((task) => _buildTaskPreviewItem(task)),
      ],
    );
  }

  Widget _buildTaskPreviewItem(Task task) {
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue
              ? AppColors.error.withOpacity(0.3)
              : AppColors.border.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Icon(
            task.isCompleted
                ? LucideIcons.check
                : LucideIcons.circle,
            size: 16,
            color: task.isCompleted
                ? AppColors.secondary
                : isOverdue
                    ? AppColors.error
                    : AppColors.textTertiary,
          ),
          const SizedBox(width: 10),
          
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: task.isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.estimatedMinutes != null || isOverdue)
                  Row(
                    children: [
                      if (task.estimatedMinutes != null) ...[
                        const Icon(
                          LucideIcons.clock,
                          size: 10,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.estimatedMinutes}min',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                      if (isOverdue) ...[
                        if (task.estimatedMinutes != null) const SizedBox(width: 8),
                        const Icon(
                          Icons.warning_rounded,
                          size: 10,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Overdue',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
          
          // Quick navigate
          const Icon(
            LucideIcons.chevronRight,
            size: 14,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Points Badge
        if (widget.goal.totalPoints > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.zap,
                  size: 13,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.goal.totalPoints} pts',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: LucideIcons.plus,
            label: 'Add Task',
            onTap: () {
              // TODO: Open add task modal
            },
          ),
          Container(width: 1, height: 16, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.link,
            label: 'Associate',
            onTap: () {
              // TODO: Open association modal
            },
          ),
          Container(width: 1, height: 16, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.check,
            label: 'Complete',
            onTap: () {
              final repo = ref.read(goalsRepositoryProvider);
              repo.toggleGoal(widget.goal.id, true);
            },
          ),
          Container(width: 1, height: 16, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.pencil,
            label: 'Edit',
            onTap: () => _showGoalModal(context, widget.goal.id),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.secondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalModal(BuildContext context, String goalId) {
    showDialog(
      context: context,
      builder: (context) => GoalModal(goalId: goalId),
    );
  }
}
