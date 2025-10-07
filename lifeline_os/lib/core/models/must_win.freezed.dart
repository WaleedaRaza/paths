// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'must_win.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MustWin _$MustWinFromJson(Map<String, dynamic> json) {
  return _MustWin.fromJson(json);
}

/// @nodoc
mixin _$MustWin {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MustWinCopyWith<MustWin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MustWinCopyWith<$Res> {
  factory $MustWinCopyWith(MustWin value, $Res Function(MustWin) then) =
      _$MustWinCopyWithImpl<$Res, MustWin>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? taskId,
      String title,
      bool isCompleted,
      DateTime? completedAt,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class _$MustWinCopyWithImpl<$Res, $Val extends MustWin>
    implements $MustWinCopyWith<$Res> {
  _$MustWinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? taskId = freezed,
    Object? title = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$MustWinImplCopyWith<$Res> implements $MustWinCopyWith<$Res> {
  factory _$$MustWinImplCopyWith(
          _$MustWinImpl value, $Res Function(_$MustWinImpl) then) =
      __$$MustWinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? taskId,
      String title,
      bool isCompleted,
      DateTime? completedAt,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class __$$MustWinImplCopyWithImpl<$Res>
    extends _$MustWinCopyWithImpl<$Res, _$MustWinImpl>
    implements _$$MustWinImplCopyWith<$Res> {
  __$$MustWinImplCopyWithImpl(
      _$MustWinImpl _value, $Res Function(_$MustWinImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? taskId = freezed,
    Object? title = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_$MustWinImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$MustWinImpl implements _MustWin {
  const _$MustWinImpl(
      {required this.id,
      required this.date,
      this.taskId,
      required this.title,
      this.isCompleted = false,
      this.completedAt,
      this.sortOrder = 0,
      required this.createdAt});

  factory _$MustWinImpl.fromJson(Map<String, dynamic> json) =>
      _$$MustWinImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String? taskId;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MustWin(id: $id, date: $date, taskId: $taskId, title: $title, isCompleted: $isCompleted, completedAt: $completedAt, sortOrder: $sortOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MustWinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, taskId, title,
      isCompleted, completedAt, sortOrder, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MustWinImplCopyWith<_$MustWinImpl> get copyWith =>
      __$$MustWinImplCopyWithImpl<_$MustWinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MustWinImplToJson(
      this,
    );
  }
}

abstract class _MustWin implements MustWin {
  const factory _MustWin(
      {required final String id,
      required final DateTime date,
      final String? taskId,
      required final String title,
      final bool isCompleted,
      final DateTime? completedAt,
      final int sortOrder,
      required final DateTime createdAt}) = _$MustWinImpl;

  factory _MustWin.fromJson(Map<String, dynamic> json) = _$MustWinImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String? get taskId;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  int get sortOrder;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MustWinImplCopyWith<_$MustWinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
