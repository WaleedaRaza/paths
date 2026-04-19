import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../../../core/models/subtask.dart';
import '../../../../core/database/tables.dart';
import '../../../../shared/widgets/domain_metadata/domain_metadata_widget.dart';
import '../../../goals/providers/goals_provider.dart';
import '../../providers/tasks_repository.dart';
import '../../providers/tasks_provider.dart';
import '../widgets/task_modal.dart';

enum TaskCardExpansion { collapsed, preview, expanded }
enum TaskStatus { todo, doing, done }

class TaskCard extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  TaskCardExpansion _expansion = TaskCardExpansion.collapsed;

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(tasksRepositoryProvider);
    final subtasksAsync = ref.watch(subtasksProvider(widget.task.id));
    
    // Get parent goal if exists
    final goalAsync = widget.task.goalId != null
        ? ref.watch(goalProvider(widget.task.goalId!))
        : null;

    return GestureDetector(
      onTap: widget.onTap ??
          () {
            if (_expansion == TaskCardExpansion.collapsed) {
              setState(() => _expansion = TaskCardExpansion.preview);
            } else if (_expansion == TaskCardExpansion.preview) {
              setState(() => _expansion = TaskCardExpansion.collapsed);
            }
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: widget.task.isCompleted
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expansion != TaskCardExpansion.collapsed
                ? AppColors.primary.withOpacity(0.5)
                : widget.task.isCompleted
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.border,
            width: _expansion != TaskCardExpansion.collapsed ? 2 : 1.5,
          ),
          boxShadow: _expansion != TaskCardExpansion.collapsed
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Multi-Badge Header: Domain | Priority | Time | Overdue
            _buildMultiBadgeHeader(),
            
            const SizedBox(height: 12),
            
            // Parent Goal Badge
            if (goalAsync != null)
              goalAsync.when(
                data: (goal) => _buildParentGoalBadge(goal),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            
            const SizedBox(height: 10),
            
            // Title with Checkbox
            Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => repo.toggleTask(widget.task.id, !widget.task.isCompleted),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.task.isCompleted
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.task.isCompleted
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        width: 2.5,
                      ),
                    ),
                    child: widget.task.isCompleted
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
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: widget.task.isCompleted
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      height: 1.3,
                    ),
                  ),
                ),
                
                // Expand Icon
                Icon(
                  _expansion == TaskCardExpansion.collapsed
                      ? LucideIcons.chevronDown
                      : LucideIcons.chevronUp,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            
            // Description
            if (widget.task.description != null && widget.task.description!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                widget.task.description!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: _expansion == TaskCardExpansion.collapsed ? 2 : null,
                overflow: _expansion == TaskCardExpansion.collapsed
                    ? TextOverflow.ellipsis
                    : TextOverflow.visible,
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Subtask Rollup
            subtasksAsync.when(
              data: (subtasks) => _buildSubtaskRollup(subtasks),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            // Domain Metadata Preview
            if (widget.task.metadata != null && widget.task.metadata!.isNotEmpty) ...[
              const SizedBox(height: 12),
              DomainMetadataWidget(
                domain: Domain.school, // TODO: get from parent goal's milestone
                metadataJson: widget.task.metadata,
                compact: true,
              ),
            ],
            
            // Inline Subtask List
            if (_expansion != TaskCardExpansion.collapsed) ...[
              const SizedBox(height: 14),
              subtasksAsync.when(
                data: (subtasks) => _buildSubtaskList(subtasks),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading subtasks'),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Status Pills + Points Preview
            _buildStatusPills(),
            
            // Quick Action Bar
            if (_expansion != TaskCardExpansion.collapsed) ...[
              const SizedBox(height: 12),
              _buildQuickActions(),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.05, end: 0, duration: 300.ms);
  }

  Widget _buildMultiBadgeHeader() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        // Domain Badge (mock for now - would come from parent goal's milestone)
        _buildHeaderBadge(
          icon: LucideIcons.graduationCap,
          label: 'SCHOOL',
          color: const Color(0xFF6366F1),
        ),
        
        // Priority
        if (widget.task.priority != TaskPriority.none)
          _buildHeaderBadge(
            icon: _getPriorityIcon(widget.task.priority),
            label: _getPriorityLabel(widget.task.priority),
            color: _getPriorityColor(widget.task.priority),
          ),
        
        // Time Estimate
        if (widget.task.estimatedMinutes != null)
          _buildHeaderBadge(
            icon: LucideIcons.clock,
            label: '${widget.task.estimatedMinutes}min',
            color: AppColors.accent,
          ),
        
        // Overdue
        if (widget.task.dueDate != null && _isOverdue(widget.task.dueDate!))
          _buildHeaderBadge(
            icon: Icons.warning_rounded,
            label: '${_getDaysOverdue()}d overdue',
            color: AppColors.error,
          ),
      ],
    );
  }

  Widget _buildHeaderBadge({
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
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentGoalBadge(goal) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to goal detail
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.target,
              size: 12,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Part of: ${goal.title}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              LucideIcons.externalLink,
              size: 10,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtaskRollup(List<Subtask> subtasks) {
    if (subtasks.isEmpty) return const SizedBox.shrink();

    final completed = subtasks.where((s) => s.isCompleted).length;
    final remaining = subtasks.length - completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.listChecks,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '${subtasks.length} subtasks',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '• $completed done',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (remaining > 0) ...[
            const SizedBox(width: 6),
            Text(
              '• $remaining remaining',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubtaskList(List<Subtask> subtasks) {
    if (subtasks.isEmpty) {
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
              'No subtasks yet',
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

    final displaySubtasks = _expansion == TaskCardExpansion.preview
        ? subtasks.take(5).toList()
        : subtasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Subtasks',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (subtasks.length > 5 && _expansion == TaskCardExpansion.preview)
              TextButton(
                onPressed: () => setState(() => _expansion = TaskCardExpansion.expanded),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+${subtasks.length - 5} more',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...displaySubtasks.map((subtask) => _buildSubtaskItem(subtask)),
      ],
    );
  }

  Widget _buildSubtaskItem(Subtask subtask) {
    final repo = ref.read(tasksRepositoryProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => repo.toggleSubtask(subtask.id, !subtask.isCompleted),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: subtask.isCompleted
                    ? AppColors.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: subtask.isCompleted
                      ? AppColors.secondary
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: subtask.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 12,
                      color: Colors.white,
                    ).animate().scale(duration: 150.ms)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          
          // Subtask title
          Expanded(
            child: Text(
              subtask.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subtask.isCompleted
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
                decoration: subtask.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Points
          if (subtask.points > 0) ...[
            const SizedBox(width: 8),
            Text(
              '+${subtask.points}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPills() {
    return Row(
      children: [
        // Status Pills
        _buildStatusPill('To Do', TaskStatus.todo),
        const SizedBox(width: 8),
        _buildStatusPill('Doing', TaskStatus.doing),
        const SizedBox(width: 8),
        _buildStatusPill('Done', TaskStatus.done),
        
        const Spacer(),
        
        // Points Preview
        if (widget.task.totalPoints > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.zap,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${widget.task.totalPoints} pts',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusPill(String label, TaskStatus status) {
    final isActive = (status == TaskStatus.done && widget.task.isCompleted) ||
        (status == TaskStatus.todo && !widget.task.isCompleted); // Simplified for demo
    
    return GestureDetector(
      onTap: () {
        // TODO: Update task status
        final repo = ref.read(tasksRepositoryProvider);
        if (status == TaskStatus.done) {
          repo.toggleTask(widget.task.id, true);
        } else if (status == TaskStatus.todo) {
          repo.toggleTask(widget.task.id, false);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : AppColors.border.withOpacity(0.5),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: LucideIcons.calendar,
            label: 'Schedule',
            onTap: () {
              // TODO: Open schedule picker
            },
          ),
          Container(width: 1, height: 16, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.plus,
            label: 'Add Subtask',
            onTap: () {
              // TODO: Open subtask modal
            },
          ),
          Container(width: 1, height: 16, color: AppColors.border),
          _buildActionButton(
            icon: LucideIcons.pencil,
            label: 'Edit',
            onTap: () => _showTaskModal(context, widget.task.id),
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
            Icon(icon, size: 12, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return LucideIcons.arrowUp;
      case TaskPriority.medium:
        return LucideIcons.minus;
      case TaskPriority.low:
        return LucideIcons.arrowDown;
      case TaskPriority.none:
        return LucideIcons.circle;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MED';
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.none:
        return '';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.secondary;
      case TaskPriority.none:
        return AppColors.textTertiary;
    }
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now()) && !widget.task.isCompleted;
  }

  int _getDaysOverdue() {
    if (widget.task.dueDate == null) return 0;
    return DateTime.now().difference(widget.task.dueDate!).inDays;
  }

  void _showTaskModal(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => TaskModal(taskId: taskId),
    );
  }
}
