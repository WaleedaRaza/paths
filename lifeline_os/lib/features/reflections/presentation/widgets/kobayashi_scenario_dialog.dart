import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/theme.dart';

class KobayashiScenarioDialog extends ConsumerStatefulWidget {
  const KobayashiScenarioDialog({super.key});

  @override
  ConsumerState<KobayashiScenarioDialog> createState() => _KobayashiScenarioDialogState();
}

class _KobayashiScenarioDialogState extends ConsumerState<KobayashiScenarioDialog> {
  final _roleController = TextEditingController();
  final _contextController = TextEditingController();
  final _traitsController = TextEditingController();
  final _goalsController = TextEditingController();
  final _winConditionsController = TextEditingController();

  @override
  void dispose() {
    _roleController.dispose();
    _contextController.dispose();
    _traitsController.dispose();
    _goalsController.dispose();
    _winConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(
        children: [
          const Icon(LucideIcons.swords, color: AppColors.primary),
          const SizedBox(width: 12),
          const Text(
            'Configure Practice Scenario',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Define the adversarial role-play scenario. Be specific about the character, situation, and objectives.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Role
              const Text(
                'Role *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _roleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'e.g., "hostile client who thinks you\'re overcharging"',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Context
              const Text(
                'Context *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contextController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., "First project meeting after you sent the invoice"',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Traits
              const Text(
                'Psychological Traits *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _traitsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., "defensive, price-sensitive, slightly aggressive"',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Goals
              const Text(
                'Their Goals *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _goalsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., "Get a discount without losing leverage"',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Win Conditions (optional)
              const Text(
                'Win Conditions (optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _winConditionsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., "If I agree to reduce price by >20%"',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _startSession,
          icon: const Icon(LucideIcons.play, size: 16),
          label: const Text('Start Practice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _startSession() {
    if (_roleController.text.trim().isEmpty ||
        _contextController.text.trim().isEmpty ||
        _traitsController.text.trim().isEmpty ||
        _goalsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    Navigator.pop(context, {
      'role': _roleController.text.trim(),
      'context': _contextController.text.trim(),
      'traits': _traitsController.text.trim(),
      'goals': _goalsController.text.trim(),
      'winConditions': _winConditionsController.text.trim().isEmpty
          ? null
          : _winConditionsController.text.trim(),
    });
  }
}

