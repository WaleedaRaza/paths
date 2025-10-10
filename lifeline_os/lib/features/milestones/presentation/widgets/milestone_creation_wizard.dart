import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../app/theme.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/tables.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/services/agents/mgtst_context_builder.dart';
import '../../../../core/providers/llm_provider.dart';
import '../../../../core/widgets/suggestion_panel.dart';
import '../../../goals/providers/goals_provider.dart';
import '../../../tasks/providers/tasks_repository.dart';
import '../../providers/milestones_provider.dart';
import '../../models/mgtst_suggestion.dart';
import '../../services/mgtst_creation_agent.dart';

class MilestoneCreationWizard extends ConsumerStatefulWidget {
  const MilestoneCreationWizard({super.key});

  @override
  ConsumerState<MilestoneCreationWizard> createState() => _MilestoneCreationWizardState();
}

class _MilestoneCreationWizardState extends ConsumerState<MilestoneCreationWizard> {
  int _currentStep = 0;
  
  // Mode selection
  bool _isAIMode = false;
  final _aiDescriptionController = TextEditingController();
  bool _isGenerating = false;
  MGTSTSuggestion? _aiSuggestion;
  
  // Milestone data
  final _milestoneNameController = TextEditingController();
  final _milestoneDescController = TextEditingController();
  Domain _selectedDomain = Domain.school;
  
  // Goals data
  final List<GoalData> _goals = [];
  
