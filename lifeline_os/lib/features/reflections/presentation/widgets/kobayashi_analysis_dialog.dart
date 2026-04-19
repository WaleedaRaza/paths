import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';
import '../../../../core/models/kobayashi_analysis.dart';

class KobayashiAnalysisDialog extends StatelessWidget {
  final KobayashiAnalysis analysis;

  const KobayashiAnalysisDialog({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(
        children: [
          Icon(
            LucideIcons.trophy,
            color: _getScoreColor(analysis.overallScore),
          ),
          const SizedBox(width: 12),
          const Text(
            'Performance Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score
              Center(
                child: Column(
                  children: [
                    Text(
                      '${analysis.overallScore}/10',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(analysis.overallScore),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getScoreLabel(analysis.overallScore),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Strengths
              _buildSection(
                title: 'Strengths',
                icon: LucideIcons.check,
                items: analysis.strengths,
                color: Colors.green,
              ),
              const SizedBox(height: 24),

              // Weaknesses
              _buildSection(
                title: 'Areas to Improve',
                icon: LucideIcons.x,
                items: analysis.weaknesses,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),

              // Recommendations
              _buildSection(
                title: 'Recommendations',
                icon: LucideIcons.lightbulb,
                items: analysis.recommendations,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Create new scenario
          },
          icon: const Icon(LucideIcons.repeat, size: 16),
          label: const Text('New Scenario'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.blue;
    if (score >= 4) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(int score) {
    if (score >= 9) return 'Exceptional Performance';
    if (score >= 8) return 'Strong Performance';
    if (score >= 6) return 'Solid Performance';
    if (score >= 4) return 'Needs Improvement';
    return 'Significant Room for Growth';
  }
}

