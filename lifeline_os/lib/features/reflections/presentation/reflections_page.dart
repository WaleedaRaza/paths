import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import 'widgets/persona_sidebar.dart';
import 'widgets/chat_panel.dart';
import 'widgets/notes_panel.dart';

class ReflectionsPage extends ConsumerStatefulWidget {
  const ReflectionsPage({super.key});

  @override
  ConsumerState<ReflectionsPage> createState() => _ReflectionsPageState();
}

class _ReflectionsPageState extends ConsumerState<ReflectionsPage> {
  String _selectedPersona = 'founder-engineer';
  String _selectedPersonaName = 'Founder-Engineer';
  String _selectedPersonaIcon = '🚀';

  final Map<String, Map<String, String>> _personaData = {
    'founder-engineer': {'name': 'Founder-Engineer', 'icon': '🚀'},
    'mirror-guide': {'name': 'Mirror-Guide', 'icon': '🪞'},
    'lock-in-coach': {'name': 'Lock-In Coach', 'icon': '⚡'},
    'planner': {'name': 'Planner', 'icon': '📋'},
    'therapist': {'name': 'Therapist', 'icon': '🧠'},
    'philosopher': {'name': 'Philosopher', 'icon': '🏛️'},
    'psych-strategist': {'name': 'Psych Strategist', 'icon': '🧩'},
    'architect': {'name': 'Architect', 'icon': '🏗️'},
  };

  void _onPersonaSelected(String personaId) {
    setState(() {
      _selectedPersona = personaId;
      _selectedPersonaName = _personaData[personaId]?['name'] ?? 'AI Persona';
      _selectedPersonaIcon = _personaData[personaId]?['icon'] ?? '🤖';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // LEFT SIDEBAR (20%) - Personas
          SizedBox(
            width: 280,
            child: PersonaSidebar(
              onPersonaSelected: _onPersonaSelected,
            ),
          ),

          // CENTER (50%) - Chat
          Expanded(
            flex: 5,
            child: ChatPanel(
              personaName: _selectedPersonaName,
              personaIcon: _selectedPersonaIcon,
            ),
          ),

          // RIGHT (30%) - Notes
          SizedBox(
            width: 340,
            child: const NotesPanel(),
          ),
        ],
      ),
    );
  }
}
