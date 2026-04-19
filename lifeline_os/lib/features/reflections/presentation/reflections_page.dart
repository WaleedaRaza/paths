import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/constants/experts.dart';
import '../providers/chat_provider.dart';
import 'widgets/persona_sidebar.dart';
import 'widgets/chat_panel.dart';
import 'widgets/notes_panel_redesigned.dart';

class ReflectionsPage extends ConsumerWidget {
  const ReflectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expertId = ref.watch(currentExpertProvider);
    final expert = ExpertRegistry.getById(expertId);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // LEFT SIDEBAR (20%) - Personas
          SizedBox(
            width: 280,
            child: PersonaSidebar(
              onPersonaSelected: (personaId) {
                // Already handled by provider in persona_sidebar
              },
            ),
          ),

          // CENTER (50%) - Chat
          Expanded(
            flex: 5,
            child: ChatPanel(
              personaName: expert?.name ?? 'AI Expert',
              personaIcon: expert?.icon ?? '🤖',
            ),
          ),

          // RIGHT (30%) - Notes
          const SizedBox(
            width: 360,
            child: NotesPanelRedesigned(),
          ),
        ],
      ),
    );
  }
}
