// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutTemplate _$WorkoutTemplateFromJson(Map<String, dynamic> json) {
  return _WorkoutTemplate.fromJson(json);
}

/// @nodoc
mixin _$WorkoutTemplate {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  List<WorkoutExercise> get exercises => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutTemplateCopyWith<WorkoutTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutTemplateCopyWith<$Res> {
  factory $WorkoutTemplateCopyWith(
          WorkoutTemplate value, $Res Function(WorkoutTemplate) then) =
      _$WorkoutTemplateCopyWithImpl<$Res, WorkoutTemplate>;
  @useResult
  $Res call(
      {String name,
      String description,
      String emoji,
      List<WorkoutExercise> exercises});
}

/// @nodoc
class _$WorkoutTemplateCopyWithImpl<$Res, $Val extends WorkoutTemplate>
    implements $WorkoutTemplateCopyWith<$Res> {
  _$WorkoutTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? emoji = null,
    Object? exercises = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExercise>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutTemplateImplCopyWith<$Res>
    implements $WorkoutTemplateCopyWith<$Res> {
  factory _$$WorkoutTemplateImplCopyWith(_$WorkoutTemplateImpl value,
          $Res Function(_$WorkoutTemplateImpl) then) =
      __$$WorkoutTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      String emoji,
      List<WorkoutExercise> exercises});
}

/// @nodoc
class __$$WorkoutTemplateImplCopyWithImpl<$Res>
    extends _$WorkoutTemplateCopyWithImpl<$Res, _$WorkoutTemplateImpl>
    implements _$$WorkoutTemplateImplCopyWith<$Res> {
  __$$WorkoutTemplateImplCopyWithImpl(
      _$WorkoutTemplateImpl _value, $Res Function(_$WorkoutTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? emoji = null,
    Object? exercises = null,
  }) {
    return _then(_$WorkoutTemplateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExercise>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutTemplateImpl implements _WorkoutTemplate {
  const _$WorkoutTemplateImpl(
      {required this.name,
      required this.description,
      required this.emoji,
      required final List<WorkoutExercise> exercises})
      : _exercises = exercises;

  factory _$WorkoutTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutTemplateImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final String emoji;
  final List<WorkoutExercise> _exercises;
  @override
  List<WorkoutExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'WorkoutTemplate(name: $name, description: $description, emoji: $emoji, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutTemplateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, emoji,
      const DeepCollectionEquality().hash(_exercises));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutTemplateImplCopyWith<_$WorkoutTemplateImpl> get copyWith =>
      __$$WorkoutTemplateImplCopyWithImpl<_$WorkoutTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutTemplateImplToJson(
      this,
    );
  }
}

abstract class _WorkoutTemplate implements WorkoutTemplate {
  const factory _WorkoutTemplate(
      {required final String name,
      required final String description,
      required final String emoji,
      required final List<WorkoutExercise> exercises}) = _$WorkoutTemplateImpl;

  factory _WorkoutTemplate.fromJson(Map<String, dynamic> json) =
      _$WorkoutTemplateImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  String get emoji;
  @override
  List<WorkoutExercise> get exercises;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutTemplateImplCopyWith<_$WorkoutTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) {
  return _WorkoutExercise.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExercise {
  String get name => throw _privateConstructorUsedError;
  String get sets => throw _privateConstructorUsedError;
  String get reps => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isCompound => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutExerciseCopyWith<WorkoutExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCopyWith<$Res> {
  factory $WorkoutExerciseCopyWith(
          WorkoutExercise value, $Res Function(WorkoutExercise) then) =
      _$WorkoutExerciseCopyWithImpl<$Res, WorkoutExercise>;
  @useResult
  $Res call(
      {String name, String sets, String reps, String? notes, bool isCompound});
}

/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res, $Val extends WorkoutExercise>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sets = null,
    Object? reps = null,
    Object? notes = freezed,
    Object? isCompound = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as String,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompound: null == isCompound
          ? _value.isCompound
          : isCompound // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseImplCopyWith<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  factory _$$WorkoutExerciseImplCopyWith(_$WorkoutExerciseImpl value,
          $Res Function(_$WorkoutExerciseImpl) then) =
      __$$WorkoutExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String sets, String reps, String? notes, bool isCompound});
}

