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
          
          // Milestones Grouped by Domain
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

                // Group milestones by domain
                final Map<Domain, List<dynamic>> milestonesByDomain = {};
                for (final milestone in milestones) {
                  milestonesByDomain.putIfAbsent(milestone.domain, () => []).add(milestone);
                }

                // Define domain order (consistent with Tasks/Goals pages)
                final orderedDomains = [
                  Domain.school,
                  Domain.projects,
                  Domain.dsa,
                  Domain.career,
                  Domain.finance,
                  Domain.health,
                ];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...orderedDomains.where((domain) => milestonesByDomain.containsKey(domain)).map((domain) {
                        final domainMilestones = milestonesByDomain[domain]!;
                        return _buildDomainSection(context, domain, domainMilestones);
                      }),
                      // Personal domain (if has data)
                      if (milestonesByDomain.containsKey(Domain.personal))
                        _buildDomainSection(context, Domain.personal, milestonesByDomain[Domain.personal]!),
                    ],
                  ),
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

  Widget _buildDomainSection(BuildContext context, Domain domain, List<dynamic> milestones) {
    final domainColor = _domainColor(domain);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                domainColor.withOpacity(0.2),
                domainColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: domainColor.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _domainIcon(domain),
                size: 28,
                color: domainColor,
              ),
              const SizedBox(width: 14),
              Text(
                _domainName(domain),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: domainColor,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: domainColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${milestones.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: domainColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Milestone Tiles Grid
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive column count
            int crossAxisCount = 3;
            if (constraints.maxWidth > 1600) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth < 1000) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
        ),

        const SizedBox(height: 32), // Section spacing
      ],
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
        return 'LeetCode';
      case Domain.career:
        return 'Career';
      case Domain.gre:
        return 'GRE';
      case Domain.personal:
        return 'Personal';
    }
  }

  IconData _domainIcon(Domain domain) {
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
        return LucideIcons.cpu;
      case Domain.career:
        return LucideIcons.briefcase;
      case Domain.gre:
        return LucideIcons.bookOpen;
      case Domain.personal:
        return LucideIcons.user;
    }
  }

  Color _domainColor(Domain domain) {
    switch (domain) {
      case Domain.school:
        return Colors.indigo.shade400;
      case Domain.projects:
        return Colors.purple.shade400;
      case Domain.finance:
        return Colors.teal.shade400;
      case Domain.health:
        return Colors.orange.shade400;
      case Domain.dsa:
        return Colors.blue.shade400;
      case Domain.career:
        return Colors.cyan.shade400;
      case Domain.gre:
        return Colors.amber.shade400;
      case Domain.personal:
        return Colors.pink.shade400;
    }
  }
}
