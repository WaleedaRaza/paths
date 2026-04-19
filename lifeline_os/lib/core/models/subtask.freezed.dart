// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtask.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subtask _$SubtaskFromJson(Map<String, dynamic> json) {
  return _Subtask.fromJson(json);
}

/// @nodoc
mixin _$Subtask {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubtaskCopyWith<Subtask> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtaskCopyWith<$Res> {
  factory $SubtaskCopyWith(Subtask value, $Res Function(Subtask) then) =
      _$SubtaskCopyWithImpl<$Res, Subtask>;
  @useResult
  $Res call(
      {String id,
      String taskId,
      String title,
      bool isCompleted,
      DateTime? completedAt,
      int points,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class _$SubtaskCopyWithImpl<$Res, $Val extends Subtask>
    implements $SubtaskCopyWith<$Res> {
  _$SubtaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? points = null,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubtaskImplCopyWith<$Res> implements $SubtaskCopyWith<$Res> {
  factory _$$SubtaskImplCopyWith(
          _$SubtaskImpl value, $Res Function(_$SubtaskImpl) then) =
      __$$SubtaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String taskId,
      String title,
      bool isCompleted,
      DateTime? completedAt,
      int points,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class __$$SubtaskImplCopyWithImpl<$Res>
    extends _$SubtaskCopyWithImpl<$Res, _$SubtaskImpl>
    implements _$$SubtaskImplCopyWith<$Res> {
  __$$SubtaskImplCopyWithImpl(
      _$SubtaskImpl _value, $Res Function(_$SubtaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? points = null,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_$SubtaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubtaskImpl implements _Subtask {
  const _$SubtaskImpl(
      {required this.id,
      required this.taskId,
      required this.title,
      this.isCompleted = false,
      this.completedAt,
      this.points = 5,
      this.sortOrder = 0,
      required this.createdAt});

  factory _$SubtaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubtaskImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Subtask(id: $id, taskId: $taskId, title: $title, isCompleted: $isCompleted, completedAt: $completedAt, points: $points, sortOrder: $sortOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubtaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, title, isCompleted,
      completedAt, points, sortOrder, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubtaskImplCopyWith<_$SubtaskImpl> get copyWith =>
      __$$SubtaskImplCopyWithImpl<_$SubtaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubtaskImplToJson(
      this,
    );
  }
}

abstract class _Subtask implements Subtask {
  const factory _Subtask(
      {required final String id,
      required final String taskId,
      required final String title,
      final bool isCompleted,
      final DateTime? completedAt,
      final int points,
      final int sortOrder,
      required final DateTime createdAt}) = _$SubtaskImpl;

  factory _Subtask.fromJson(Map<String, dynamic> json) = _$SubtaskImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  int get points;
  @override
  int get sortOrder;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SubtaskImplCopyWith<_$SubtaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
