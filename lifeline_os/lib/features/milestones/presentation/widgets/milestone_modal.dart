import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../providers/milestones_provider.dart';
import '../../providers/milestones_repository.dart';
import '../../providers/milestone_stats_provider.dart';
import '../../../goals/providers/goals_provider.dart';

class MilestoneModal extends ConsumerStatefulWidget {
  final String? milestoneId;

  const MilestoneModal({super.key, this.milestoneId});

  @override
  ConsumerState<MilestoneModal> createState() => _MilestoneModalState();
}

class _MilestoneModalState extends ConsumerState<MilestoneModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(milestonesRepositoryProvider);

    if (widget.milestoneId != null) {
      final milestoneAsync = ref.watch(milestoneProvider(widget.milestoneId!));
      final statsAsync = ref.watch(milestoneStatsProvider(widget.milestoneId!));
      final goalsAsync = ref.watch(goalsByMilestoneProvider(widget.milestoneId!));
      
      return milestoneAsync.when(
        data: (milestone) {
          if (_titleController.text.isEmpty) {
            _titleController.text = milestone.title;
            _descriptionController.text = milestone.description ?? '';
            _deadline = milestone.deadline;
          }
          return _buildDialog(context, repo, milestone, goalsAsync, statsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      );
    }

    return _buildDialog(context, repo, null, const AsyncValue.data([]), const AsyncValue.loading());
  }

  Widget _buildDialog(
    BuildContext context,
    MilestonesRepository repo,
    dynamic milestone,
    AsyncValue goalsAsync,
    AsyncValue statsAsync,
  ) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.milestoneId == null ? 'New Milestone' : 'Edit Milestone',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: widget.milestoneId == null,
            ),
            const SizedBox(height: 16),
            
            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Deadline
            OutlinedButton.icon(
              onPressed: () => _selectDeadline(context),
              icon: const Icon(LucideIcons.calendar),
              label: Text(
                _deadline == null
                    ? 'Set Deadline'
                    : 'Deadline: ${_deadline!.toLocal().toString().split(' ')[0]}',
              ),
            ),
            
            // Stats (if editing)
            if (widget.milestoneId != null) ...[
              const SizedBox(height: 16),
              statsAsync.when(
                data: (stats) {
                  if (stats.totalGoals == 0) {
                    return const Text(
                      'No goals attached yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progress: ${(stats.progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.zap, size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${stats.totalPoints} pts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: stats.progress,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.target, size: 14, color: AppColors.textTertiary),
                                const SizedBox(width: 4),
                                Text(
                                  '${stats.completedGoals}/${stats.totalGoals} goals',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.listChecks, size: 14, color: AppColors.textTertiary),
                                const SizedBox(width: 4),
                                Text(
                                  '${stats.completedTasks}/${stats.totalTasks} tasks',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              
              // Attached Goals
              const Text(
                'Attached Goals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              goalsAsync.when(
                data: (goals) {
                  if (goals.isEmpty) {
                    return const Text(
                      'No goals attached. Create goals and assign them to this milestone in the Goals page.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  
                  return SizedBox(
                    height: 150,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: goals.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return _buildGoalListItem(goal);
                      },
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading goals'),
              ),
            ],
            
            const Spacer(),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _saveMilestone(context, repo),
                  child: Text(widget.milestoneId == null ? 'Create' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalListItem(dynamic goal) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: goal.isCompleted ? AppColors.success.withOpacity(0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            goal.isCompleted ? LucideIcons.check : LucideIcons.target,
            size: 16,
            color: goal.isCompleted ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              goal.title,
              style: TextStyle(
                fontSize: 13,
                decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                color: goal.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
              ),
            ),
          ),
          if (goal.totalPoints > 0)
            Text(
              '${goal.totalPoints} pts',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _saveMilestone(BuildContext context, MilestonesRepository repo) async {
    if (_titleController.text.trim().isEmpty) return;

    if (widget.milestoneId == null) {
      await repo.createMilestone(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        deadline: _deadline,
      );
    } else {
      await repo.updateMilestone(
        id: widget.milestoneId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        deadline: _deadline,
      );
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
