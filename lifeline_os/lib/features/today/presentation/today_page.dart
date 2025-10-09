import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import 'widgets/must_wins_section.dart';
import 'widgets/canvas_timeline.dart';
import 'widgets/task_pool_panel.dart';
import 'widgets/quick_add_panel.dart';
import 'widgets/workout_log_panel.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  DateTime _selectedDate = DateTime.now();
  String _currentEnergy = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Date navigation arrows
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.chevronLeft, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                        });
                      },
                      tooltip: 'Previous day',
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat('EEEE, MMMM d').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (!_isToday(_selectedDate)) ...[
                              const SizedBox(width: 12),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedDate = DateTime.now();
                                  });
                                },
                                icon: const Icon(LucideIcons.calendar, size: 14),
                                label: const Text('Today'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isToday(_selectedDate) 
                            ? 'Your daily cockpit' 
                            : _isYesterday(_selectedDate)
                              ? 'Yesterday'
                              : _isTomorrow(_selectedDate)
                                ? 'Tomorrow'
                                : '${_getDaysFromToday(_selectedDate)} days ${_getDaysFromToday(_selectedDate) > 0 ? 'ahead' : 'ago'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(LucideIcons.chevronRight, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.add(const Duration(days: 1));
                        });
                      },
                      tooltip: 'Next day',
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const Spacer(),
                
                // Energy selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getEnergyEmoji(_currentEnergy),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      DropdownButton<String>(
                        value: _currentEnergy,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        dropdownColor: AppColors.surface,
                        items: const [
                          DropdownMenuItem(value: 'High', child: Text('High Energy')),
                          DropdownMenuItem(value: 'Med', child: Text('Med Energy')),
                          DropdownMenuItem(value: 'Low', child: Text('Low Energy')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _currentEnergy = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),

                // Date picker
                IconButton(
                  icon: const Icon(LucideIcons.calendar),
                  onPressed: () => _selectDate(context),
                  color: AppColors.textSecondary,
                  tooltip: 'Change date',
                ),
              ],
            ),
          ),

          // 2-Column Layout
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT RAIL (40%) - Timeline with internal scrolling
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: CanvasTimeline(selectedDate: _selectedDate),
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  color: AppColors.border,
                ),

                // RIGHT STACK (60%)
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Task Pool (taller for better visibility)
                        const SizedBox(
                          height: 700,
                          child: TaskPoolPanel(),
                        ),

                        const SizedBox(height: 24),

                        // Quick Add
                        const QuickAddPanel(),

                        const SizedBox(height: 24),

                        // Workout Log
                        const WorkoutLogPanel(),

                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  int _getDaysFromToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.difference(today).inDays;
  }
}
