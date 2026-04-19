import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_template.freezed.dart';
part 'workout_template.g.dart';

/// Workout day template with exercises
@freezed
class WorkoutTemplate with _$WorkoutTemplate {
  const factory WorkoutTemplate({
    required String name,
    required String description,
    required String emoji,
    required List<WorkoutExercise> exercises,
  }) = _WorkoutTemplate;
  
  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) =>
      _$WorkoutTemplateFromJson(json);
}

/// Individual exercise in a workout
@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String name,
    required String sets,
    required String reps,
    String? notes,
    @Default(false) bool isCompound, // Highlight compound movements
  }) = _WorkoutExercise;
  
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}

/// Workout log entry with weights
@freezed
class WorkoutLog with _$WorkoutLog {
  const factory WorkoutLog({
    required String exerciseName,
    required List<WorkoutSet> sets,
  }) = _WorkoutLog;
  
  factory WorkoutLog.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogFromJson(json);
}

/// Individual set with weight
@freezed
class WorkoutSet with _$WorkoutSet {
  const factory WorkoutSet({
    required int setNumber,
    String? weight, // e.g., "185 lbs", "60 kg"
    String? reps,
    @Default(false) bool isCompleted,
  }) = _WorkoutSet;
  
  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);
}

/// Predefined workout templates
class WorkoutTemplates {
  static final day1ChestTriceps = WorkoutTemplate(
    name: 'DAY 1 – Chest + Triceps',
    description: 'Heavy / Strength Focus - Primary presses + heavy compounds',
    emoji: '🥩',
    exercises: [
      const WorkoutExercise(name: 'Incline Dumbbell Bench', sets: '4', reps: '6-8', isCompound: true),
      const WorkoutExercise(name: 'Incline Smith Press', sets: '3', reps: '6-8', isCompound: true),
      const WorkoutExercise(name: 'Flat Barbell or Dumbbell Bench', sets: '3', reps: '6-8', isCompound: true, notes: '✅ fills missing chest volume'),
      const WorkoutExercise(name: 'Dips (weighted if possible)', sets: '3', reps: '8-12', isCompound: true, notes: 'best triceps compound'),
      const WorkoutExercise(name: 'Bar Pushdown', sets: '3', reps: '10-12'),
      const WorkoutExercise(name: 'Overhead Extensions', sets: '3', reps: '12-15'),
    ],
  );
  
  static final day2BackShoulders = WorkoutTemplate(
    name: 'DAY 2 – Upper Back + Shoulders',
    description: 'Traps, rear delts, upper back thickness',
    emoji: '🧱',
    exercises: [
      const WorkoutExercise(name: 'Barbell or Dumbbell Shrugs', sets: '4', reps: '10-12', isCompound: true),
      const WorkoutExercise(name: 'Seated Cable Row (upper back)', sets: '4', reps: '10-12', isCompound: true),
      const WorkoutExercise(name: 'Lat Pulldown (wide)', sets: '3', reps: '10-12'),
      const WorkoutExercise(name: 'Rear Delt Fly (machine/cable)', sets: '3', reps: '15', notes: 'missing rear delts'),
      const WorkoutExercise(name: 'Cable Lateral Raise', sets: '4', reps: '12-15'),
      const WorkoutExercise(name: 'Dumbbell Lateral Raise', sets: '3', reps: '12-15'),
    ],
  );
  
  static final day3ChestTricepsVolume = WorkoutTemplate(
    name: 'DAY 3 – Chest + Triceps',
    description: 'Volume / Isolation - Pump + stretch day',
    emoji: '🧠',
    exercises: [
      const WorkoutExercise(name: 'Incline Dumbbell Bench (lighter)', sets: '4', reps: '10-12'),
      const WorkoutExercise(name: 'Chest Fly (cable or machine)', sets: '4', reps: '12-15'),
      const WorkoutExercise(name: 'Decline or Flat Dumbbell Press', sets: '3', reps: '10-12'),
      const WorkoutExercise(name: 'Rope Pushdown', sets: '3', reps: '12-15'),
      const WorkoutExercise(name: 'Overhead Cable Extensions', sets: '3', reps: '12-15'),
      const WorkoutExercise(name: 'Skullcrushers (optional)', sets: '3', reps: '10-12', notes: 'finisher'),
    ],
  );
  
  static final day4LatsBiceps = WorkoutTemplate(
    name: 'DAY 4 – Lats + Biceps',
    description: 'Pull strength, width, and arm growth',
    emoji: '🐍',
    exercises: [
      const WorkoutExercise(name: 'Dumbbell Rows', sets: '4', reps: '8-10', isCompound: true),
      const WorkoutExercise(name: 'Machine Low Row', sets: '3', reps: '10-12'),
      const WorkoutExercise(name: 'Cable Rows', sets: '3', reps: '12-15'),
      const WorkoutExercise(name: 'Pull-ups (optional)', sets: '3', reps: 'AMRAP', notes: 'cheat code for back + biceps'),
      const WorkoutExercise(name: 'Preacher Curl', sets: '3', reps: '10-12'),
      const WorkoutExercise(name: 'Dumbbell Curl', sets: '3', reps: '12-15'),
      const WorkoutExercise(name: 'Cable Curl', sets: '3', reps: '15-20'),
    ],
  );
  
  static List<WorkoutTemplate> get all => [
    day1ChestTriceps,
    day2BackShoulders,
    day3ChestTricepsVolume,
    day4LatsBiceps,
  ];
}

