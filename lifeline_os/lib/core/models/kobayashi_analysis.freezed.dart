// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kobayashi_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KobayashiAnalysis _$KobayashiAnalysisFromJson(Map<String, dynamic> json) {
  return _KobayashiAnalysis.fromJson(json);
}

/// @nodoc
mixin _$KobayashiAnalysis {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  int get overallScore => throw _privateConstructorUsedError;
  List<String> get strengths => throw _privateConstructorUsedError;
  List<String> get weaknesses => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  String get transcript => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KobayashiAnalysisCopyWith<KobayashiAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KobayashiAnalysisCopyWith<$Res> {
  factory $KobayashiAnalysisCopyWith(
          KobayashiAnalysis value, $Res Function(KobayashiAnalysis) then) =
      _$KobayashiAnalysisCopyWithImpl<$Res, KobayashiAnalysis>;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      int overallScore,
      List<String> strengths,
      List<String> weaknesses,
      List<String> recommendations,
      String transcript,
      DateTime createdAt});
}

/// @nodoc
class _$KobayashiAnalysisCopyWithImpl<$Res, $Val extends KobayashiAnalysis>
    implements $KobayashiAnalysisCopyWith<$Res> {
  _$KobayashiAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? overallScore = null,
    Object? strengths = null,
    Object? weaknesses = null,
    Object? recommendations = null,
    Object? transcript = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      strengths: null == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weaknesses: null == weaknesses
          ? _value.weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      transcript: null == transcript
          ? _value.transcript
          : transcript // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KobayashiAnalysisImplCopyWith<$Res>
    implements $KobayashiAnalysisCopyWith<$Res> {
  factory _$$KobayashiAnalysisImplCopyWith(_$KobayashiAnalysisImpl value,
          $Res Function(_$KobayashiAnalysisImpl) then) =
      __$$KobayashiAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      int overallScore,
      List<String> strengths,
      List<String> weaknesses,
      List<String> recommendations,
      String transcript,
      DateTime createdAt});
}

/// @nodoc
class __$$KobayashiAnalysisImplCopyWithImpl<$Res>
    extends _$KobayashiAnalysisCopyWithImpl<$Res, _$KobayashiAnalysisImpl>
    implements _$$KobayashiAnalysisImplCopyWith<$Res> {
  __$$KobayashiAnalysisImplCopyWithImpl(_$KobayashiAnalysisImpl _value,
      $Res Function(_$KobayashiAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? overallScore = null,
    Object? strengths = null,
    Object? weaknesses = null,
    Object? recommendations = null,
    Object? transcript = null,
    Object? createdAt = null,
  }) {
    return _then(_$KobayashiAnalysisImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      strengths: null == strengths
          ? _value._strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weaknesses: null == weaknesses
          ? _value._weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      transcript: null == transcript
          ? _value.transcript
          : transcript // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KobayashiAnalysisImpl implements _KobayashiAnalysis {
  const _$KobayashiAnalysisImpl(
      {required this.id,
      required this.sessionId,
      required this.overallScore,
      required final List<String> strengths,
      required final List<String> weaknesses,
      required final List<String> recommendations,
      required this.transcript,
      required this.createdAt})
      : _strengths = strengths,
        _weaknesses = weaknesses,
        _recommendations = recommendations;

  factory _$KobayashiAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$KobayashiAnalysisImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final int overallScore;
  final List<String> _strengths;
  @override
  List<String> get strengths {
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strengths);
  }

  final List<String> _weaknesses;
  @override
  List<String> get weaknesses {
    if (_weaknesses is EqualUnmodifiableListView) return _weaknesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weaknesses);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final String transcript;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'KobayashiAnalysis(id: $id, sessionId: $sessionId, overallScore: $overallScore, strengths: $strengths, weaknesses: $weaknesses, recommendations: $recommendations, transcript: $transcript, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KobayashiAnalysisImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            const DeepCollectionEquality()
                .equals(other._strengths, _strengths) &&
            const DeepCollectionEquality()
                .equals(other._weaknesses, _weaknesses) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.transcript, transcript) ||
                other.transcript == transcript) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      overallScore,
      const DeepCollectionEquality().hash(_strengths),
      const DeepCollectionEquality().hash(_weaknesses),
      const DeepCollectionEquality().hash(_recommendations),
      transcript,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KobayashiAnalysisImplCopyWith<_$KobayashiAnalysisImpl> get copyWith =>
      __$$KobayashiAnalysisImplCopyWithImpl<_$KobayashiAnalysisImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KobayashiAnalysisImplToJson(
      this,
    );
  }
}

abstract class _KobayashiAnalysis implements KobayashiAnalysis {
  const factory _KobayashiAnalysis(
      {required final String id,
      required final String sessionId,
      required final int overallScore,
      required final List<String> strengths,
      required final List<String> weaknesses,
      required final List<String> recommendations,
      required final String transcript,
      required final DateTime createdAt}) = _$KobayashiAnalysisImpl;

  factory _KobayashiAnalysis.fromJson(Map<String, dynamic> json) =
      _$KobayashiAnalysisImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  int get overallScore;
  @override
  List<String> get strengths;
  @override
  List<String> get weaknesses;
  @override
  List<String> get recommendations;
  @override
  String get transcript;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$KobayashiAnalysisImplCopyWith<_$KobayashiAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
