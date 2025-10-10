import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../models/workout_template.dart';
import '../../providers/tasks_repository.dart';

/// Dialog for creating gym workout tasks with weight tracking
class WorkoutDialog extends ConsumerStatefulWidget {
  final String? goalId;
  
  const WorkoutDialog({super.key, this.goalId});
  
  @override
  ConsumerState<WorkoutDialog> createState() => _WorkoutDialogState();
}

class _WorkoutDialogState extends ConsumerState<WorkoutDialog> {
  WorkoutTemplate? _selectedTemplate;
  final Map<String, List<TextEditingController>> _weightControllers = {};
  
  @override
  void dispose() {
    // Dispose all controllers
    for (final controllers in _weightControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }
  
  void _selectTemplate(WorkoutTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _weightControllers.clear();
      
      // Initialize controllers for each exercise
      for (final exercise in template.exercises) {
        final setCount = int.tryParse(exercise.sets) ?? 3;
        _weightControllers[exercise.name] = List.generate(
          setCount,
          (_) => TextEditingController(),
        );
      }
    });
  }
  
  Future<void> _createWorkoutTask() async {
    if (_selectedTemplate == null) return;
    
    // Build workout description with weights
    final buffer = StringBuffer();
    buffer.writeln('${_selectedTemplate!.description}\n');
    
    int exerciseNum = 1;
    for (final exercise in _selectedTemplate!.exercises) {
      final controllers = _weightControllers[exercise.name] ?? [];
      final hasWeights = controllers.any((c) => c.text.isNotEmpty);
      
      buffer.writeln('$exerciseNum. ${exercise.name} – ${exercise.sets}×${exercise.reps}');
      
      if (hasWeights) {
        final weights = controllers
            .asMap()
            .entries
            .where((e) => e.value.text.isNotEmpty)
            .map((e) => '   Set ${e.key + 1}: ${e.value.text}')
            .join('\n');
        if (weights.isNotEmpty) {
          buffer.writeln(weights);
        }
      }
      
      if (exercise.notes != null && exercise.notes!.isNotEmpty) {
        buffer.writeln('   💡 ${exercise.notes}');
      }
      
      buffer.writeln();
      exerciseNum++;
    }
    
    // Create task
    final repo = ref.read(tasksRepositoryProvider);
    await repo.createTask(
      title: '${_selectedTemplate!.emoji} ${_selectedTemplate!.name}',
      description: buffer.toString(),
      goalId: widget.goalId,
    );
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout task created: ${_selectedTemplate!.name}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.dumbbell,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Create Workout Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _selectedTemplate == null
                  ? _buildTemplateSelection()
                  : _buildWeightInput(),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  if (_selectedTemplate != null)
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _selectedTemplate = null;
                        _weightControllers.clear();
                      }),
                      icon: const Icon(LucideIcons.arrowLeft, size: 16),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _selectedTemplate != null ? _createWorkoutTask : null,
                    icon: const Icon(LucideIcons.check, size: 16),
                    label: const Text('Create Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      disabledBackgroundColor: AppColors.border,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTemplateSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Workout Day',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your workout split for today',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          ...WorkoutTemplates.all.map((template) => _buildTemplateCard(template)),
        ],
      ),
    );
  }
  
  Widget _buildTemplateCard(WorkoutTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _selectTemplate(template),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    template.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          template.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: template.exercises.map((ex) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ex.isCompound 
                          ? AppColors.accent.withOpacity(0.1) 
                          : AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: ex.isCompound 
                            ? AppColors.accent.withOpacity(0.3) 
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      ex.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: ex.isCompound ? FontWeight.w700 : FontWeight.w500,
                        color: ex.isCompound ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildWeightInput() {
    if (_selectedTemplate == null) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _selectedTemplate!.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTemplate!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _selectedTemplate!.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Log Your Weights (Optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can add weights now or fill them in later after your workout',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ..._selectedTemplate!.exercises.map((exercise) => 
            _buildExerciseWeightInput(exercise)
          ),
        ],
      ),
    );
  }
  
  Widget _buildExerciseWeightInput(WorkoutExercise exercise) {
    final controllers = _weightControllers[exercise.name] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: exercise.isCompound 
              ? AppColors.accent.withOpacity(0.3) 
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (exercise.isCompound)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'COMPOUND',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              if (exercise.isCompound) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${exercise.sets}×${exercise.reps}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          
          if (exercise.notes != null) ...[
            const SizedBox(height: 6),
            Text(
              '💡 ${exercise.notes}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Weight input fields
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(controllers.length, (index) {
              return SizedBox(
                width: 90,
                child: TextField(
                  controller: controllers[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Set ${index + 1}',
                    labelStyle: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    hintText: '185 lbs',
                    hintStyle: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    isDense: true,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