  @override
  void dispose() {
    _aiDescriptionController.dispose();
    _milestoneNameController.dispose();
    _milestoneDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LucideIcons.flag,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Create New Milestone',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(LucideIcons.x),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProgressIndicator(),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStepContent(),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton.icon(
                      onPressed: () => setState(() => _currentStep--),
                      icon: const Icon(LucideIcons.arrowLeft, size: 16),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  ElevatedButton.icon(
                    onPressed: _currentStep == 2 ? _createMilestone : _nextStep,
                    icon: Icon(
                      _currentStep == 2 ? LucideIcons.check : LucideIcons.arrowRight,
                      size: 16,
                    ),
                    label: Text(_currentStep == 2 ? 'Create Milestone' : 'Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildStepDot(0, 'Milestone'),
        _buildStepLine(0),
        _buildStepDot(1, 'Goals'),
        _buildStepLine(1),
        _buildStepDot(2, 'Review'),
      ],
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep == step;
    final isComplete = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isComplete || isActive
                ? AppColors.primary
                : AppColors.border.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete
                ? const Icon(LucideIcons.check, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isComplete = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 22),
        color: isComplete
            ? AppColors.primary
            : AppColors.border.withOpacity(0.3),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildMilestoneStep();
      case 1:
        return _buildGoalsStep();
      case 2:
        return _buildReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMilestoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Milestone Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Define your milestone - a major achievement or project',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Mode selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Creation Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isAIMode = false;
                        _aiSuggestion = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isAIMode 
                              ? AppColors.primary.withOpacity(0.2) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: !_isAIMode ? AppColors.primary : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.pencil,
                              size: 16,
                              color: !_isAIMode ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Manual Entry',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !_isAIMode ? AppColors.primary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isAIMode = true;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isAIMode 
                              ? AppColors.accent.withOpacity(0.2) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isAIMode ? AppColors.accent : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.sparkles,
                              size: 16,
                              color: _isAIMode ? AppColors.accent : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Suggest',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isAIMode ? AppColors.accent : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Show AI mode or manual mode based on selection
        if (_isAIMode)
          _buildAIMode()
        else
          _buildManualMode(),
      ],
    );
  }

  Widget _buildAIMode() {
    if (_aiSuggestion != null) {
      // Show suggestion panel
      return SizedBox(
        height: 500,
        child: MGTSTSuggestionPanel(
          suggestion: _aiSuggestion!,
          onRegenerate: _generateAISuggestion,
          onApprove: _approveAISuggestion,
          onCancel: () {
            setState(() {
              _aiSuggestion = null;
            });
          },
        ),
      );
    }

    // Show description input and generate button
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain selection (required for AI)
        const Text(
          'Domain',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: Domain.values.map((domain) {
            final isSelected = _selectedDomain == domain;
            return GestureDetector(
              onTap: () => setState(() => _selectedDomain = domain),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getDomainColor(domain).withOpacity(0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? _getDomainColor(domain)
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getDomainIcon(domain),
                      size: 18,
                      color: isSelected
                          ? _getDomainColor(domain)
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDomainLabel(domain),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? _getDomainColor(domain)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),

        const Text(
          'Describe Your Mission',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell AI what you want to achieve. Be specific about your goals, timeline, and constraints.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _aiDescriptionController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Example: "Complete my CS degree requirements for Spring 2025. I need to take Data Structures, Algorithms, and complete a capstone project. I have 15 weeks and work part-time."',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: _isGenerating || _aiDescriptionController.text.trim().isEmpty
              ? null
              : _generateAISuggestion,
          icon: _isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(LucideIcons.sparkles, size: 16),
          label: Text(_isGenerating ? 'Generating...' : 'Generate Breakdown'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            disabledBackgroundColor: AppColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildManualMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain selection
        const Text(
          'Domain',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: Domain.values.map((domain) {
            final isSelected = _selectedDomain == domain;
            return GestureDetector(
              onTap: () => setState(() => _selectedDomain = domain),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getDomainColor(domain).withOpacity(0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? _getDomainColor(domain)
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getDomainIcon(domain),
                      size: 18,
                      color: isSelected
                          ? _getDomainColor(domain)
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDomainLabel(domain),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? _getDomainColor(domain)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),

        // Name input
        const Text(
          'Milestone Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _milestoneNameController,
          decoration: InputDecoration(
            hintText: 'e.g., WGU Term 2, Build SaaS MVP, Save \$10k',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 24),

        // Description input
        const Text(
          'Description (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _milestoneDescController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'What is this milestone about?',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGoalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Goals',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Break down your milestone into actionable goals',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddGoalDialog(null),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Add Goal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),

        if (_goals.isEmpty)
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    LucideIcons.target,
                    size: 48,
                    color: AppColors.textTertiary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No goals yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add goals to break down this milestone',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _goals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = _goals[index];
              return _buildGoalCard(goal, index);
            },
          ),
      ],
    );
  }

  Widget _buildGoalCard(GoalData goal, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.target,
                size: 16,
                color: _getDomainColor(_selectedDomain),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showAddGoalDialog(index),
                icon: const Icon(LucideIcons.pencil, size: 14),
                color: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () => setState(() => _goals.removeAt(index)),
                icon: const Icon(LucideIcons.trash2, size: 14),
                color: AppColors.error,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (goal.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (goal.tasks.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: goal.tasks.map((task) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.check,
                        size: 10,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review & Create',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review your milestone before creating',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Milestone preview
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDomainColor(_selectedDomain).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getDomainIcon(_selectedDomain),
                      size: 14,
                      color: _getDomainColor(_selectedDomain),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getDomainLabel(_selectedDomain),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _getDomainColor(_selectedDomain),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                _milestoneNameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              if (_milestoneDescController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _milestoneDescController.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Stats
              Row(
                children: [
                  _buildStatChip(
                    LucideIcons.target,
                    '${_goals.length} Goals',
                    AppColors.secondary,
                  ),
                  const SizedBox(width: 12),
                  _buildStatChip(
                    LucideIcons.check,
                    '${_goals.fold(0, (sum, g) => sum + g.tasks.length)} Tasks',
                    AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),

        if (_goals.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Goals Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_goals.length, (index) {
            final goal = _goals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildGoalCard(goal, index),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_milestoneNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a milestone name')),
        );
        return;
      }
    }
    setState(() => _currentStep++);
  }

  void _showAddGoalDialog(int? editIndex) {
    final titleController = TextEditingController(
      text: editIndex != null ? _goals[editIndex].title : '',
    );
    final descController = TextEditingController(
      text: editIndex != null ? _goals[editIndex].description : '',
    );
    final List<String> tasks = editIndex != null
        ? List<String>.from(_goals[editIndex].tasks)
        : [];
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.target,
                      color: _getDomainColor(_selectedDomain),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      editIndex != null ? 'Edit Goal' : 'Add Goal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Goal Title', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Complete D427 Course',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Description (Optional)', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'What does this goal involve?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tasks (Optional)', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: const InputDecoration(
                          hintText: 'Add a task',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            setDialogState(() {
                              tasks.add(value.trim());
                              taskController.clear();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (taskController.text.trim().isNotEmpty) {
                          setDialogState(() {
                            tasks.add(taskController.text.trim());
                            taskController.clear();
                          });
                        }
                      },
                      child: const Icon(LucideIcons.plus, size: 16),
                    ),
                  ],
                ),
                if (tasks.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tasks.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        deleteIcon: const Icon(LucideIcons.x, size: 14),
                        onDeleted: () {
                          setDialogState(() => tasks.removeAt(entry.key));
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a goal title')),
                          );
                          return;
                        }
                        
                        final goalData = GoalData(
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          tasks: tasks,
                        );

                        setState(() {
                          if (editIndex != null) {
                            _goals[editIndex] = goalData;
                          } else {
                            _goals.add(goalData);
                          }
                        });
                        
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(editIndex != null ? 'Update' : 'Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateAISuggestion() async {
    if (_aiDescriptionController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // Build context
      final context = await MGTSTContextBuilder.buildContext(ref);
      final llm = ref.read(activeLLMProvider);
      
      if (llm == null) {
        throw Exception('No LLM configured. Please check Settings → AI Models');
      }
      
      final agent = MGTSTCreationAgent(llm);

      // Generate suggestion
      final suggestion = await agent.suggestMGTST(
        userDescription: _aiDescriptionController.text.trim(),
        selectedDomain: _selectedDomain,
        existingContext: agent.buildMGTSTContext(context),
      );

      setState(() {
        _aiSuggestion = suggestion;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating suggestion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _approveAISuggestion(MGTSTSuggestion suggestion) {
    // Populate milestone name from suggestion
    _milestoneNameController.text = suggestion.mission.suggestedTitle;
    _milestoneDescController.text = _aiDescriptionController.text.trim();

    // Populate goals from selected suggestions
    _goals.clear();
    for (final goalSuggestion in suggestion.goals) {
      if (goalSuggestion.selected) {
        _goals.add(GoalData(
          title: goalSuggestion.title,
          description: goalSuggestion.description,
          tasks: goalSuggestion.tasks
              .where((t) => t.selected)
              .map((t) => t.title)
              .toList(),
        ));
      }
    }

    // Skip to review step (step 2)
    setState(() {
      _currentStep = 2;
      _aiSuggestion = null;
    });
  }

  Future<void> _createMilestone() async {
    try {
      final db = ref.read(databaseProvider);
      
      // Create milestone
      final milestoneIdStr = DateTime.now().millisecondsSinceEpoch.toString();
      await db.into(db.milestones).insert(
        MilestonesCompanion.insert(
          id: milestoneIdStr,
          title: _milestoneNameController.text.trim(),
          domain: drift.Value(_selectedDomain),
          description: drift.Value(_milestoneDescController.text.trim().isEmpty
              ? null
              : _milestoneDescController.text.trim()),
          metadata: const drift.Value(null),
          isCompleted: const drift.Value(false),
          totalPoints: const drift.Value(0),
          createdAt: drift.Value(DateTime.now()),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      // Create goals and tasks
      final tasksRepo = ref.read(tasksRepositoryProvider);
      
      for (final goalData in _goals) {
        // Generate unique ID for goal
        final goalIdStr = DateTime.now().millisecondsSinceEpoch.toString();
        
        await db.into(db.goals).insert(
          GoalsCompanion.insert(
            id: goalIdStr,
            title: goalData.title,
            description: drift.Value(
              goalData.description.isEmpty ? null : goalData.description,
            ),
            milestoneId: drift.Value(milestoneIdStr),
            metadata: const drift.Value(null),
            isCompleted: const drift.Value(false),
            totalPoints: const drift.Value(0),
            createdAt: drift.Value(DateTime.now()),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );

        // Small delay to ensure unique timestamps
        await Future.delayed(const Duration(milliseconds: 1));

        // Create tasks for this goal
        for (final taskTitle in goalData.tasks) {
          await tasksRepo.createTask(
            title: taskTitle,
            goalId: goalIdStr,
          );
        }
      }

      // Refresh providers
      ref.invalidate(allMilestonesProvider);
      ref.invalidate(allGoalsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Milestone created successfully!'),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  IconData _getDomainIcon(Domain domain) {
    switch (domain) {
      case Domain.school:
        return LucideIcons.graduationCap;
      case Domain.projects:
        return LucideIcons.code;
      case Domain.finance:
        return LucideIcons.dollarSign;
      case Domain.health:
        return LucideIcons.heart;
      case Domain.dsa:
        return LucideIcons.binary;
      case Domain.career:
        return LucideIcons.briefcase;
      case Domain.gre:
        return LucideIcons.bookOpen;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _getDomainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return AppColors.primary;
      case Domain.projects:
        return AppColors.secondary;
      case Domain.finance:
        return const Color(0xFF10B981);
      case Domain.health:
        return const Color(0xFFEF4444);
      case Domain.dsa:
        return const Color(0xFF8B5CF6);
      case Domain.career:
        return const Color(0xFF06B6D4);
      case Domain.gre:
        return const Color(0xFFFBBF24);
      case Domain.personal:
        return const Color(0xFFEC4899);
    }
  }

  String _getDomainLabel(Domain domain) {
    switch (domain) {
      case Domain.school:
        return 'School';
      case Domain.projects:
        return 'Projects';
      case Domain.finance:
        return 'Finance';
      case Domain.health:
        return 'Health';
      case Domain.dsa:
        return 'LeetCode';
      case Domain.career:
        return 'Career';
      case Domain.gre:
        return 'GRE';
      case Domain.personal:
        return 'Personal';
    }
  }
}

class GoalData {
  final String title;
  final String description;
  final List<String> tasks;

  GoalData({
    required this.title,
    required this.description,
    required this.tasks,
  });
}

