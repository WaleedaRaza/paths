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
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.secondary.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Canvas View • Scroll to Zoom',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Big picture achievements',
                      style: TextStyle(
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

                return InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(2000),
                  minScale: 0.3,
                  maxScale: 2.0,
                  constrained: false,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Domain columns with dividers
                        ...orderedDomains.where((domain) => milestonesByDomain.containsKey(domain)).expand((domain) {
                          final domainMilestones = milestonesByDomain[domain]!;
                          final domainColor = _domainColor(domain);
                          return [
                            _buildDomainColumn(context, domain, domainMilestones),
                            // Vertical divider
                            Container(
                              width: 2,
                              height: 1000,
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    domainColor.withOpacity(0.0),
                                    domainColor.withOpacity(0.4),
                                    domainColor.withOpacity(0.4),
                                    domainColor.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        }).toList()..removeLast(), // Remove last divider
                        // Personal domain (if has data)
                        if (milestonesByDomain.containsKey(Domain.personal)) ...[
                          if (orderedDomains.any((d) => milestonesByDomain.containsKey(d))) ...[
                            Container(
                              width: 2,
                              height: 1000,
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.pink.shade400.withOpacity(0.0),
                                    Colors.pink.shade400.withOpacity(0.4),
                                    Colors.pink.shade400.withOpacity(0.4),
                                    Colors.pink.shade400.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          _buildDomainColumn(context, Domain.personal, milestonesByDomain[Domain.personal]!),
                        ],
                      ],
                    ),
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

  Widget _buildDomainColumn(BuildContext context, Domain domain, List<dynamic> milestones) {
    final domainColor = _domainColor(domain);
    
    return SizedBox(
      width: 440,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  size: 24,
                  color: domainColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _domainName(domain),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: domainColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: domainColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${milestones.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: domainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Milestone Tiles (vertical list)
          ...milestones.map((milestone) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: 440,
                child: MilestoneCard(milestone: milestone),
              ),
            );
          }),
        ],
      ),
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
