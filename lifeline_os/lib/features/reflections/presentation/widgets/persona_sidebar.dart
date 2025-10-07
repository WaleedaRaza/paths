import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

class PersonaSidebar extends StatefulWidget {
  final Function(String) onPersonaSelected;

  const PersonaSidebar({
    super.key,
    required this.onPersonaSelected,
  });

  @override
  State<PersonaSidebar> createState() => _PersonaSidebarState();
}

class _PersonaSidebarState extends State<PersonaSidebar> {
  String _selectedPersona = 'founder-engineer';

  final List<MockPersona> _personas = [
    MockPersona(
      id: 'founder-engineer',
      name: 'Founder-Engineer',
      icon: '🚀',
      tone: 'Pragmatic, action-biased',
      useCase: 'Startups, MVPs, shipping',
    ),
    MockPersona(
      id: 'mirror-guide',
      name: 'Mirror-Guide',
      icon: '🪞',
      tone: 'Reflective, philosophical',
      useCase: 'Life decisions, goal alignment',
    ),
    MockPersona(
      id: 'lock-in-coach',
      name: 'Lock-In Coach',
      icon: '⚡',
      tone: 'Direct, motivating',
      useCase: 'Accountability, momentum',
    ),
    MockPersona(
      id: 'planner',
      name: 'Planner',
      icon: '📋',
      tone: 'Structured, tactical',
      useCase: 'Project management, prioritizing',
    ),
    MockPersona(
      id: 'therapist',
      name: 'Therapist',
      icon: '🧠',
      tone: 'Empathetic, insightful',
      useCase: 'Pattern recognition, processing',
    ),
    MockPersona(
      id: 'philosopher',
      name: 'Philosopher',
      icon: '🏛️',
      tone: 'Wise, contemplative',
      useCase: 'Existential questions, meaning',
    ),
    MockPersona(
      id: 'psych-strategist',
      name: 'Psych Strategist',
      icon: '🧩',
      tone: 'Strategic, observant',
      useCase: 'Social dynamics, influence',
    ),
    MockPersona(
      id: 'architect',
      name: 'Architect',
      icon: '🏗️',
      tone: 'Technical, precise',
      useCase: 'Systems design, architecture',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
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
                const Icon(
                  LucideIcons.users,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Personas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Personas list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _personas.length,
              itemBuilder: (context, index) {
                final persona = _personas[index];
                final isSelected = _selectedPersona == persona.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPersona = persona.id;
                      });
                      widget.onPersonaSelected(persona.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Active indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Icon
                          Text(
                            persona.icon,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),

                          // Name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  persona.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    persona.tone,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Chat History Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat History',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildHistoryItem('Today', 3),
                const SizedBox(height: 8),
                _buildHistoryItem('Yesterday', 2),
                const SizedBox(height: 8),
                _buildHistoryItem('Last Week', 8),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View all coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('View All', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String label, int count) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.textTertiary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class MockPersona {
  final String id;
  final String name;
  final String icon;
  final String tone;
  final String useCase;

  MockPersona({
    required this.id,
    required this.name,
    required this.icon,
    required this.tone,
    required this.useCase,
  });
}

