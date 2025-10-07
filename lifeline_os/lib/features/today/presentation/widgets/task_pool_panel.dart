import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class TaskPoolPanel extends StatefulWidget {
  const TaskPoolPanel({super.key});

  @override
  State<TaskPoolPanel> createState() => _TaskPoolPanelState();
}

class _TaskPoolPanelState extends State<TaskPoolPanel> {
  final Set<String> _selectedEnergy = {};
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '12 tasks',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
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
                    _buildFilterChip('High', '🔋', _selectedEnergy),
                    const SizedBox(width: 6),
                    _buildFilterChip('Med', '⚡', _selectedEnergy),
                    const SizedBox(width: 6),
                    _buildFilterChip('Low', '🔌', _selectedEnergy),
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
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildTaskCard(
                  title: 'D426 Practice Exam',
                  category: 'School',
                  categoryColor: AppColors.primary,
                  estimateMinutes: 25,
                  energy: 'High',
                  priority: 'High',
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  title: 'Petform Bug Fix - Auth Flow',
                  category: 'Projects',
                  categoryColor: AppColors.accent,
                  estimateMinutes: 30,
                  energy: 'Med',
                  priority: 'High',
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  title: 'Review Budget Spreadsheet',
                  category: 'Finance',
                  categoryColor: const Color(0xFF10B981),
                  estimateMinutes: 15,
                  energy: 'Low',
                  priority: 'Med',
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  title: 'DSA: Binary Tree Problems',
                  category: 'DSA',
                  categoryColor: AppColors.secondary,
                  estimateMinutes: 50,
                  energy: 'High',
                  priority: 'Med',
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  title: 'Email Professor about Quiz',
                  category: 'School',
                  categoryColor: AppColors.primary,
                  estimateMinutes: 5,
                  energy: 'Low',
                  priority: 'Low',
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  title: 'Research React Query Alternatives',
                  category: 'Projects',
                  categoryColor: AppColors.accent,
                  estimateMinutes: 25,
                  energy: 'Med',
                  priority: 'Low',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String emoji, Set<String> selectedSet) {
    final isSelected = selectedSet.contains(label);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSet.remove(label);
          } else {
            selectedSet.add(label);
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

  Widget _buildTaskCard({
    required String title,
    required String category,
    required Color categoryColor,
    required int estimateMinutes,
    required String energy,
    required String priority,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Drag handle
          Icon(
            LucideIcons.gripVertical,
            size: 16,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 12),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${estimateMinutes}min',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getEnergyEmoji(energy),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(priority),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick action
          IconButton(
            icon: const Icon(LucideIcons.play, size: 16),
            color: AppColors.primary,
            onPressed: () {
              // Mock action
            },
            tooltip: 'Start Now',
          ),
        ],
      ),
    );
  }

  String _getEnergyEmoji(String energy) {
    switch (energy) {
      case 'High':
        return '🔋';
      case 'Med':
        return '⚡';
      case 'Low':
        return '🔌';
      default:
        return '⚡';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.error;
      case 'Med':
        return AppColors.warning;
      case 'Low':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }
}

