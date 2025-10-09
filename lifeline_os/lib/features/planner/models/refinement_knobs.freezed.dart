// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refinement_knobs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefinementKnobs _$RefinementKnobsFromJson(Map<String, dynamic> json) {
  return _RefinementKnobs.fromJson(json);
}

/// @nodoc
mixin _$RefinementKnobs {
  bool get listOnly =>
      throw _privateConstructorUsedError; // Force bullet format, no justifications
  int get targetCount =>
      throw _privateConstructorUsedError; // Target number of items/lines
  bool get includeExamples =>
      throw _privateConstructorUsedError; // Add concrete examples
  List<String> get forbidPhrases =>
      throw _privateConstructorUsedError; // Banned words (for novelty)
  List<String> get mustInclude =>
      throw _privateConstructorUsedError; // Required terms
  double get temperature =>
      throw _privateConstructorUsedError; // LLM sampling temperature
  double get noveltyThreshold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefinementKnobsCopyWith<RefinementKnobs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefinementKnobsCopyWith<$Res> {
  factory $RefinementKnobsCopyWith(
          RefinementKnobs value, $Res Function(RefinementKnobs) then) =
      _$RefinementKnobsCopyWithImpl<$Res, RefinementKnobs>;
  @useResult
  $Res call(
      {bool listOnly,
      int targetCount,
      bool includeExamples,
      List<String> forbidPhrases,
      List<String> mustInclude,
      double temperature,
      double noveltyThreshold});
}

/// @nodoc
class _$RefinementKnobsCopyWithImpl<$Res, $Val extends RefinementKnobs>
    implements $RefinementKnobsCopyWith<$Res> {
  _$RefinementKnobsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listOnly = null,
    Object? targetCount = null,
    Object? includeExamples = null,
    Object? forbidPhrases = null,
    Object? mustInclude = null,
    Object? temperature = null,
    Object? noveltyThreshold = null,
  }) {
    return _then(_value.copyWith(
      listOnly: null == listOnly
          ? _value.listOnly
          : listOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      includeExamples: null == includeExamples
          ? _value.includeExamples
          : includeExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      forbidPhrases: null == forbidPhrases
          ? _value.forbidPhrases
          : forbidPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mustInclude: null == mustInclude
          ? _value.mustInclude
          : mustInclude // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      noveltyThreshold: null == noveltyThreshold
          ? _value.noveltyThreshold
          : noveltyThreshold // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefinementKnobsImplCopyWith<$Res>
    implements $RefinementKnobsCopyWith<$Res> {
  factory _$$RefinementKnobsImplCopyWith(_$RefinementKnobsImpl value,
          $Res Function(_$RefinementKnobsImpl) then) =
      __$$RefinementKnobsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool listOnly,
      int targetCount,
      bool includeExamples,
      List<String> forbidPhrases,
      List<String> mustInclude,
      double temperature,
      double noveltyThreshold});
}

/// @nodoc
class __$$RefinementKnobsImplCopyWithImpl<$Res>
    extends _$RefinementKnobsCopyWithImpl<$Res, _$RefinementKnobsImpl>
    implements _$$RefinementKnobsImplCopyWith<$Res> {
  __$$RefinementKnobsImplCopyWithImpl(
      _$RefinementKnobsImpl _value, $Res Function(_$RefinementKnobsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listOnly = null,
    Object? targetCount = null,
    Object? includeExamples = null,
    Object? forbidPhrases = null,
    Object? mustInclude = null,
    Object? temperature = null,
    Object? noveltyThreshold = null,
  }) {
    return _then(_$RefinementKnobsImpl(
      listOnly: null == listOnly
          ? _value.listOnly
          : listOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      includeExamples: null == includeExamples
          ? _value.includeExamples
          : includeExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      forbidPhrases: null == forbidPhrases
          ? _value._forbidPhrases
          : forbidPhrases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mustInclude: null == mustInclude
          ? _value._mustInclude
          : mustInclude // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      noveltyThreshold: null == noveltyThreshold
          ? _value.noveltyThreshold
          : noveltyThreshold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefinementKnobsImpl implements _RefinementKnobs {
  const _$RefinementKnobsImpl(
      {this.listOnly = false,
      this.targetCount = 8,
      this.includeExamples = false,
      final List<String> forbidPhrases = const [],
      final List<String> mustInclude = const [],
      this.temperature = 0.5,
      this.noveltyThreshold = 0.3})
      : _forbidPhrases = forbidPhrases,
        _mustInclude = mustInclude;

  factory _$RefinementKnobsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefinementKnobsImplFromJson(json);

  @override
  @JsonKey()
  final bool listOnly;
// Force bullet format, no justifications
  @override
  @JsonKey()
  final int targetCount;
// Target number of items/lines
  @override
  @JsonKey()
  final bool includeExamples;
// Add concrete examples
  final List<String> _forbidPhrases;
// Add concrete examples
  @override
  @JsonKey()
  List<String> get forbidPhrases {
    if (_forbidPhrases is EqualUnmodifiableListView) return _forbidPhrases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forbidPhrases);
  }

// Banned words (for novelty)
  final List<String> _mustInclude;
// Banned words (for novelty)
  @override
  @JsonKey()
  List<String> get mustInclude {
    if (_mustInclude is EqualUnmodifiableListView) return _mustInclude;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mustInclude);
  }

// Required terms
  @override
  @JsonKey()
  final double temperature;
// LLM sampling temperature
  @override
  @JsonKey()
  final double noveltyThreshold;

  @override
  String toString() {
    return 'RefinementKnobs(listOnly: $listOnly, targetCount: $targetCount, includeExamples: $includeExamples, forbidPhrases: $forbidPhrases, mustInclude: $mustInclude, temperature: $temperature, noveltyThreshold: $noveltyThreshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefinementKnobsImpl &&
            (identical(other.listOnly, listOnly) ||
                other.listOnly == listOnly) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.includeExamples, includeExamples) ||
                other.includeExamples == includeExamples) &&
            const DeepCollectionEquality()
                .equals(other._forbidPhrases, _forbidPhrases) &&
            const DeepCollectionEquality()
                .equals(other._mustInclude, _mustInclude) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.noveltyThreshold, noveltyThreshold) ||
                other.noveltyThreshold == noveltyThreshold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      listOnly,
      targetCount,
      includeExamples,
      const DeepCollectionEquality().hash(_forbidPhrases),
      const DeepCollectionEquality().hash(_mustInclude),
      temperature,
      noveltyThreshold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefinementKnobsImplCopyWith<_$RefinementKnobsImpl> get copyWith =>
      __$$RefinementKnobsImplCopyWithImpl<_$RefinementKnobsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefinementKnobsImplToJson(
      this,
    );
  }
}

abstract class _RefinementKnobs implements RefinementKnobs {
  const factory _RefinementKnobs(
      {final bool listOnly,
      final int targetCount,
      final bool includeExamples,
      final List<String> forbidPhrases,
      final List<String> mustInclude,
      final double temperature,
      final double noveltyThreshold}) = _$RefinementKnobsImpl;

  factory _RefinementKnobs.fromJson(Map<String, dynamic> json) =
      _$RefinementKnobsImpl.fromJson;

  @override
  bool get listOnly;
  @override // Force bullet format, no justifications
  int get targetCount;
  @override // Target number of items/lines
  bool get includeExamples;
  @override // Add concrete examples
  List<String> get forbidPhrases;
  @override // Banned words (for novelty)
  List<String> get mustInclude;
  @override // Required terms
  double get temperature;
  @override // LLM sampling temperature
  double get noveltyThreshold;
  @override
  @JsonKey(ignore: true)
  _$$RefinementKnobsImplCopyWith<_$RefinementKnobsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
