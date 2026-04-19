import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../providers/planner_provider.dart';
import 'widgets/planner_entry_screen.dart';
import 'widgets/planner_editor_view_final.dart';

class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlanId = ref.watch(currentPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: currentPlanId == null
          ? PlannerEntryScreen(
              onGenerate: () {
                // Navigation handled by entry screen after generation completes
              },
            )
          : const PlannerEditorViewFinal(),
    );
  }
}
