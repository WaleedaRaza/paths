import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../app/theme.dart';
import '../../../../core/database/tables.dart';
import '../../../../core/database/database.dart';
import '../../../../core/providers/database_provider.dart';

class FinanceWizard extends ConsumerStatefulWidget {
  const FinanceWizard({super.key});

  @override
  ConsumerState<FinanceWizard> createState() => _FinanceWizardState();
}

class _FinanceWizardState extends ConsumerState<FinanceWizard> {
  int _currentStep = 0;
  final _uuid = const Uuid();

  // Step 1: Goal type
  String _goalType = 'Emergency Fund';

  // Step 2: Financial details
  final _milestoneNameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController(text: '0');
  final _monthlyExpensesController = TextEditingController();
  String _accountType = 'High-Yield Savings';

  // Step 3: Savings plan
  final _monthlyTargetController = TextEditingController();
  final List<Map<String, dynamic>> _subGoals = [
    {'name': 'Optimize current expenses', 'selected': true, 'target': 'Save \$200/month'},
    {'name': 'Set up automatic transfers', 'selected': true, 'target': '\$500/month on autopilot'},
    {'name': 'Find additional income', 'selected': false, 'target': 'Extra \$300/month'},
  ];

  // Step 4: Timeline
  DateTime? _targetDate;

  // Step 5: Tracking
  String _updateFrequency = 'Weekly';
  final _motivationController = TextEditingController();