/// @nodoc
class __$$WorkoutExerciseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCopyWithImpl<$Res, _$WorkoutExerciseImpl>
    implements _$$WorkoutExerciseImplCopyWith<$Res> {
  __$$WorkoutExerciseImplCopyWithImpl(
      _$WorkoutExerciseImpl _value, $Res Function(_$WorkoutExerciseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sets = null,
    Object? reps = null,
    Object? notes = freezed,
    Object? isCompound = null,
  }) {
    return _then(_$WorkoutExerciseImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as String,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompound: null == isCompound
          ? _value.isCompound
          : isCompound // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseImpl implements _WorkoutExercise {
  const _$WorkoutExerciseImpl(
      {required this.name,
      required this.sets,
      required this.reps,
      this.notes,
      this.isCompound = false});

  factory _$WorkoutExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseImplFromJson(json);

  @override
  final String name;
  @override
  final String sets;
  @override
  final String reps;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isCompound;

  @override
  String toString() {
    return 'WorkoutExercise(name: $name, sets: $sets, reps: $reps, notes: $notes, isCompound: $isCompound)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isCompound, isCompound) ||
                other.isCompound == isCompound));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, sets, reps, notes, isCompound);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      __$$WorkoutExerciseImplCopyWithImpl<_$WorkoutExerciseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseImplToJson(
      this,
    );
  }
}

abstract class _WorkoutExercise implements WorkoutExercise {
  const factory _WorkoutExercise(
      {required final String name,
      required final String sets,
      required final String reps,
      final String? notes,
      final bool isCompound}) = _$WorkoutExerciseImpl;

  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseImpl.fromJson;

