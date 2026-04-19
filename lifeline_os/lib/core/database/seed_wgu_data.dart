import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'database.dart';
import 'tables.dart';

const _uuid = Uuid();

/// Seeds WGU Computer Science degree data
/// 8 terms (milestones), multiple courses per term (goals), tasks per course
Future<void> seedWGUData(AppDatabase db) async {
  print('🎓 Seeding WGU Computer Science degree data...');

  // Term 2 (Current) - Sept 1, 2025 to Feb 28, 2026
  final term2Id = await _createTerm(
    db,
    title: 'Term 2 (Current)',
    startDate: DateTime(2025, 9, 1),
    endDate: DateTime(2026, 2, 28),
    totalCUs: 13,
    courses: [
      {
        'code': 'D427',
        'name': 'Data Management - Applications',
        'cus': 4,
        'startDate': DateTime(2025, 9, 30),
        'endDate': DateTime(2025, 10, 31),
      },
      {
        'code': 'D426',
        'name': 'Data Management - Foundations',
        'cus': 3,
        'startDate': DateTime(2025, 10, 6),
        'endDate': DateTime(2025, 9, 30),
      },
      {
        'code': 'D315',
        'name': 'Network and Security - Foundations',
        'cus': 3,
        'startDate': DateTime(2025, 10, 31),
        'endDate': DateTime(2025, 11, 30),
      },
      {
        'code': 'D276',
        'name': 'Web Development Foundations',
        'cus': 3,
        'startDate': DateTime(2025, 11, 30),
        'endDate': DateTime(2025, 12, 31),
      },
    ],
  );

  // Term 3 - March 1, 2026 to Aug 31, 2026
  final term3Id = await _createTerm(
    db,
    title: 'Term 3',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 8, 31),
    totalCUs: 12,
    courses: [
      {'code': 'D197', 'name': 'Version Control', 'cus': 1},
      {'code': 'D685', 'name': 'Practical Applications of Prompt', 'cus': 2},
      {'code': 'D459', 'name': 'Introduction to Systems Thinking and Applications', 'cus': 3},
      {'code': 'D268', 'name': 'Introduction to Communication: Connecting with Others', 'cus': 3},
      {'code': 'C952', 'name': 'Computer Architecture', 'cus': 3},
    ],
  );

  // Term 4 - Sept 1, 2026 to Feb 28, 2027
  final term4Id = await _createTerm(
    db,
    title: 'Term 4',
    startDate: DateTime(2026, 9, 1),
    endDate: DateTime(2027, 2, 28),
    totalCUs: 13,
    courses: [
      {'code': 'D286', 'name': 'Java Fundamentals', 'cus': 3},
      {'code': 'C960', 'name': 'Discrete Mathematics II', 'cus': 4},
      {'code': 'C963', 'name': 'American Politics and the US Constitution', 'cus': 3},
      {'code': 'D287', 'name': 'Java Frameworks', 'cus': 3},
    ],
  );

  // Term 5 - March 1, 2027 to Aug 31, 2027
  final term5Id = await _createTerm(
    db,
    title: 'Term 5',
    startDate: DateTime(2027, 3, 1),
    endDate: DateTime(2027, 8, 31),
    totalCUs: 12,
    courses: [
      {'code': 'D281', 'name': 'Linux Foundations', 'cus': 3},
      {'code': 'D430', 'name': 'Fundamentals of Information Security', 'cus': 3},
      {'code': 'D288', 'name': 'Back-End Programming', 'cus': 3},
      {'code': 'D686', 'name': 'Operating Systems for Computer Scientists', 'cus': 3},
    ],
  );

  // Term 6 - Sept 1, 2027 to Feb 29, 2028
  final term6Id = await _createTerm(
    db,
    title: 'Term 6',
    startDate: DateTime(2027, 9, 1),
    endDate: DateTime(2028, 2, 29),
    totalCUs: 14,
    courses: [
      {'code': 'D387', 'name': 'Advanced Java', 'cus': 3},
      {'code': 'D333', 'name': 'Ethics in Technology', 'cus': 3},
      {'code': 'D336', 'name': 'Business of IT - Applications', 'cus': 4},
      {'code': 'D284', 'name': 'Software Engineering', 'cus': 4},
    ],
  );

  // Term 7 - March 1, 2028 to Aug 31, 2028
  final term7Id = await _createTerm(
    db,
    title: 'Term 7',
    startDate: DateTime(2028, 3, 1),
    endDate: DateTime(2028, 8, 31),
    totalCUs: 13,
    courses: [
      {'code': 'C458', 'name': 'Health, Fitness, and Wellness', 'cus': 4},
      {'code': 'C950', 'name': 'Data Structures and Algorithms II', 'cus': 4},
      {'code': 'D480', 'name': 'Software Design and Quality Assurance', 'cus': 3},
      {'code': 'D429', 'name': 'Introduction to AI for Computer Scientists', 'cus': 2},
    ],
  );

  // Term 8 - Sept 1, 2028 to Feb 28, 2029
  final term8Id = await _createTerm(
    db,
    title: 'Term 8',
    startDate: DateTime(2028, 9, 1),
    endDate: DateTime(2029, 2, 28),
    totalCUs: 9,
    courses: [
      {'code': 'D682', 'name': 'Artificial Intelligence Optimization for Computer Scientists', 'cus': 3},
      {'code': 'D683', 'name': 'Advanced AI and ML', 'cus': 3},
      {'code': 'D687', 'name': 'Computer Science Project Development with a Team', 'cus': 3},
    ],
  );

  print('✅ WGU data seeded successfully!');
  print('   - 8 terms (milestones)');
  print('   - 29 courses (goals)');
  print('   - 116 tasks (4 per course)');
}

