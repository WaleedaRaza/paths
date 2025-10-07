import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class FitnessMetadataView extends StatelessWidget {
  final String metadataJson;
  final bool compact;

  const FitnessMetadataView({
    super.key,
    required this.metadataJson,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final data = jsonDecode(metadataJson) as Map<String, dynamic>;
      
      if (compact) {
        return _buildCompactView(data);
      } else {
        return _buildFullView(data);
      }
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCompactView(Map<String, dynamic> data) {
    final split = data['split'] as String?;
    final duration = data['duration'] as num?;
    final exercises = data['exercises'] as List?;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Split/Type
          if (split != null) ...[
            const Text(
              '💪',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              split,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Duration
          if (duration != null) ...[
            const Icon(
              Icons.timer,
              size: 14,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${duration}min',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Exercise count
          if (exercises != null)
            Text(
              '${exercises.length} exercises',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullView(Map<String, dynamic> data) {
    final split = data['split'] as String?;
    final focusArea = data['focusArea'] as String?;
    final duration = data['duration'] as num?;
    final exercises = data['exercises'] as List?;
    final day = data['day'] as num?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withOpacity(0.15),
                Colors.orange.withOpacity(0.05),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '💪',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (day != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Day $day',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (focusArea != null)
                      Text(
                        focusArea,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    if (split != null)
                      Text(
                        split,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (duration != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${duration}min',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Exercises section
        if (exercises != null && exercises.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Exercises',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${exercises.length} total',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...exercises.map((exercise) {
                  final ex = exercise as Map<String, dynamic>;
                  final name = ex['name'] as String?;
                  final sets = ex['sets'] as String?;
                  final notes = ex['notes'] as String?;
                  final muscleGroup = ex['muscleGroup'] as String?;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Muscle group badge
                            if (muscleGroup != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMuscleColor(muscleGroup)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  muscleGroup,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getMuscleColor(muscleGroup),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            // Sets/Reps
                            if (sets != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  sets,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Exercise name
                        if (name != null)
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        // Notes
                        if (notes != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            notes,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return Colors.red;
      case 'back':
        return Colors.blue;
      case 'shoulders':
        return Colors.orange;
      case 'arms':
        return Colors.purple;
      case 'legs':
        return Colors.green;
      case 'core':
        return Colors.amber;
      default:
        return AppColors.primary;
    }
  }
}

