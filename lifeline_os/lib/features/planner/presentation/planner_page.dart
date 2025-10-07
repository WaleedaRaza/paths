import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import 'widgets/planner_entry_screen.dart';
import 'widgets/planner_editor_view.dart';
import 'widgets/feature_cards_modal.dart';

class PlannerPage extends ConsumerStatefulWidget {
  const PlannerPage({super.key});

  @override
  ConsumerState<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends ConsumerState<PlannerPage> {
  bool _hasGeneratedPlan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _hasGeneratedPlan
          ? PlannerEditorView(
              onShowFeatureCards: () {
                showDialog(
                  context: context,
                  builder: (context) => const FeatureCardsModal(),
                );
              },
            )
          : PlannerEntryScreen(
              onGenerate: () {
                setState(() {
                  _hasGeneratedPlan = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Plan generated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
    );
  }
}