  @override
  String get name;
  @override
  String get sets;
  @override
  String get reps;
  @override
  String? get notes;
  @override
  bool get isCompound;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutLog _$WorkoutLogFromJson(Map<String, dynamic> json) {
  return _WorkoutLog.fromJson(json);
}

/// @nodoc
mixin _$WorkoutLog {
  String get exerciseName => throw _privateConstructorUsedError;
  List<WorkoutSet> get sets => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutLogCopyWith<WorkoutLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutLogCopyWith<$Res> {
  factory $WorkoutLogCopyWith(
          WorkoutLog value, $Res Function(WorkoutLog) then) =
      _$WorkoutLogCopyWithImpl<$Res, WorkoutLog>;
  @useResult
  $Res call({String exerciseName, List<WorkoutSet> sets});
}

/// @nodoc
class _$WorkoutLogCopyWithImpl<$Res, $Val extends WorkoutLog>
    implements $WorkoutLogCopyWith<$Res> {
  _$WorkoutLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? sets = null,
  }) {
    return _then(_value.copyWith(
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSet>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutLogImplCopyWith<$Res>
    implements $WorkoutLogCopyWith<$Res> {
  factory _$$WorkoutLogImplCopyWith(
          _$WorkoutLogImpl value, $Res Function(_$WorkoutLogImpl) then) =
      __$$WorkoutLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String exerciseName, List<WorkoutSet> sets});
}

/// @nodoc
class __$$WorkoutLogImplCopyWithImpl<$Res>
    extends _$WorkoutLogCopyWithImpl<$Res, _$WorkoutLogImpl>
    implements _$$WorkoutLogImplCopyWith<$Res> {
  __$$WorkoutLogImplCopyWithImpl(
      _$WorkoutLogImpl _value, $Res Function(_$WorkoutLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? sets = null,
  }) {
    return _then(_$WorkoutLogImpl(
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutLogImpl implements _WorkoutLog {
  const _$WorkoutLogImpl(
      {required this.exerciseName, required final List<WorkoutSet> sets})
      : _sets = sets;

  factory _$WorkoutLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutLogImplFromJson(json);

  @override
  final String exerciseName;
  final List<WorkoutSet> _sets;
  @override
  List<WorkoutSet> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  String toString() {
    return 'WorkoutLog(exerciseName: $exerciseName, sets: $sets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutLogImpl &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            const DeepCollectionEquality().equals(other._sets, _sets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, exerciseName, const DeepCollectionEquality().hash(_sets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutLogImplCopyWith<_$WorkoutLogImpl> get copyWith =>
      __$$WorkoutLogImplCopyWithImpl<_$WorkoutLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutLogImplToJson(
      this,
    );
  }
}

abstract class _WorkoutLog implements WorkoutLog {
  const factory _WorkoutLog(
      {required final String exerciseName,
      required final List<WorkoutSet> sets}) = _$WorkoutLogImpl;

  factory _WorkoutLog.fromJson(Map<String, dynamic> json) =
      _$WorkoutLogImpl.fromJson;

  @override
  String get exerciseName;
  @override
  List<WorkoutSet> get sets;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutLogImplCopyWith<_$WorkoutLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) {
  return _WorkoutSet.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSet {
  int get setNumber => throw _privateConstructorUsedError;
  String? get weight =>
      throw _privateConstructorUsedError; // e.g., "185 lbs", "60 kg"
  String? get reps => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutSetCopyWith<WorkoutSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetCopyWith<$Res> {
  factory $WorkoutSetCopyWith(
          WorkoutSet value, $Res Function(WorkoutSet) then) =
      _$WorkoutSetCopyWithImpl<$Res, WorkoutSet>;
  @useResult
  $Res call({int setNumber, String? weight, String? reps, bool isCompleted});
}

/// @nodoc
class _$WorkoutSetCopyWithImpl<$Res, $Val extends WorkoutSet>
    implements $WorkoutSetCopyWith<$Res> {
  _$WorkoutSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? weight = freezed,
    Object? reps = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSetImplCopyWith<$Res>
    implements $WorkoutSetCopyWith<$Res> {
  factory _$$WorkoutSetImplCopyWith(
          _$WorkoutSetImpl value, $Res Function(_$WorkoutSetImpl) then) =
      __$$WorkoutSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int setNumber, String? weight, String? reps, bool isCompleted});
}

/// @nodoc
class __$$WorkoutSetImplCopyWithImpl<$Res>
    extends _$WorkoutSetCopyWithImpl<$Res, _$WorkoutSetImpl>
    implements _$$WorkoutSetImplCopyWith<$Res> {
  __$$WorkoutSetImplCopyWithImpl(
      _$WorkoutSetImpl _value, $Res Function(_$WorkoutSetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? weight = freezed,
    Object? reps = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_$WorkoutSetImpl(
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetImpl implements _WorkoutSet {
  const _$WorkoutSetImpl(
      {required this.setNumber,
      this.weight,
      this.reps,
      this.isCompleted = false});

  factory _$WorkoutSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetImplFromJson(json);

  @override
  final int setNumber;
  @override
  final String? weight;
// e.g., "185 lbs", "60 kg"
  @override
  final String? reps;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'WorkoutSet(setNumber: $setNumber, weight: $weight, reps: $reps, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetImpl &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, setNumber, weight, reps, isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetImplCopyWith<_$WorkoutSetImpl> get copyWith =>
      __$$WorkoutSetImplCopyWithImpl<_$WorkoutSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSet implements WorkoutSet {
  const factory _WorkoutSet(
      {required final int setNumber,
      final String? weight,
      final String? reps,
      final bool isCompleted}) = _$WorkoutSetImpl;

  factory _WorkoutSet.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetImpl.fromJson;

  @override
  int get setNumber;
  @override
  String? get weight;
  @override // e.g., "185 lbs", "60 kg"
  String? get reps;
  @override
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutSetImplCopyWith<_$WorkoutSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
