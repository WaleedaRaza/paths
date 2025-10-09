import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import '../../../../core/models/task.dart';
import '../../../tasks/providers/tasks_repository.dart';

class QuickAddPanel extends ConsumerStatefulWidget {
  const QuickAddPanel({super.key});

  @override
  ConsumerState<QuickAddPanel> createState() => _QuickAddPanelState();
}

class _QuickAddPanelState extends ConsumerState<QuickAddPanel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  int? _selectedTime;
  double _timeSliderValue = 30.0; // Default 30 minutes
  TaskEnergy? _selectedEnergy;
  String? _selectedCategory;
  int? _manualPoints;

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.plus, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                const Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Task title...',
                    hintStyle: const TextStyle(color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),

                const SizedBox(height: 16),

                // Time estimate
                const Text(
                  '⏱️ Time Estimate',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTimeButton(5),
                    const SizedBox(width: 8),
                    _buildTimeButton(15),
                    const SizedBox(width: 8),
                    _buildTimeButton(25),
                    const SizedBox(width: 8),
                    _buildTimeButton(50),
                    const SizedBox(width: 8),
                    _buildTimeButton(90),
                  ],
                ),

                const SizedBox(height: 12),

                // Time slider
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Or slide:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${_timeSliderValue.round()} min',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.border,
                          thumbColor: AppColors.primary,
                          overlayColor: AppColors.primary.withOpacity(0.2),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                        ),
                        child: Slider(
                          value: _timeSliderValue,
                          min: 5,
                          max: 180,
                          divisions: 35, // 5-minute increments
                          onChanged: (value) {
                            setState(() {
                              _timeSliderValue = value;
                              _selectedTime = value.round();
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('5m', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                          Text('180m', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Energy level
                const Text(
                  '⚡ Energy Level',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildEnergyButton(TaskEnergy.high, '⚡'),
                    const SizedBox(width: 8),
                    _buildEnergyButton(TaskEnergy.medium, '💪'),
                    const SizedBox(width: 8),
                    _buildEnergyButton(TaskEnergy.low, '🌙'),
                  ],
                ),

                const SizedBox(height: 16),

                // Category dropdown
                const Text(
                  '🏷️ Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text(
                      'Select category...',
                      style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                    ),
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'School', child: Text('School')),
                      DropdownMenuItem(value: 'Projects', child: Text('Projects')),
                      DropdownMenuItem(value: 'Health', child: Text('Health')),
                      DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                      DropdownMenuItem(value: 'DSA', child: Text('DSA')),
                      DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Manual points input (optional)
                const Text(
                  '⚡ Points (optional)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Auto-calculated if left blank',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.accent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(LucideIcons.zap, size: 18, color: AppColors.accent),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _manualPoints = int.tryParse(value);
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI Auto-fill coming soon!')),
                          );
                        },
                        icon: const Icon(LucideIcons.sparkles, size: 16),
                        label: const Text('Auto-fill'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accent,
                          side: const BorderSide(color: AppColors.accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_titleController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a task title')),
                            );
                            return;
                          }
                          
                          final repo = ref.read(tasksRepositoryProvider);
                          await repo.createTask(
                            title: _titleController.text.trim(),
                            priority: TaskPriority.medium,
                            energy: _selectedEnergy ?? TaskEnergy.medium,
                            estimatedMinutes: _selectedTime,
                            basePoints: _manualPoints ?? 10,
                          );
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _manualPoints != null
                                      ? '✅ Task added with $_manualPoints points!'
                                      : '✅ Task added to pool!',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          
                          _titleController.clear();
                          _pointsController.clear();
                          setState(() {
                            _selectedTime = null;
                            _timeSliderValue = 30.0;
                            _selectedEnergy = null;
                            _selectedCategory = null;
                            _manualPoints = null;
                          });
                        },
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text('Add Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(int minutes) {
    final isSelected = _selectedTime == minutes;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTime = minutes;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            '${minutes}m',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyButton(TaskEnergy energy, String emoji) {
    final isSelected = _selectedEnergy == energy;
    final label = energy == TaskEnergy.high ? 'High' : energy == TaskEnergy.medium ? 'Med' : 'Low';
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedEnergy = energy;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

