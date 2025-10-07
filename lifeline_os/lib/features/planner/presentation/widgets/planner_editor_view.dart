import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class PlannerEditorView extends StatefulWidget {
  final VoidCallback onShowFeatureCards;

  const PlannerEditorView({
    super.key,
    required this.onShowFeatureCards,
  });

  @override
  State<PlannerEditorView> createState() => _PlannerEditorViewState();
}

class _PlannerEditorViewState extends State<PlannerEditorView> {
  final Map<String, bool> _expandedSections = {
    'project_info': true,
    'research': true,
    'architecture': true,
    'features': true,
    'division': false,
  };

  final Map<String, bool> _includedSections = {
    'project_info': true,
    'research': true,
    'architecture': true,
    'features': true,
    'division': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last.fm 2025 AI/ML',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Generated Oct 7, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export coming soon!')),
                  );
                },
                icon: const Icon(LucideIcons.download, size: 16),
                label: const Text('Export'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New plan coming soon!')),
                  );
                },
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // 2-Column Layout
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT PANEL (60%) - Sections Editor
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        id: 'project_info',
                        title: '📋 Project Info',
                        fields: [
                          _buildField('Name', 'Last.fm 2025 AI/ML'),
                          _buildField('One-Liner', 'Privacy-first music analytics with AI-powered discovery'),
                          _buildField('Target Users', '• Music enthusiasts who want deeper analytics\n• Audiophiles who track listening habits\n• Privacy-conscious users avoiding big tech tracking'),
                          _buildField('MVP Features', '• Music listening analytics dashboard\n• AI-powered recommendations\n• Social proof & sharing features\n• Privacy-first data collection'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        id: 'research',
                        title: '🔬 Research & Sandboxing',
                        fields: [
                          _buildField('Key Questions', '• Which music API provides best data access?\n• How to train ML models without violating privacy?\n• What\'s the legal landscape for music data?'),
                          _buildField('Music APIs', 'Spotify, Last.fm, Apple Music APIs\n\n**Spotify Web API**\n• Rate Limit: 30 req/sec\n• Cost: Free tier + commercial licensing'),
                          _buildField('AI/ML Libraries', 'TensorFlow, PyTorch, scikit-learn'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        id: 'architecture',
                        title: '🏗️ Technical Architecture',
                        fields: [
                          _buildField('Frontend', 'Tauri + React + TypeScript'),
                          _buildField('Backend', 'Node.js + Python (ML services)'),
                          _buildField('Database', 'PostgreSQL + Redis cache'),
                          _buildField('Deployment', 'AWS EC2 + S3 + CloudFront CDN'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        id: 'features',
                        title: '📱 Feature Breakdown',
                        fields: [
                          _buildField('Music Listening Analytics', 'Dashboard showing listening patterns, top artists, genres, moods'),
                          _buildField('AI-Powered Recommendations', 'ML-based music discovery engine using collaborative filtering'),
                          _buildField('Social Proof & Sharing', 'Share listening stats and achievements'),
                          _buildField('Privacy-First Data Collection', 'Local-first data storage with optional cloud sync'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        id: 'division',
                        title: '🗂️ Division of Labor',
                        fields: [
                          _buildField('UI/UX', 'Screens, components, design system'),
                          _buildField('Domain Logic', 'Business rules, algorithms'),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: widget.onShowFeatureCards,
                              icon: const Icon(LucideIcons.layers, size: 18),
                              label: const Text('Generate Feature Cards'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Export coming soon!')),
                                );
                              },
                              icon: const Icon(LucideIcons.fileText, size: 18),
                              label: const Text('Export Markdown + JSON'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Divider
              Container(
                width: 1,
                color: AppColors.border,
              ),

              // RIGHT PANEL (40%) - Live Preview
              Expanded(
                flex: 4,
                child: Container(
                  color: AppColors.surface,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.eye,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'LIVE PREVIEW',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '# Last.fm 2025 AI/ML',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '## Project Info',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '**Name:** Last.fm 2025 AI/ML\n\n'
                                '**One-Liner:** Privacy-first music analytics with AI-powered discovery\n\n'
                                '**Target Users:**\n'
                                '• Music enthusiasts who want deeper analytics\n'
                                '• Audiophiles who track listening habits',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '## Research & Sandboxing',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '**Key Questions:**\n'
                                '• Which music API provides best data access?\n'
                                '• How to train ML models without violating privacy?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '## Technical Architecture',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '**Frontend:** Tauri + React + TypeScript\n\n'
                                '**Backend:** Node.js + Python (ML services)\n\n'
                                '**Database:** PostgreSQL + Redis cache',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String id,
    required String title,
    required List<Widget> fields,
  }) {
    final isExpanded = _expandedSections[id] ?? false;
    final isIncluded = _includedSections[id] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isIncluded ? AppColors.border : AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[id] = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isIncluded ? Colors.transparent : AppColors.background.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isIncluded ? AppColors.textPrimary : AppColors.textTertiary,
                    ),
                  ),
                  const Spacer(),
                  // Include checkbox
                  InkWell(
                    onTap: () {
                      setState(() {
                        _includedSections[id] = !isIncluded;
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isIncluded ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isIncluded ? AppColors.primary : AppColors.textTertiary,
                          width: 2,
                        ),
                      ),
                      child: isIncluded
                          ? const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fields (if expanded and included)
          if (isExpanded && isIncluded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: fields,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Field actions
          Row(
            children: [
              _buildFieldAction('Expand', LucideIcons.maximize),
              const SizedBox(width: 6),
              _buildFieldAction('Replace', LucideIcons.replace),
              const SizedBox(width: 6),
              _buildFieldAction('Refine', LucideIcons.sparkles),
              const SizedBox(width: 6),
              _buildFieldAction('Query', LucideIcons.messageSquare),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldAction(String label, IconData icon) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label field coming soon!')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

