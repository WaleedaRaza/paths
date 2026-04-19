// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refinement_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefinementSuggestion _$RefinementSuggestionFromJson(Map<String, dynamic> json) {
  return _RefinementSuggestion.fromJson(json);
}

/// @nodoc
mixin _$RefinementSuggestion {
  String get action =>
      throw _privateConstructorUsedError; // 'expand', 'regenerate', 'simplify'
  String get fieldName => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  List<String> get guidance =>
      throw _privateConstructorUsedError; // Changed from String to List
  List<String> get proposedContentLines =>
      throw _privateConstructorUsedError; // Changed from proposedContent String to array
  String? get reasoning => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefinementSuggestionCopyWith<RefinementSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefinementSuggestionCopyWith<$Res> {
  factory $RefinementSuggestionCopyWith(RefinementSuggestion value,
          $Res Function(RefinementSuggestion) then) =
      _$RefinementSuggestionCopyWithImpl<$Res, RefinementSuggestion>;
  @useResult
  $Res call(
      {String action,
      String fieldName,
      String notes,
      List<String> guidance,
      List<String> proposedContentLines,
      String? reasoning});
}

/// @nodoc
class _$RefinementSuggestionCopyWithImpl<$Res,
        $Val extends RefinementSuggestion>
    implements $RefinementSuggestionCopyWith<$Res> {
  _$RefinementSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? fieldName = null,
    Object? notes = null,
    Object? guidance = null,
    Object? proposedContentLines = null,
    Object? reasoning = freezed,
  }) {
    return _then(_value.copyWith(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      guidance: null == guidance
          ? _value.guidance
          : guidance // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proposedContentLines: null == proposedContentLines
          ? _value.proposedContentLines
          : proposedContentLines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefinementSuggestionImplCopyWith<$Res>
    implements $RefinementSuggestionCopyWith<$Res> {
  factory _$$RefinementSuggestionImplCopyWith(_$RefinementSuggestionImpl value,
          $Res Function(_$RefinementSuggestionImpl) then) =
      __$$RefinementSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String action,
      String fieldName,
      String notes,
      List<String> guidance,
      List<String> proposedContentLines,
      String? reasoning});
}

/// @nodoc
class __$$RefinementSuggestionImplCopyWithImpl<$Res>
    extends _$RefinementSuggestionCopyWithImpl<$Res, _$RefinementSuggestionImpl>
    implements _$$RefinementSuggestionImplCopyWith<$Res> {
  __$$RefinementSuggestionImplCopyWithImpl(_$RefinementSuggestionImpl _value,
      $Res Function(_$RefinementSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? fieldName = null,
    Object? notes = null,
    Object? guidance = null,
    Object? proposedContentLines = null,
    Object? reasoning = freezed,
  }) {
    return _then(_$RefinementSuggestionImpl(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      guidance: null == guidance
          ? _value._guidance
          : guidance // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proposedContentLines: null == proposedContentLines
          ? _value._proposedContentLines
          : proposedContentLines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefinementSuggestionImpl implements _RefinementSuggestion {
  const _$RefinementSuggestionImpl(
      {required this.action,
      required this.fieldName,
      required this.notes,
      required final List<String> guidance,
      required final List<String> proposedContentLines,
      this.reasoning})
      : _guidance = guidance,
        _proposedContentLines = proposedContentLines;

  factory _$RefinementSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefinementSuggestionImplFromJson(json);

  @override
  final String action;
// 'expand', 'regenerate', 'simplify'
  @override
  final String fieldName;
  @override
  final String notes;
  final List<String> _guidance;
  @override
  List<String> get guidance {
    if (_guidance is EqualUnmodifiableListView) return _guidance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guidance);
  }

// Changed from String to List
  final List<String> _proposedContentLines;
// Changed from String to List
  @override
  List<String> get proposedContentLines {
    if (_proposedContentLines is EqualUnmodifiableListView)
      return _proposedContentLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_proposedContentLines);
  }

// Changed from proposedContent String to array
  @override
  final String? reasoning;

  @override
  String toString() {
    return 'RefinementSuggestion(action: $action, fieldName: $fieldName, notes: $notes, guidance: $guidance, proposedContentLines: $proposedContentLines, reasoning: $reasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefinementSuggestionImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._guidance, _guidance) &&
            const DeepCollectionEquality()
                .equals(other._proposedContentLines, _proposedContentLines) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      action,
      fieldName,
      notes,
      const DeepCollectionEquality().hash(_guidance),
      const DeepCollectionEquality().hash(_proposedContentLines),
      reasoning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefinementSuggestionImplCopyWith<_$RefinementSuggestionImpl>
      get copyWith =>
          __$$RefinementSuggestionImplCopyWithImpl<_$RefinementSuggestionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefinementSuggestionImplToJson(
      this,
    );
  }
}

abstract class _RefinementSuggestion implements RefinementSuggestion {
  const factory _RefinementSuggestion(
      {required final String action,
      required final String fieldName,
      required final String notes,
      required final List<String> guidance,
      required final List<String> proposedContentLines,
      final String? reasoning}) = _$RefinementSuggestionImpl;

  factory _RefinementSuggestion.fromJson(Map<String, dynamic> json) =
      _$RefinementSuggestionImpl.fromJson;

  @override
  String get action;
  @override // 'expand', 'regenerate', 'simplify'
  String get fieldName;
  @override
  String get notes;
  @override
  List<String> get guidance;
  @override // Changed from String to List
  List<String> get proposedContentLines;
  @override // Changed from proposedContent String to array
  String? get reasoning;
  @override
  @JsonKey(ignore: true)
  _$$RefinementSuggestionImplCopyWith<_$RefinementSuggestionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