Future<String> _createTerm(
  AppDatabase db, {
  required String title,
  required DateTime startDate,
  required DateTime endDate,
  required int totalCUs,
  required List<Map<String, dynamic>> courses,
}) async {
  final milestoneId = _uuid.v4();
  
  // Create semester metadata
  final semesterData = {
    'semester': title,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'targetGPA': 3.8,
    'weeklyStudyHours': 20,
    'courses': courses.map((c) => {
      'code': c['code'],
      'name': c['name'],
      'credits': c['cus'],
      'gradeTarget': 'Pass',
    }).toList(),
  };

  // Insert milestone
  await db.into(db.milestones).insert(
    MilestonesCompanion(
      id: drift.Value(milestoneId),
      title: drift.Value('$title - $totalCUs CUs'),
      description: drift.Value('WGU Computer Science - $title'),
      domain: drift.Value(Domain.school),
      metadata: drift.Value(jsonEncode(semesterData)),
      deadline: drift.Value(endDate),
      isCompleted: drift.Value(false),
      totalPoints: drift.Value(totalCUs * 100), // 100 pts per CU
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Create goals (courses) for this term
  for (final course in courses) {
    await _createCourse(
      db,
      milestoneId: milestoneId,
      code: course['code'] as String,
      name: course['name'] as String,
      cus: course['cus'] as int,
      startDate: course['startDate'] as DateTime?,
      endDate: course['endDate'] as DateTime?,
    );
  }

  return milestoneId;
}

Future<String> _createCourse(
  AppDatabase db, {
  required String milestoneId,
  required String code,
  required String name,
  required int cus,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final goalId = _uuid.v4();

  // Create course metadata
  final courseData = {
    'courseCode': code,
    'credits': cus,
    'gradeTarget': 'Pass',
    'professor': 'WGU Faculty',
  };

  // Insert goal
  await db.into(db.goals).insert(
    GoalsCompanion(
      id: drift.Value(goalId),
      title: drift.Value('$code: $name'),
      description: drift.Value('$cus CU${cus == 1 ? '' : 's'} - Pass/Fail'),
      milestoneId: drift.Value(milestoneId),
      metadata: drift.Value(jsonEncode(courseData)),
      isCompleted: drift.Value(false),
      totalPoints: drift.Value(cus * 100), // 100 pts per CU
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  // Create 4 tasks per course: Study, Quiz, Practice Exam, Exam
  final tasks = [
    {'title': 'Study Materials', 'priority': 2, 'points': 25},
    {'title': 'Complete Quiz', 'priority': 1, 'points': 20},
    {'title': 'Practice Exam', 'priority': 1, 'points': 25},
    {'title': 'Final Exam', 'priority': 3, 'points': 30},
  ];

  for (var i = 0; i < tasks.length; i++) {
    final task = tasks[i];
    final taskTitle = task['title'] as String;
    await db.into(db.tasks).insert(
      TasksCompanion(
        id: drift.Value(_uuid.v4()),
        title: drift.Value('$taskTitle - $code'),
        description: drift.Value('Complete ${taskTitle.toLowerCase()} for $name'),
        goalId: drift.Value(goalId),
        priority: drift.Value(task['priority'] as int),
        energy: drift.Value(1), // Medium energy
        estimatedMinutes: drift.Value(i == 0 ? 300 : 90), // Study: 5h, others: 1.5h
        dueDate: endDate != null 
            ? drift.Value(endDate.subtract(Duration(days: (4 - i) * 7)))
            : const drift.Value.absent(),
        isCompleted: drift.Value(false),
        basePoints: drift.Value(task['points'] as int),
        totalPoints: drift.Value(task['points'] as int),
        sortOrder: drift.Value(i),
        createdAt: drift.Value(DateTime.now()),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  return goalId;
}

