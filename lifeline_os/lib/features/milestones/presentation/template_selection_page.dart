import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import 'widgets/school_wizard.dart';
import 'widgets/projects_wizard.dart';
import 'widgets/finance_wizard.dart';

class TemplateSelectionPage extends StatelessWidget {
  const TemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = [
      {
        'icon': LucideIcons.graduationCap,
        'name': 'School',
        'description': 'Semester planning with courses, assignments, and GPA tracking',
        'color': AppColors.primary,
        'wizard': const SchoolWizard(),
      },
      {
        'icon': LucideIcons.code,
        'name': 'Projects',
        'description': 'Software projects with phases, tech stack, and KPIs',
        'color': AppColors.secondary,
        'wizard': const ProjectsWizard(),
      },
      {
        'icon': LucideIcons.dollarSign,
        'name': 'Finance',
        'description': 'Savings goals, debt payoff, and financial milestones',
        'color': const Color(0xFF10B981),
        'wizard': const FinanceWizard(),
      },
      {
        'icon': LucideIcons.heart,
        'name': 'Health',
        'description': 'Fitness goals, workout plans, and wellness tracking',
        'color': const Color(0xFFEF4444),
        'wizard': null, // Not implemented in POC
      },
      {
        'icon': LucideIcons.brain,
        'name': 'DSA',
        'description': 'Data structures & algorithms practice and interview prep',
        'color': const Color(0xFF8B5CF6),
        'wizard': null, // Not implemented in POC
      },
      {
        'icon': LucideIcons.user,
        'name': 'Personal',
        'description': 'Custom goals for anything else in your life',
        'color': AppColors.textSecondary,
        'wizard': null, // Not implemented in POC
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose a Template'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            final wizard = template['wizard'] as Widget?;
            final isImplemented = wizard != null;

            return InkWell(
              onTap: isImplemented
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => wizard,
                      );
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isImplemented ? AppColors.border : AppColors.border.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (template['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            template['icon'] as IconData,
                            color: template['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const Spacer(),
                        if (!isImplemented)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Coming Soon',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      template['name'] as String,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isImplemented ? AppColors.textSecondary : AppColors.textSecondary.withOpacity(0.5),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

