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

class ProjectsWizard extends ConsumerStatefulWidget {
  const ProjectsWizard({super.key});

  @override
  ConsumerState<ProjectsWizard> createState() => _ProjectsWizardState();
}

class _ProjectsWizardState extends ConsumerState<ProjectsWizard> {
  int _currentStep = 0;
  final _uuid = const Uuid();

  // Step 1: Project type
  String _projectType = 'Web App';

  // Step 2: Project details
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _selectedTechStack = [];
  final _repoUrlController = TextEditingController();

  // Step 3: Phases (auto-generated, but can be customized)
  final List<Map<String, dynamic>> _phases = [
    {'name': 'Planning & Design', 'selected': true},
    {'name': 'Frontend Development', 'selected': true},
    {'name': 'Backend Development', 'selected': true},
    {'name': 'Integration & Testing', 'selected': true},
    {'name': 'Deployment & Launch', 'selected': true},
  ];

  // Step 4: Timeline
  DateTime? _targetDate;
  int _estimatedWeeks = 12;

  // Step 5: Success metrics
  final List<String> _completionCriteria = [];
  final List<Map<String, String>> _kpis = [];

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _repoUrlController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (_projectNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project name')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final milestoneId = _uuid.v4();
    
    final metadata = json.encode({
      'projectType': _projectType,
      'description': _descriptionController.text,
      'techStack': _selectedTechStack,
      'repoUrl': _repoUrlController.text,
      'phases': _phases.where((p) => p['selected'] as bool).map((p) => p['name']).toList(),
      'estimatedWeeks': _estimatedWeeks,
      'completionCriteria': _completionCriteria,
      'kpis': _kpis,
    });

    // Create milestone
    await db.into(db.milestones).insert(
      MilestonesCompanion.insert(
        id: milestoneId,
        title: _projectNameController.text,
        description: drift.Value(_descriptionController.text),
        domain: drift.Value(Domain.projects),
        metadata: drift.Value(metadata),
        deadline: drift.Value(_targetDate),
      ),
    );

    // Create goal for each selected phase
    final selectedPhases = _phases.where((p) => p['selected'] as bool).toList();
    final weeksPerPhase = _estimatedWeeks / selectedPhases.length;

    for (int i = 0; i < selectedPhases.length; i++) {
      final phase = selectedPhases[i];
      final phaseMetadata = json.encode({
        'phaseNumber': i + 1,
        'totalPhases': selectedPhases.length,
        'estimatedWeeks': weeksPerPhase.round(),
      });

      await db.into(db.goals).insert(
        GoalsCompanion.insert(
          id: _uuid.v4(),
          title: phase['name'] as String,
          description: drift.Value('Phase ${i + 1} of ${selectedPhases.length}'),
          milestoneId: drift.Value(milestoneId),
          metadata: drift.Value(phaseMetadata),
          sortOrder: drift.Value(i),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project created successfully!'),
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
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(LucideIcons.code, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Create Project Milestone',
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

            // Steps content
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
                    onPressed: _createProject,
                    child: const Text('Create Project'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final projectTypes = [
      {'icon': LucideIcons.globe, 'name': 'Web App', 'desc': 'PWA, SPA, or full-stack web'},
      {'icon': LucideIcons.smartphone, 'name': 'Mobile App', 'desc': 'iOS, Android, or cross-platform'},
      {'icon': LucideIcons.monitor, 'name': 'Desktop App', 'desc': 'Cross-platform or native desktop'},
      {'icon': LucideIcons.terminal, 'name': 'CLI Tool', 'desc': 'Command-line utility or script'},
      {'icon': LucideIcons.server, 'name': 'API/Backend', 'desc': 'REST, GraphQL, or microservices'},
      {'icon': LucideIcons.package, 'name': 'Library/Package', 'desc': 'NPM, PyPI, or reusable module'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Project Type', style: Theme.of(context).textTheme.titleLarge),
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
            itemCount: projectTypes.length,
            itemBuilder: (context, index) {
              final type = projectTypes[index];
              final isSelected = _projectType == type['name'];
              return InkWell(
                onTap: () => setState(() => _projectType = type['name'] as String),
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
    final techOptions = ['React', 'TypeScript', 'Node.js', 'Python', 'Go', 'PostgreSQL', 'MongoDB', 'Docker', 'AWS'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Project Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _projectNameController,
            decoration: const InputDecoration(
              labelText: 'Project Name*',
              hintText: 'e.g., Task Master PWA',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Brief description of your project',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text('Tech Stack', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: techOptions.map((tech) {
              final isSelected = _selectedTechStack.contains(tech);
              return FilterChip(
                label: Text(tech),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTechStack.add(tech);
                    } else {
                      _selectedTechStack.remove(tech);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _repoUrlController,
            decoration: const InputDecoration(
              labelText: 'Repository URL (optional)',
              hintText: 'https://github.com/username/repo',
              prefixIcon: Icon(LucideIcons.github),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Project Phases', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(
            'Select which phases apply to your project:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ..._phases.map((phase) {
            return CheckboxListTile(
              title: Text(phase['name'] as String),
              value: phase['selected'] as bool,
              onChanged: (value) {
                setState(() => phase['selected'] = value ?? false);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Target Launch Date'),
            subtitle: Text(_targetDate?.toString().substring(0, 10) ?? 'Not set'),
            trailing: const Icon(LucideIcons.calendar),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 90)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (date != null) setState(() => _targetDate = date);
            },
          ),
          const SizedBox(height: 16),
          Text('Estimated Duration (weeks)', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _estimatedWeeks.toDouble(),
            min: 1,
            max: 52,
            divisions: 51,
            label: '$_estimatedWeeks weeks',
            onChanged: (value) => setState(() => _estimatedWeeks = value.toInt()),
          ),
          Text('$_estimatedWeeks weeks (~${(_estimatedWeeks / 4).round()} months)', textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 5: Success Metrics', style: Theme.of(context).textTheme.titleLarge),
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
                Text('Project: ${_projectNameController.text}'),
                Text('Type: $_projectType'),
                Text('Tech: ${_selectedTechStack.join(", ")}'),
                Text('Phases: ${_phases.where((p) => p["selected"] as bool).length}'),
                Text('Timeline: $_estimatedWeeks weeks'),
                if (_targetDate != null) Text('Target: ${_targetDate!.toString().substring(0, 10)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

