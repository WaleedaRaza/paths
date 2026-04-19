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

class SchoolWizard extends ConsumerStatefulWidget {
  const SchoolWizard({super.key});

  @override
  ConsumerState<SchoolWizard> createState() => _SchoolWizardState();
}

class _SchoolWizardState extends ConsumerState<SchoolWizard> {
  int _currentStep = 0;
  final _uuid = const Uuid();

  // Step 1: Semester details
  final _semesterNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final _gpaTargetController = TextEditingController(text: '4.0');

  // Step 2 & 3: Courses
  final List<Map<String, dynamic>> _courses = [];

  // Step 5: Study preferences
  final _weeklyHoursController = TextEditingController(text: '20');
  String _examPrepStrategy = 'Spaced repetition + practice exams';

  @override
  void dispose() {
    _semesterNameController.dispose();
    _gpaTargetController.dispose();
    _weeklyHoursController.dispose();
    super.dispose();
  }

  void _addCourse() {
    setState(() {
      _courses.add({
        'id': _uuid.v4(),
        'name': '',
        'credits': 3,
        'professor': '',
        'gradeTarget': 'A',
      });
    });
  }

  void _removeCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  Future<void> _createSemester() async {
    if (_semesterNameController.text.isEmpty || _courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final milestoneId = _uuid.v4();
    
    final metadata = json.encode({
      'semesterType': _semesterNameController.text,
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'gpaTarget': double.tryParse(_gpaTargetController.text) ?? 4.0,
      'weeklyStudyHours': int.tryParse(_weeklyHoursController.text) ?? 20,
      'examPrepStrategy': _examPrepStrategy,
      'courses': _courses,
    });

    // Create milestone
    await db.into(db.milestones).insert(
      MilestonesCompanion.insert(
        id: milestoneId,
        title: '${_semesterNameController.text} Semester',
        description: drift.Value('GPA Target: ${_gpaTargetController.text}'),
        domain: drift.Value(Domain.school),
        metadata: drift.Value(metadata),
        deadline: drift.Value(_endDate),
      ),
    );

    // Create goal for each course
    for (final course in _courses) {
      final courseMetadata = json.encode({
        'credits': course['credits'],
        'professor': course['professor'],
        'gradeTarget': course['gradeTarget'],
      });

      await db.into(db.goals).insert(
        GoalsCompanion.insert(
          id: _uuid.v4(),
          title: course['name'] as String,
          description: drift.Value('Grade Target: ${course['gradeTarget']} • ${course['credits']} credits'),
          milestoneId: drift.Value(milestoneId),
          metadata: drift.Value(courseMetadata),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semester created successfully!'),
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
                const Icon(LucideIcons.graduationCap, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Create Semester Milestone',
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
                    onPressed: _createSemester,
                    child: const Text('Create Semester'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Semester Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _semesterNameController,
            decoration: const InputDecoration(
              labelText: 'Semester Name*',
              hintText: 'e.g., Fall 2025',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(_startDate?.toString().substring(0, 10) ?? 'Not set'),
                  trailing: const Icon(LucideIcons.calendar),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) setState(() => _startDate = date);
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(_endDate?.toString().substring(0, 10) ?? 'Not set'),
                  trailing: const Icon(LucideIcons.calendar),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: _startDate ?? DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) setState(() => _endDate = date);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _gpaTargetController,
            decoration: const InputDecoration(
              labelText: 'GPA Target',
              hintText: '4.0',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2: Add Courses', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(
          'Add all courses you\'re taking this semester. We\'ll create a goal for each course.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(LucideIcons.book),
                  title: Text(_courses[index]['name'].isEmpty ? 'Course ${index + 1}' : _courses[index]['name']),
                  subtitle: Text('${_courses[index]['credits']} credits • Target: ${_courses[index]['gradeTarget']}'),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.trash2, color: Colors.red),
                    onPressed: () => _removeCourse(index),
                  ),
                  onTap: () {
                    setState(() => _currentStep = 2);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addCourse,
          icon: const Icon(LucideIcons.plus),
          label: const Text('Add Course'),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    if (_courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.bookOpen, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text('No courses added yet'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _currentStep = 1),
              child: const Text('Go back and add courses'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Course Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ...List.generate(_courses.length, (index) {
            final course = _courses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Course ${index + 1} Name*'),
                      onChanged: (value) => _courses[index]['name'] = value,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: course['credits'] as int,
                            decoration: const InputDecoration(labelText: 'Credits'),
                            items: [1, 2, 3, 4, 5, 6].map((credits) {
                              return DropdownMenuItem(value: credits, child: Text('$credits'));
                            }).toList(),
                            onChanged: (value) => setState(() => _courses[index]['credits'] = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: course['gradeTarget'] as String,
                            decoration: const InputDecoration(labelText: 'Grade Target'),
                            items: ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'Pass'].map((grade) {
                              return DropdownMenuItem(value: grade, child: Text(grade));
                            }).toList(),
                            onChanged: (value) => setState(() => _courses[index]['gradeTarget'] = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Professor Name (optional)'),
                      onChanged: (value) => _courses[index]['professor'] = value,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    final duration = _startDate != null && _endDate != null
        ? _endDate!.difference(_startDate!).inDays
        : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Timeline', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          if (_startDate != null && _endDate != null) ...[
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
                  Text('Semester Duration', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 20),
                      const SizedBox(width: 8),
                      Text('Start: ${_startDate!.toString().substring(0, 10)}'),
                      const Spacer(),
                      const Icon(LucideIcons.calendar, size: 20),
                      const SizedBox(width: 8),
                      Text('End: ${_endDate!.toString().substring(0, 10)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$duration days (~${(duration / 7).round()} weeks)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Auto-Generated Timeline:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...List.generate(_courses.length, (index) {
              final course = _courses[index];
              return ListTile(
                leading: const Icon(LucideIcons.target),
                title: Text(course['name'].isEmpty ? 'Course ${index + 1}' : course['name']),
                subtitle: Text('Full semester: ${_startDate!.toString().substring(0, 10)} → ${_endDate!.toString().substring(0, 10)}'),
              );
            }),
          ] else ...[
            const Center(
              child: Column(
                children: [
                  Icon(LucideIcons.calendar, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Set start and end dates in Step 1 to see timeline'),
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
          Text('Step 5: Study Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _weeklyHoursController,
            decoration: const InputDecoration(
              labelText: 'Weekly Study Hours Target',
              hintText: '20',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text('Exam Prep Strategy', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'e.g., Spaced repetition + practice exams',
            ),
            maxLines: 3,
            onChanged: (value) => _examPrepStrategy = value,
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
                    const Icon(LucideIcons.lightbulb, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Semester: ${_semesterNameController.text}'),
                Text('Courses: ${_courses.length}'),
                Text('GPA Target: ${_gpaTargetController.text}'),
                Text('Weekly Study: ${_weeklyHoursController.text} hours'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

