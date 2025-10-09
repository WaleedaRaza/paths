import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../../../core/database/tables.dart';
import '../../../tasks/providers/tasks_provider.dart';
import '../../../tasks/presentation/task_detail_page.dart';
import '../../../goals/providers/goals_provider.dart';
import '../../../milestones/providers/milestones_provider.dart';
import '../../providers/schedule_provider.dart';

class TaskPoolPanel extends ConsumerStatefulWidget {
  final Function(Task task, TimeOfDay time)? onTaskScheduled;
  
  const TaskPoolPanel({super.key, this.onTaskScheduled});

  @override
  ConsumerState<TaskPoolPanel> createState() => _TaskPoolPanelState();
}

class _TaskPoolPanelState extends ConsumerState<TaskPoolPanel> {
  final Set<TaskEnergy> _selectedEnergy = {};
  final Set<int> _selectedTime = {};
  final Set<TaskPriority> _selectedPriority = {};
  String? _selectedDomain;
  String? _selectedMilestoneId;
  String? _selectedGoalId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.listTodo, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Task Pool',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    final tasksAsync = ref.watch(activeTasksProvider);
                    return tasksAsync.when(
                      data: (tasks) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${tasks.length} tasks',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Energy filters
                Row(
                  children: [
                    const Icon(LucideIcons.zap, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Energy:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildEnergyFilterChip(TaskEnergy.high, '🔋'),
                    const SizedBox(width: 6),
                    _buildEnergyFilterChip(TaskEnergy.medium, '⚡'),
                    const SizedBox(width: 6),
                    _buildEnergyFilterChip(TaskEnergy.low, '🔌'),
                  ],
                ),
                const SizedBox(height: 8),

                // Time filters
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTimeChip(5),
                    const SizedBox(width: 6),
                    _buildTimeChip(15),
                    const SizedBox(width: 6),
                    _buildTimeChip(25),
                    const SizedBox(width: 6),
                    _buildTimeChip(50),
                    const SizedBox(width: 6),
                    _buildTimeChip(90),
                  ],
                ),
                const SizedBox(height: 8),

