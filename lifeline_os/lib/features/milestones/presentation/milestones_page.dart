import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/tables.dart';
import '../providers/milestones_provider.dart';
import 'widgets/milestone_card.dart';
import 'widgets/milestone_modal.dart';
import 'widgets/milestone_creation_wizard.dart';

class MilestonesPage extends ConsumerWidget {
  const MilestonesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestonesAsync = ref.watch(filteredMilestonesProvider);
    final filterDomain = ref.watch(milestoneFilterDomainProvider);
    final filterStatus = ref.watch(milestoneFilterStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Filters
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Milestones',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Big picture achievements',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Row
                Row(
                  children: [
                    // Domain Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButton<Domain?>(
                        value: filterDomain,
                        hint: const Text('All Domains', style: TextStyle(fontSize: 14)),
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Domains')),
                          ...Domain.values.map((domain) => DropdownMenuItem(
                            value: domain,
                            child: Text(_domainName(domain)),
                          )),
                        ],
                        onChanged: (value) => ref.read(milestoneFilterDomainProvider.notifier).state = value,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButton<bool?>(
                        value: filterStatus,
                        hint: const Text('All Status', style: TextStyle(fontSize: 14)),
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All Status')),
                          DropdownMenuItem(value: false, child: Text('Active')),
                          DropdownMenuItem(value: true, child: Text('Completed')),
                        ],
                        onChanged: (value) => ref.read(milestoneFilterStatusProvider.notifier).state = value,
                      ),
                    ),
                    const Spacer(),
                    // Clear Filters
                    if (filterDomain != null || filterStatus != null)
                      TextButton.icon(
                        onPressed: () {
                          ref.read(milestoneFilterDomainProvider.notifier).state = null;
                          ref.read(milestoneFilterStatusProvider.notifier).state = null;
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Milestones Grid
          Expanded(
            child: milestonesAsync.when(
              data: (milestones) {
                if (milestones.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.flag,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No milestones yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create a milestone to track major achievements',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive column count based on width
                    int crossAxisCount = 3;
                    if (constraints.maxWidth > 1600) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth < 1000) {
                      crossAxisCount = 2;
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: milestones.length,
                      itemBuilder: (context, index) {
                        return MilestoneCard(milestone: milestones[index]);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMilestoneModal(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text(
          'Add Milestone',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showMilestoneModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const MilestoneCreationWizard(),
    );
  }

  String _domainName(Domain domain) {
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
        return 'DSA';
      case Domain.personal:
        return 'Personal';
    }
  }
}