  @override
  void dispose() {
    _milestoneNameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _monthlyExpensesController.dispose();
    _monthlyTargetController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  Future<void> _createFinancialGoal() async {
    if (_milestoneNameController.text.isEmpty || _targetAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final milestoneId = _uuid.v4();
    
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0;
    final currentAmount = double.tryParse(_currentAmountController.text) ?? 0;
    final monthlyTarget = double.tryParse(_monthlyTargetController.text) ?? 0;

    final metadata = json.encode({
      'goalType': _goalType,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'monthlyExpenses': double.tryParse(_monthlyExpensesController.text) ?? 0,
      'accountType': _accountType,
      'monthlyTarget': monthlyTarget,
      'updateFrequency': _updateFrequency,
      'motivation': _motivationController.text,
      'subGoals': _subGoals.where((g) => g['selected'] as bool).toList(),
    });

    // Create milestone
    await db.into(db.milestones).insert(
      MilestonesCompanion.insert(
        id: milestoneId,
        title: _milestoneNameController.text,
        description: drift.Value('\$${currentAmount.toStringAsFixed(0)} of \$${targetAmount.toStringAsFixed(0)} saved'),
        domain: drift.Value(Domain.finance),
        metadata: drift.Value(metadata),
        deadline: drift.Value(_targetDate),
      ),
    );

    // Create goal for each selected sub-goal
    final selectedGoals = _subGoals.where((g) => g['selected'] as bool).toList();

    for (int i = 0; i < selectedGoals.length; i++) {
      final subGoal = selectedGoals[i];
      final goalMetadata = json.encode({
        'target': subGoal['target'],
        'type': 'savings_plan',
      });

      await db.into(db.goals).insert(
        GoalsCompanion.insert(
          id: _uuid.v4(),
          title: subGoal['name'] as String,
          description: drift.Value(subGoal['target'] as String),
          milestoneId: drift.Value(milestoneId),
          metadata: drift.Value(goalMetadata),
          sortOrder: drift.Value(i),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Financial goal created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      child: Container(
        width: 700,
        height: 600,
        padding: const EdgeInsets.all(32),
        child: RRColumn(
          children: [
            // Header
            Row(
              children: [
                const Icon(LucideIcons.dollarSign, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Create Financial Milestone',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / 5,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),



            ),
            const SizedBox(height: 24),


            Expanded(
              child: IndexedStack(
                index: _currentStep,

                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                  _buildStep5(),
                ],
              ),
            ),

            // Navigation buttons
            Row(
              children: [
                if (_currentStep > 0)
                  TextButton.icon(
                    onPressed: () => setState(() => _currentStep--),
                    icon: const Icon(LucideIcons.arrowLeft),
                    label: const Text('Back'),
                  ),
                const Spacer(),
                if (_currentStep < 4)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentStep++),
                    child: const Text('Continue'),
                  )
                else
                  ElevatedButton(
                    onPressed: _createFinancialGoal,
                    child: const Text('Create Financial Goal'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final goalTypes = [
      {'icon': LucideIcons.shield, 'name': 'Emergency Fund', 'desc': 'Build 3-6 months of expenses saved'},
      {'icon': LucideIcons.creditCard, 'name': 'Pay Off Debt', 'desc': 'Credit cards, loans or other debts'},
      {'icon': LucideIcons.trendingUp, 'name': 'Start Investing', 'desc': 'Retirement, index funds, or stocks'},
      {'icon': LucideIcons.building, 'name': 'Save for Purchase', 'desc': 'House, car, or major purchase'},
      {'icon': LucideIcons.briefcase, 'name': 'Increase Income', 'desc': 'Side hustle, raise, or passive income'},
      {'icon': LucideIcons.calculator, 'name': 'Budget & Track', 'desc': 'Create spending plan & track it'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Financial Goal Type', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: goalTypes.length,
            itemBuilder: (context, index) {
              final type = goalTypes[index];
              final isSelected = _goalType == type['name'];
              return InkWell(
                onTap: () => setState(() => _goalType = type['name'] as String),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(type['icon'] as IconData, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(type['name'] as String, style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              type['desc'] as String,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Financial Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _milestoneNameController,
            decoration: const InputDecoration(
              labelText: 'Goal Name*',
              hintText: 'e.g., Build \$10,000 emergency fund',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetAmountController,
            decoration: const InputDecoration(
              labelText: 'Target Amount*',
              prefixText: '\$ ',
              hintText: '10000',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _currentAmountController,
            decoration: const InputDecoration(
              labelText: 'Current Amount Saved',
              prefixText: '\$ ',
              hintText: '0',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _monthlyExpensesController,
            decoration: const InputDecoration(
              labelText: 'Monthly Expenses (for reference)',
              prefixText: '\$ ',
              hintText: '3500',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _accountType,
            decoration: const InputDecoration(labelText: 'Account Type'),
            items: ['High-Yield Savings', 'Regular Savings', 'Money Market', 'Other']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) => setState(() => _accountType = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final remaining = (double.tryParse(_targetAmountController.text) ?? 0) - (double.tryParse(_currentAmountController.text) ?? 0);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Savings Plan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _monthlyTargetController,
            decoration: InputDecoration(
              labelText: 'Monthly Savings Goal',
              prefixText: '\$ ',
              hintText: '500',
              helperText: remaining > 0 ? 'Remaining: \$${remaining.toStringAsFixed(0)}' : null,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          Text('Sub-Goals:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._subGoals.map((goal) {
            return CheckboxListTile(
              title: Text(goal['name'] as String),
              subtitle: Text(goal['target'] as String),
              value: goal['selected'] as bool,
              onChanged: (value) {
                setState(() => goal['selected'] = value ?? false);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0;
    final currentAmount = double.tryParse(_currentAmountController.text) ?? 0;
    final monthlyTarget = double.tryParse(_monthlyTargetController.text) ?? 0;
    final remaining = targetAmount - currentAmount;
    final monthsNeeded = monthlyTarget > 0 ? (remaining / monthlyTarget).ceil() : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Target Completion Date'),
            subtitle: Text(_targetDate?.toString().substring(0, 10) ?? 'Not set'),
            trailing: const Icon(LucideIcons.calendar),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: monthsNeeded * 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (date != null) setState(() => _targetDate = date);
            },
          ),
          if (monthsNeeded > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projection', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text('At \$${monthlyTarget.toStringAsFixed(0)}/month, you\'ll reach your goal in:'),
                  const SizedBox(height: 8),
                  Text(
                    '$monthsNeeded months (~${(monthsNeeded / 12).toStringAsFixed(1)} years)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 5: Tracking & Motivation', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _updateFrequency,
            decoration: const InputDecoration(labelText: 'Update Frequency'),
            items: ['Daily', 'Weekly', 'Monthly']
                .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                .toList(),
            onChanged: (value) => setState(() => _updateFrequency = value!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _motivationController,
            decoration: const InputDecoration(
              labelText: 'Why is this important to you?',
              hintText: 'This will give me peace of mind and financial security...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.target, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Goal: ${_milestoneNameController.text}'),
                Text('Type: $_goalType'),
                Text('Target: \$${_targetAmountController.text}'),
                Text('Current: \$${_currentAmountController.text}'),
                Text('Monthly: \$${_monthlyTargetController.text}'),
                Text('Frequency: $_updateFrequency updates'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