                // Priority filters
                Row(
                  children: [
                    const Icon(LucideIcons.flag, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Priority:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityFilterChip(TaskPriority.high, 'High', Colors.red.shade400),
                    const SizedBox(width: 6),
                    _buildPriorityFilterChip(TaskPriority.medium, 'Med', Colors.orange.shade400),
                    const SizedBox(width: 6),
                    _buildPriorityFilterChip(TaskPriority.low, 'Low', Colors.yellow.shade600),
                  ],
                ),
                const SizedBox(height: 8),

                // Domain dropdown filter
                Row(
                  children: [
                    const Icon(LucideIcons.layers, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Domain:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButton<String?>(
                          value: _selectedDomain,
                          hint: const Text('All Domains', style: TextStyle(fontSize: 12)),
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          isDense: true,
                          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                          dropdownColor: AppColors.surface,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('All Domains')),
                            DropdownMenuItem(value: 'school', child: Text('School')),
                            DropdownMenuItem(value: 'projects', child: Text('Projects')),
                            DropdownMenuItem(value: 'dsa', child: Text('LeetCode')),
                            DropdownMenuItem(value: 'career', child: Text('Career')),
                            DropdownMenuItem(value: 'finance', child: Text('Finance')),
                            DropdownMenuItem(value: 'health', child: Text('Health')),
                            DropdownMenuItem(value: 'gre', child: Text('GRE')),
                            DropdownMenuItem(value: 'personal', child: Text('Personal')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDomain = value;
                              _selectedMilestoneId = null; // Clear child filters
                              _selectedGoalId = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Milestone dropdown filter
                Row(
                  children: [
                    const Icon(LucideIcons.target, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Milestone:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final milestonesAsync = ref.watch(allMilestonesProvider);
                          return milestonesAsync.when(
                            data: (milestones) {
                              final filteredMilestones = _selectedDomain != null
                                  ? milestones.where((m) => m.domain.toString().split('.').last == _selectedDomain).toList()
                                  : milestones;
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButton<String?>(
                                  value: _selectedMilestoneId,
                                  hint: const Text('All Milestones', style: TextStyle(fontSize: 12)),
                                  isExpanded: true,
                                  underline: const SizedBox.shrink(),
                                  isDense: true,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  dropdownColor: AppColors.surface,
                                  items: [
                                    const DropdownMenuItem(value: null, child: Text('All Milestones')),
                                    ...filteredMilestones.map((m) => DropdownMenuItem(
                                      value: m.id,
                                      child: Text(m.title, overflow: TextOverflow.ellipsis),
                                    )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMilestoneId = value;
                                      _selectedGoalId = null; // Clear child filter
                                    });
                                  },
                                ),
                              );
                            },
                            loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Goal dropdown filter
                Row(
                  children: [
                    const Icon(LucideIcons.circle, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Goal:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final goalsAsync = ref.watch(allGoalsProvider);
                          return goalsAsync.when(
                            data: (goals) {
                              final filteredGoals = _selectedMilestoneId != null
                                  ? goals.where((g) => g.milestoneId == _selectedMilestoneId).toList()
                                  : goals;
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButton<String?>(
                                  value: _selectedGoalId,
                                  hint: const Text('All Goals', style: TextStyle(fontSize: 12)),
                                  isExpanded: true,
                                  underline: const SizedBox.shrink(),
                                  isDense: true,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  dropdownColor: AppColors.surface,
                                  items: [
                                    const DropdownMenuItem(value: null, child: Text('All Goals')),
                                    ...filteredGoals.map((g) => DropdownMenuItem(
                                      value: g.id,
                                      child: Text(g.title, overflow: TextOverflow.ellipsis),
                                    )),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedGoalId = value);
                                  },
                                ),
                              );
                            },
                            loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                // Clear filters button
                if (_selectedEnergy.isNotEmpty || _selectedTime.isNotEmpty || _selectedPriority.isNotEmpty || _selectedDomain != null || _selectedMilestoneId != null || _selectedGoalId != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedEnergy.clear();
                        _selectedTime.clear();
                        _selectedPriority.clear();
                        _selectedDomain = null;
                        _selectedMilestoneId = null;
                        _selectedGoalId = null;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 14),
                    label: const Text('Clear All Filters'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Task list
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final tasksAsync = ref.watch(activeTasksProvider);
                final goalsAsync = ref.watch(allGoalsProvider);
                final milestonesAsync = ref.watch(allMilestonesProvider);
                
                return tasksAsync.when(
                  data: (tasks) {
                    return goalsAsync.when(
                      data: (goals) {
                        return milestonesAsync.when(
                          data: (milestones) {
                            // Create lookup maps for efficient filtering
                            final goalMap = {for (var g in goals) g.id: g};
                            final milestoneMap = {for (var m in milestones) m.id: m};
                            
                            // Apply filters
                            var filteredTasks = tasks.where((task) {
                              // Energy filter
                              if (_selectedEnergy.isNotEmpty && !_selectedEnergy.contains(task.energy)) {
                                return false;
                              }
                              
                              // Time filter
                              if (_selectedTime.isNotEmpty && task.estimatedMinutes != null) {
                                final matchesTime = _selectedTime.any((time) {
                                  return task.estimatedMinutes! <= time + 10;
                                });
                                if (!matchesTime) return false;
                              }
                              
                              // Priority filter
                              if (_selectedPriority.isNotEmpty && !_selectedPriority.contains(task.priority)) {
                                return false;
                              }
                              
                              // Goal filter (direct match)
                              if (_selectedGoalId != null && task.goalId != _selectedGoalId) {
                                return false;
                              }
                              
                              // Milestone and Domain filters (through goal hierarchy)
                              if (task.goalId != null) {
                                final goal = goalMap[task.goalId];
                                if (goal != null) {
                                  // Milestone filter
                                  if (_selectedMilestoneId != null && goal.milestoneId != _selectedMilestoneId) {
                                    return false;
                                  }
                                  
                                  // Domain filter
                                  if (_selectedDomain != null) {
                                    final milestone = milestoneMap[goal.milestoneId];
                                    if (milestone == null) return false;
                                    final domainString = milestone.domain.toString().split('.').last;
                                    if (domainString != _selectedDomain) return false;
                                  }
                                }
                              } else {
                                // Task without goal - filter out if any hierarchy filter is active
                                if (_selectedDomain != null || _selectedMilestoneId != null || _selectedGoalId != null) {
                                  return false;
                                }
                              }
                              
                              return true;
                            }).toList();
                    
                            final scheduleRepo = ref.read(scheduleRepositoryProvider);
                            
                            if (filteredTasks.isEmpty) {
                              return DragTarget<Map<String, dynamic>>(
                                onWillAccept: (data) => data?['type'] == 'schedule_item',
                                onAccept: (data) async {
                                  final item = data['item'];
                                  await scheduleRepo.deleteScheduleItem(item.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Task unscheduled'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, candidateData, rejectedData) {
                                  final isHovered = candidateData.isNotEmpty;
                                  return Container(
                                    margin: const EdgeInsets.all(12),
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: isHovered ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isHovered ? AppColors.primary : AppColors.border,
                                        width: 2,
                                        style: isHovered ? BorderStyle.solid : BorderStyle.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isHovered ? LucideIcons.upload : LucideIcons.inbox,
                                            size: 48,
                                            color: isHovered ? AppColors.primary : AppColors.textTertiary,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            isHovered ? 'Drop to unschedule' : 'No tasks match your filters',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isHovered ? FontWeight.w600 : FontWeight.normal,
                                              color: isHovered ? AppColors.primary : AppColors.textTertiary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            
                            return DragTarget<Map<String, dynamic>>(
                              onWillAccept: (data) => data?['type'] == 'schedule_item',
                              onAccept: (data) async {
                                final item = data['item'];
                                await scheduleRepo.deleteScheduleItem(item.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Task unscheduled'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isHovered = candidateData.isNotEmpty;
                                return Stack(
                                  children: [
                                    ListView.separated(
                                      padding: const EdgeInsets.all(12),
                                      itemCount: filteredTasks.length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                                      itemBuilder: (context, index) {
                                        final task = filteredTasks[index];
                                        return _buildDraggableTaskCard(context, task);
                                      },
                                    ),
                                    if (isHovered)
                                      Positioned.fill(
                                        child: Container(
                                          margin: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: AppColors.primary,
                                              width: 3,
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(LucideIcons.upload, color: Colors.white, size: 20),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Drop to unschedule',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (_, __) => const Center(child: Text('Error loading milestones')),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      error: (_, __) => const Center(child: Text('Error loading goals')),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error loading tasks')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyFilterChip(TaskEnergy energy, String emoji) {
    final isSelected = _selectedEnergy.contains(energy);
    final label = energy == TaskEnergy.high ? 'High' : energy == TaskEnergy.medium ? 'Med' : 'Low';
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedEnergy.remove(energy);
          } else {
            _selectedEnergy.add(energy);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityFilterChip(TaskPriority priority, String label, Color color) {
    final isSelected = _selectedPriority.contains(priority);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedPriority.remove(priority);
          } else {
            _selectedPriority.add(priority);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(int minutes) {
    final isSelected = _selectedTime.contains(minutes);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTime.remove(minutes);
          } else {
            _selectedTime.add(minutes);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          '${minutes}m',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableTaskCard(BuildContext context, Task task) {
    return _DraggableTaskCardWithIndicator(
      task: task,
      buildTaskCard: (task) => _buildTaskCard(context, task),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final energyEmoji = _getEnergyEmoji(task.energy);
    final priorityColor = _getPriorityColor(task.priority);
    
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priorityColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(energyEmoji, style: const TextStyle(fontSize: 12)),
                      if (task.estimatedMinutes != null) ...[
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.clock, size: 10, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          '${task.estimatedMinutes}min',
                          style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                        ),
                      ],
                      if (task.totalPoints > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '${task.totalPoints}pts',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEnergyEmoji(TaskEnergy energy) {
    switch (energy) {
      case TaskEnergy.high:
        return '⚡';
      case TaskEnergy.medium:
        return '💪';
      case TaskEnergy.low:
        return '🌙';
      case TaskEnergy.none:
        return '○';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade400;
      case TaskPriority.medium:
        return Colors.orange.shade400;
      case TaskPriority.low:
        return Colors.yellow.shade600;
      case TaskPriority.none:
        return AppColors.textTertiary;
    }
  }
}

class _DraggableTaskCardWithIndicator extends StatefulWidget {
  final Task task;
  final Widget Function(Task) buildTaskCard;

  const _DraggableTaskCardWithIndicator({
    required this.task,
    required this.buildTaskCard,
  });

  @override
  State<_DraggableTaskCardWithIndicator> createState() => _DraggableTaskCardWithIndicatorState();
}

class _DraggableTaskCardWithIndicatorState extends State<_DraggableTaskCardWithIndicator> with SingleTickerProviderStateMixin {
  bool _isLongPressing = false;
  bool _isDragging = false;
  AnimationController? _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _progressController?.dispose();
    super.dispose();
  }

  void _startLongPress() {
    setState(() => _isLongPressing = true);
    _progressController?.forward();
  }

  void _cancelLongPress() {
    if (!_isDragging) {
      setState(() => _isLongPressing = false);
      _progressController?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startLongPress(),
      onPointerUp: (_) => _cancelLongPress(),
      onPointerCancel: (_) => _cancelLongPress(),
      child: LongPressDraggable<Task>(
        data: widget.task,
        delay: const Duration(milliseconds: 500),
        onDragStarted: () {
          setState(() => _isDragging = true);
        },
        onDragEnd: (details) {
          setState(() {
            _isDragging = false;
            _isLongPressing = false;
          });
          _progressController?.reset();
        },
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            _isDragging = false;
            _isLongPressing = false;
          });
          _progressController?.reset();
        },
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Opacity(
            opacity: 0.9,
            child: SizedBox(
              width: 280,
              child: widget.buildTaskCard(widget.task),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: widget.buildTaskCard(widget.task),
        ),
        child: Stack(
          children: [
            widget.buildTaskCard(widget.task),
            if (_isLongPressing && !_isDragging)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _progressController!,
                        builder: (context, child) {
                          return SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: _progressController!.value,
                              strokeWidth: 4,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

