// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutTemplateImpl _$$WorkoutTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutTemplateImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutTemplateImplToJson(
        _$WorkoutTemplateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'emoji': instance.emoji,
      'exercises': instance.exercises,
    };

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutExerciseImpl(
      name: json['name'] as String,
      sets: json['sets'] as String,
      reps: json['reps'] as String,
      notes: json['notes'] as String?,
      isCompound: json['isCompound'] as bool? ?? false,
    );

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
        _$WorkoutExerciseImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sets': instance.sets,
      'reps': instance.reps,
      'notes': instance.notes,
      'isCompound': instance.isCompound,
    };

_$WorkoutLogImpl _$$WorkoutLogImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutLogImpl(
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutLogImplToJson(_$WorkoutLogImpl instance) =>
    <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'sets': instance.sets,
    };

_$WorkoutSetImpl _$$WorkoutSetImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSetImpl(
      setNumber: (json['setNumber'] as num).toInt(),
      weight: json['weight'] as String?,
      reps: json['reps'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$WorkoutSetImplToJson(_$WorkoutSetImpl instance) =>
    <String, dynamic>{
      'setNumber': instance.setNumber,
      'weight': instance.weight,
      'reps': instance.reps,
      'isCompleted': instance.isCompleted,
    };
