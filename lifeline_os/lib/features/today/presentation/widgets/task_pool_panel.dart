import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../../tasks/providers/tasks_provider.dart';
import '../../../tasks/presentation/task_detail_page.dart';

class TaskPoolPanel extends ConsumerStatefulWidget {
  const TaskPoolPanel({super.key});

  @override
  ConsumerState<TaskPoolPanel> createState() => _TaskPoolPanelState();
}

class _TaskPoolPanelState extends ConsumerState<TaskPoolPanel> {
  final Set<TaskEnergy> _selectedEnergy = {};
  final Set<int> _selectedTime = {};
  final Set<String> _selectedCategories = {};

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
              ],
            ),
          ),

          // Task list
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final tasksAsync = ref.watch(activeTasksProvider);
                
                return tasksAsync.when(
                  data: (tasks) {
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
                      
                      return true;
                    }).toList();
                    
                    if (filteredTasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No tasks match your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredTasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return _buildTaskCard(context, task);
                      },
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

  Widget _buildTaskCard(BuildContext context, dynamic task) {
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
            // Priority dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priorityColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            // Task info
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
                      Text(
                        energyEmoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (task.estimatedMinutes != null) ...[
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.clock, size: 10, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          '${task.estimatedMinutes}min',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
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

  String _getEnergyEmoji(int energyIndex) {
    if (energyIndex >= TaskEnergy.values.length) return '○';
    final energy = TaskEnergy.values[energyIndex];
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

  Color _getPriorityColor(int priorityIndex) {
    if (priorityIndex >= TaskPriority.values.length) return AppColors.textTertiary;
    final priority = TaskPriority.values[priorityIndex];
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

