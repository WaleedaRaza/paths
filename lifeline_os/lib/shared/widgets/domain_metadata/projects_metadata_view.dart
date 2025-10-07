import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../app/theme.dart';

class ProjectsMetadataView extends StatelessWidget {
  final String metadataJson;
  final bool compact;

  const ProjectsMetadataView({
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
    final projectType = data['projectType'] as String?;
    final techStack = data['techStack'] as List?;
    final phases = data['phases'] as List?;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Project type
          if (projectType != null) ...[
            Icon(
              _getProjectIcon(projectType),
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              projectType,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Tech stack preview (first 2)
          if (techStack != null && techStack.isNotEmpty) ...[
            ...techStack.take(2).map((tech) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tech.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                )),
            if (techStack.length > 2)
              Text(
                '+${techStack.length - 2}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
          ],

          const Spacer(),

          // Phases count
          if (phases != null)
            Text(
              '${phases.length} phases',
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
    final projectType = data['projectType'] as String?;
    final description = data['description'] as String?;
    final techStack = data['techStack'] as List?;
    final repoUrl = data['repoUrl'] as String?;
    final phases = data['phases'] as List?;
    final timeline = data['timeline'] as String?;
    final metrics = data['metrics'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (projectType != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getProjectIcon(projectType),
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (projectType != null)
                          Text(
                            projectType,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        if (timeline != null)
                          Text(
                            timeline,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (repoUrl != null)
                    IconButton(
                      onPressed: () {
                        // TODO: Open URL
                      },
                      icon: const Icon(LucideIcons.github),
                      color: AppColors.textSecondary,
                      tooltip: 'View Repository',
                    ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tech stack
        if (techStack != null && techStack.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tech Stack',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: techStack.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        tech.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Phases
        if (phases != null && phases.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Project Phases',
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
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${phases.length} phases',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...phases.asMap().entries.map((entry) {
                  final index = entry.key;
                  final phase = entry.value as Map<String, dynamic>;
                  final name = phase['name'] as String?;
                  final duration = phase['duration'] as String?;
                  final isComplete = index == 0; // Mock: first phase complete

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppColors.secondary.withOpacity(0.1)
                          : AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isComplete
                            ? AppColors.secondary.withOpacity(0.3)
                            : AppColors.border.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Phase number
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isComplete
                                ? AppColors.secondary
                                : AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isComplete
                                ? const Icon(
                                    LucideIcons.check,
                                    size: 16,
                                    color: AppColors.surface,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Phase info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (name != null)
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isComplete
                                        ? AppColors.secondary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              if (duration != null)
                                Text(
                                  duration,
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
                  );
                }).toList(),
              ],
            ),
          ),
        ],

        // Success metrics
        if (metrics != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.target,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Success Metrics',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...metrics.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '• ${e.key}: ${e.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  IconData _getProjectIcon(String type) {
    switch (type.toLowerCase()) {
      case 'web app':
        return LucideIcons.globe;
      case 'mobile app':
        return LucideIcons.smartphone;
      case 'desktop app':
        return LucideIcons.monitor;
      case 'api':
        return LucideIcons.server;
      case 'cli tool':
        return LucideIcons.terminal;
      default:
        return LucideIcons.code;
    }
  }
}

