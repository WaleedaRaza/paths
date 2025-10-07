import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class FeatureCardsModal extends StatefulWidget {
  const FeatureCardsModal({super.key});

  @override
  State<FeatureCardsModal> createState() => _FeatureCardsModalState();
}

class _FeatureCardsModalState extends State<FeatureCardsModal> {
  String? _selectedGoal = 'Ship Last.fm v2';
  bool _createOriginLink = true;
  bool _useAIEstimates = true;

  final List<MockFeatureCard> _cards = [
    MockFeatureCard(
      title: 'Music API Integration',
      estimate: 90,
      files: 7,
      tasks: [
        'Research API docs (15min)',
        'Set up OAuth flow (20min)',
        'Implement data fetching (30min)',
        'Test with mock data (15min)',
        'Write integration tests (10min)',
      ],
      acceptance: [
        'Can authenticate with Spotify',
        'Can fetch user\'s top tracks',
        'Tests pass',
      ],
    ),
    MockFeatureCard(
      title: 'Analytics Dashboard UI',
      estimate: 75,
      files: 6,
      tasks: [
        'Design dashboard layout (15min)',
        'Build chart components (25min)',
        'Integrate with API data (20min)',
        'Add responsive design (15min)',
      ],
      acceptance: [
        'Dashboard displays listening stats',
        'Charts render correctly',
        'Responsive on all screens',
      ],
    ),
    MockFeatureCard(
      title: 'AI Recommendation Engine',
      estimate: 90,
      files: 5,
      tasks: [
        'Research ML algorithms (20min)',
        'Prepare training data (25min)',
        'Implement collaborative filtering (30min)',
        'Test recommendations (15min)',
      ],
      acceptance: [
        'Generates relevant recommendations',
        'Performance < 1s response time',
        'Accuracy > 70%',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.layers,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generated Feature Cards',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '3 cards • ≤90min each',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Cards List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCard(_cards[index], index + 1),
                  );
                },
              ),
            ),

            // Footer - Conversion Options
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Convert to Tasks',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Goal selector
                  Row(
                    children: [
                      const Text(
                        'Link to Goal:',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedGoal,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: const [
                              DropdownMenuItem(value: 'Ship Last.fm v2', child: Text('Ship Last.fm v2')),
                              DropdownMenuItem(value: 'Build MVP', child: Text('Build MVP')),
                              DropdownMenuItem(value: 'Beta Release', child: Text('Beta Release')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGoal = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Options
                  Row(
                    children: [
                      Checkbox(
                        value: _createOriginLink,
                        onChanged: (value) {
                          setState(() {
                            _createOriginLink = value ?? true;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Create tasks with origin link (for traceability)',
                        style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 20),
                      Checkbox(
                        value: _useAIEstimates,
                        onChanged: (value) {
                          setState(() {
                            _useAIEstimates = value ?? true;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Use AI estimates as task durations',
                        style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Converting feature cards to tasks...'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(LucideIcons.check, size: 18),
                          label: const Text('Convert All to Tasks'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                          icon: const Icon(LucideIcons.download, size: 18),
                          label: const Text('Export Cards'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }

  Widget _buildCard(MockFeatureCard card, int number) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Card $number',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  card.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Metadata
          Row(
            children: [
              _buildMetaBadge(Icons.schedule, '${card.estimate}min', AppColors.accent),
              const SizedBox(width: 12),
              _buildMetaBadge(Icons.insert_drive_file, '${card.files} files', AppColors.secondary),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Tasks
          const Text(
            'Tasks:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...card.tasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
                    Expanded(
                      child: Text(
                        task,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Acceptance
          const Text(
            'Acceptance Criteria:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...card.acceptance.map((criterion) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      LucideIcons.check,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        criterion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 12),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit coming soon!')),
                  );
                },
                icon: const Icon(LucideIcons.pencil, size: 14),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Remove coming soon!')),
                  );
                },
                icon: const Icon(LucideIcons.trash2, size: 14),
                label: const Text('Remove'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class MockFeatureCard {
  final String title;
  final int estimate;
  final int files;
  final List<String> tasks;
  final List<String> acceptance;

  MockFeatureCard({
    required this.title,
    required this.estimate,
    required this.files,
    required this.tasks,
    required this.acceptance,
  });
}

