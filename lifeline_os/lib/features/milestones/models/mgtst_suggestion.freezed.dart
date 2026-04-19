// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mgtst_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MGTSTSuggestion _$MGTSTSuggestionFromJson(Map<String, dynamic> json) {
  return _MGTSTSuggestion.fromJson(json);
}

/// @nodoc
mixin _$MGTSTSuggestion {
  MissionSuggestion get mission => throw _privateConstructorUsedError;
  List<GoalSuggestion> get goals => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MGTSTSuggestionCopyWith<MGTSTSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MGTSTSuggestionCopyWith<$Res> {
  factory $MGTSTSuggestionCopyWith(
          MGTSTSuggestion value, $Res Function(MGTSTSuggestion) then) =
      _$MGTSTSuggestionCopyWithImpl<$Res, MGTSTSuggestion>;
  @useResult
  $Res call(
      {MissionSuggestion mission, List<GoalSuggestion> goals, String notes});

  $MissionSuggestionCopyWith<$Res> get mission;
}

/// @nodoc
class _$MGTSTSuggestionCopyWithImpl<$Res, $Val extends MGTSTSuggestion>
    implements $MGTSTSuggestionCopyWith<$Res> {
  _$MGTSTSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mission = null,
    Object? goals = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      mission: null == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as MissionSuggestion,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<GoalSuggestion>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MissionSuggestionCopyWith<$Res> get mission {
    return $MissionSuggestionCopyWith<$Res>(_value.mission, (value) {
      return _then(_value.copyWith(mission: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MGTSTSuggestionImplCopyWith<$Res>
    implements $MGTSTSuggestionCopyWith<$Res> {
  factory _$$MGTSTSuggestionImplCopyWith(_$MGTSTSuggestionImpl value,
          $Res Function(_$MGTSTSuggestionImpl) then) =
      __$$MGTSTSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MissionSuggestion mission, List<GoalSuggestion> goals, String notes});

  @override
  $MissionSuggestionCopyWith<$Res> get mission;
}

/// @nodoc
class __$$MGTSTSuggestionImplCopyWithImpl<$Res>
    extends _$MGTSTSuggestionCopyWithImpl<$Res, _$MGTSTSuggestionImpl>
    implements _$$MGTSTSuggestionImplCopyWith<$Res> {
  __$$MGTSTSuggestionImplCopyWithImpl(
      _$MGTSTSuggestionImpl _value, $Res Function(_$MGTSTSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mission = null,
    Object? goals = null,
    Object? notes = null,
  }) {
    return _then(_$MGTSTSuggestionImpl(
      mission: null == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as MissionSuggestion,
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<GoalSuggestion>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MGTSTSuggestionImpl implements _MGTSTSuggestion {
  const _$MGTSTSuggestionImpl(
      {required this.mission,
      required final List<GoalSuggestion> goals,
      required this.notes})
      : _goals = goals;

  factory _$MGTSTSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MGTSTSuggestionImplFromJson(json);

  @override
  final MissionSuggestion mission;
  final List<GoalSuggestion> _goals;
  @override
  List<GoalSuggestion> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  @override
  final String notes;

  @override
  String toString() {
    return 'MGTSTSuggestion(mission: $mission, goals: $goals, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MGTSTSuggestionImpl &&
            (identical(other.mission, mission) || other.mission == mission) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, mission, const DeepCollectionEquality().hash(_goals), notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MGTSTSuggestionImplCopyWith<_$MGTSTSuggestionImpl> get copyWith =>
      __$$MGTSTSuggestionImplCopyWithImpl<_$MGTSTSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MGTSTSuggestionImplToJson(
      this,
    );
  }
}

abstract class _MGTSTSuggestion implements MGTSTSuggestion {
  const factory _MGTSTSuggestion(
      {required final MissionSuggestion mission,
      required final List<GoalSuggestion> goals,
      required final String notes}) = _$MGTSTSuggestionImpl;

  factory _MGTSTSuggestion.fromJson(Map<String, dynamic> json) =
      _$MGTSTSuggestionImpl.fromJson;

  @override
  MissionSuggestion get mission;
  @override
  List<GoalSuggestion> get goals;
  @override
  String get notes;
  @override
  @JsonKey(ignore: true)
  _$$MGTSTSuggestionImplCopyWith<_$MGTSTSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionSuggestion _$MissionSuggestionFromJson(Map<String, dynamic> json) {
  return _MissionSuggestion.fromJson(json);
}

/// @nodoc
mixin _$MissionSuggestion {
  String get suggestedTitle => throw _privateConstructorUsedError;
  String get rationale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionSuggestionCopyWith<MissionSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionSuggestionCopyWith<$Res> {
  factory $MissionSuggestionCopyWith(
          MissionSuggestion value, $Res Function(MissionSuggestion) then) =
      _$MissionSuggestionCopyWithImpl<$Res, MissionSuggestion>;
  @useResult
  $Res call({String suggestedTitle, String rationale});
}

/// @nodoc
class _$MissionSuggestionCopyWithImpl<$Res, $Val extends MissionSuggestion>
    implements $MissionSuggestionCopyWith<$Res> {
  _$MissionSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedTitle = null,
    Object? rationale = null,
  }) {
    return _then(_value.copyWith(
      suggestedTitle: null == suggestedTitle
          ? _value.suggestedTitle
          : suggestedTitle // ignore: cast_nullable_to_non_nullable
              as String,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionSuggestionImplCopyWith<$Res>
    implements $MissionSuggestionCopyWith<$Res> {
  factory _$$MissionSuggestionImplCopyWith(_$MissionSuggestionImpl value,
          $Res Function(_$MissionSuggestionImpl) then) =
      __$$MissionSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String suggestedTitle, String rationale});
}

/// @nodoc
class __$$MissionSuggestionImplCopyWithImpl<$Res>
    extends _$MissionSuggestionCopyWithImpl<$Res, _$MissionSuggestionImpl>
    implements _$$MissionSuggestionImplCopyWith<$Res> {
  __$$MissionSuggestionImplCopyWithImpl(_$MissionSuggestionImpl _value,
      $Res Function(_$MissionSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedTitle = null,
    Object? rationale = null,
  }) {
    return _then(_$MissionSuggestionImpl(
      suggestedTitle: null == suggestedTitle
          ? _value.suggestedTitle
          : suggestedTitle // ignore: cast_nullable_to_non_nullable
              as String,
      rationale: null == rationale
          ? _value.rationale
          : rationale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionSuggestionImpl implements _MissionSuggestion {
  const _$MissionSuggestionImpl(
      {required this.suggestedTitle, required this.rationale});

  factory _$MissionSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionSuggestionImplFromJson(json);

  @override
  final String suggestedTitle;
  @override
  final String rationale;

  @override
  String toString() {
    return 'MissionSuggestion(suggestedTitle: $suggestedTitle, rationale: $rationale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionSuggestionImpl &&
            (identical(other.suggestedTitle, suggestedTitle) ||
                other.suggestedTitle == suggestedTitle) &&
            (identical(other.rationale, rationale) ||
                other.rationale == rationale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, suggestedTitle, rationale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionSuggestionImplCopyWith<_$MissionSuggestionImpl> get copyWith =>
      __$$MissionSuggestionImplCopyWithImpl<_$MissionSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionSuggestionImplToJson(
      this,
    );
  }
}

abstract class _MissionSuggestion implements MissionSuggestion {
  const factory _MissionSuggestion(
      {required final String suggestedTitle,
      required final String rationale}) = _$MissionSuggestionImpl;

  factory _MissionSuggestion.fromJson(Map<String, dynamic> json) =
      _$MissionSuggestionImpl.fromJson;

  @override
  String get suggestedTitle;
  @override
  String get rationale;
  @override
  @JsonKey(ignore: true)
  _$$MissionSuggestionImplCopyWith<_$MissionSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalSuggestion _$GoalSuggestionFromJson(Map<String, dynamic> json) {
  return _GoalSuggestion.fromJson(json);
}

/// @nodoc
mixin _$GoalSuggestion {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<TaskSuggestion> get tasks => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoalSuggestionCopyWith<GoalSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalSuggestionCopyWith<$Res> {
  factory $GoalSuggestionCopyWith(
          GoalSuggestion value, $Res Function(GoalSuggestion) then) =
      _$GoalSuggestionCopyWithImpl<$Res, GoalSuggestion>;
  @useResult
  $Res call(
      {String title,
      String description,
      List<TaskSuggestion> tasks,
      bool selected});
}

/// @nodoc
class _$GoalSuggestionCopyWithImpl<$Res, $Val extends GoalSuggestion>
    implements $GoalSuggestionCopyWith<$Res> {
  _$GoalSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? tasks = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskSuggestion>,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalSuggestionImplCopyWith<$Res>
    implements $GoalSuggestionCopyWith<$Res> {
  factory _$$GoalSuggestionImplCopyWith(_$GoalSuggestionImpl value,
          $Res Function(_$GoalSuggestionImpl) then) =
      __$$GoalSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      List<TaskSuggestion> tasks,
      bool selected});
}

/// @nodoc
class __$$GoalSuggestionImplCopyWithImpl<$Res>
    extends _$GoalSuggestionCopyWithImpl<$Res, _$GoalSuggestionImpl>
    implements _$$GoalSuggestionImplCopyWith<$Res> {
  __$$GoalSuggestionImplCopyWithImpl(
      _$GoalSuggestionImpl _value, $Res Function(_$GoalSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? tasks = null,
    Object? selected = null,
  }) {
    return _then(_$GoalSuggestionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskSuggestion>,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalSuggestionImpl implements _GoalSuggestion {
  const _$GoalSuggestionImpl(
      {required this.title,
      required this.description,
      required final List<TaskSuggestion> tasks,
      this.selected = true})
      : _tasks = tasks;

  factory _$GoalSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalSuggestionImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  final List<TaskSuggestion> _tasks;
  @override
  List<TaskSuggestion> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  @JsonKey()
  final bool selected;

  @override
  String toString() {
    return 'GoalSuggestion(title: $title, description: $description, tasks: $tasks, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalSuggestionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, description,
      const DeepCollectionEquality().hash(_tasks), selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalSuggestionImplCopyWith<_$GoalSuggestionImpl> get copyWith =>
      __$$GoalSuggestionImplCopyWithImpl<_$GoalSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalSuggestionImplToJson(
      this,
    );
  }
}

abstract class _GoalSuggestion implements GoalSuggestion {
  const factory _GoalSuggestion(
      {required final String title,
      required final String description,
      required final List<TaskSuggestion> tasks,
      final bool selected}) = _$GoalSuggestionImpl;

  factory _GoalSuggestion.fromJson(Map<String, dynamic> json) =
      _$GoalSuggestionImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  List<TaskSuggestion> get tasks;
  @override
  bool get selected;
  @override
  @JsonKey(ignore: true)
  _$$GoalSuggestionImplCopyWith<_$GoalSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskSuggestion _$TaskSuggestionFromJson(Map<String, dynamic> json) {
  return _TaskSuggestion.fromJson(json);
}

/// @nodoc
mixin _$TaskSuggestion {
  String get title => throw _privateConstructorUsedError;
  String get priority =>
      throw _privateConstructorUsedError; // low, medium, high
  String get energy => throw _privateConstructorUsedError; // low, medium, high
  bool get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskSuggestionCopyWith<TaskSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskSuggestionCopyWith<$Res> {
  factory $TaskSuggestionCopyWith(
          TaskSuggestion value, $Res Function(TaskSuggestion) then) =
      _$TaskSuggestionCopyWithImpl<$Res, TaskSuggestion>;
  @useResult
  $Res call({String title, String priority, String energy, bool selected});
}

/// @nodoc
class _$TaskSuggestionCopyWithImpl<$Res, $Val extends TaskSuggestion>
    implements $TaskSuggestionCopyWith<$Res> {
  _$TaskSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? priority = null,
    Object? energy = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      energy: null == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskSuggestionImplCopyWith<$Res>
    implements $TaskSuggestionCopyWith<$Res> {
  factory _$$TaskSuggestionImplCopyWith(_$TaskSuggestionImpl value,
          $Res Function(_$TaskSuggestionImpl) then) =
      __$$TaskSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String priority, String energy, bool selected});
}

/// @nodoc
class __$$TaskSuggestionImplCopyWithImpl<$Res>
    extends _$TaskSuggestionCopyWithImpl<$Res, _$TaskSuggestionImpl>
    implements _$$TaskSuggestionImplCopyWith<$Res> {
  __$$TaskSuggestionImplCopyWithImpl(
      _$TaskSuggestionImpl _value, $Res Function(_$TaskSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? priority = null,
    Object? energy = null,
    Object? selected = null,
  }) {
    return _then(_$TaskSuggestionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      energy: null == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskSuggestionImpl implements _TaskSuggestion {
  const _$TaskSuggestionImpl(
      {required this.title,
      this.priority = 'medium',
      this.energy = 'medium',
      this.selected = true});

  factory _$TaskSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskSuggestionImplFromJson(json);

  @override
  final String title;
  @override
  @JsonKey()
  final String priority;
// low, medium, high
  @override
  @JsonKey()
  final String energy;
// low, medium, high
  @override
  @JsonKey()
  final bool selected;

  @override
  String toString() {
    return 'TaskSuggestion(title: $title, priority: $priority, energy: $energy, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskSuggestionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, priority, energy, selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskSuggestionImplCopyWith<_$TaskSuggestionImpl> get copyWith =>
      __$$TaskSuggestionImplCopyWithImpl<_$TaskSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskSuggestionImplToJson(
      this,
    );
  }
}

abstract class _TaskSuggestion implements TaskSuggestion {
  const factory _TaskSuggestion(
      {required final String title,
      final String priority,
      final String energy,
      final bool selected}) = _$TaskSuggestionImpl;

  factory _TaskSuggestion.fromJson(Map<String, dynamic> json) =
      _$TaskSuggestionImpl.fromJson;

  @override
  String get title;
  @override
  String get priority;
  @override // low, medium, high
  String get energy;
  @override // low, medium, high
  bool get selected;
  @override
  @JsonKey(ignore: true)
  _$$TaskSuggestionImplCopyWith<_$TaskSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
