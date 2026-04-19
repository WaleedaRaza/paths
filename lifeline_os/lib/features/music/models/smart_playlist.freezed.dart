// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartPlaylist _$SmartPlaylistFromJson(Map<String, dynamic> json) {
  return _SmartPlaylist.fromJson(json);
}

/// @nodoc
mixin _$SmartPlaylist {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PlaylistCriteria get criteria => throw _privateConstructorUsedError;
  List<String> get trackIds => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get lastGenerated => throw _privateConstructorUsedError;
  int get timesPlayed => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmartPlaylistCopyWith<SmartPlaylist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartPlaylistCopyWith<$Res> {
  factory $SmartPlaylistCopyWith(
          SmartPlaylist value, $Res Function(SmartPlaylist) then) =
      _$SmartPlaylistCopyWithImpl<$Res, SmartPlaylist>;
  @useResult
  $Res call(
      {String id,
      String name,
      PlaylistCriteria criteria,
      List<String> trackIds,
      String? description,
      DateTime lastGenerated,
      int timesPlayed,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class _$SmartPlaylistCopyWithImpl<$Res, $Val extends SmartPlaylist>
    implements $SmartPlaylistCopyWith<$Res> {
  _$SmartPlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? criteria = null,
    Object? trackIds = null,
    Object? description = freezed,
    Object? lastGenerated = null,
    Object? timesPlayed = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as PlaylistCriteria,
      trackIds: null == trackIds
          ? _value.trackIds
          : trackIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerated: null == lastGenerated
          ? _value.lastGenerated
          : lastGenerated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timesPlayed: null == timesPlayed
          ? _value.timesPlayed
          : timesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartPlaylistImplCopyWith<$Res>
    implements $SmartPlaylistCopyWith<$Res> {
  factory _$$SmartPlaylistImplCopyWith(
          _$SmartPlaylistImpl value, $Res Function(_$SmartPlaylistImpl) then) =
      __$$SmartPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      PlaylistCriteria criteria,
      List<String> trackIds,
      String? description,
      DateTime lastGenerated,
      int timesPlayed,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class __$$SmartPlaylistImplCopyWithImpl<$Res>
    extends _$SmartPlaylistCopyWithImpl<$Res, _$SmartPlaylistImpl>
    implements _$$SmartPlaylistImplCopyWith<$Res> {
  __$$SmartPlaylistImplCopyWithImpl(
      _$SmartPlaylistImpl _value, $Res Function(_$SmartPlaylistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? criteria = null,
    Object? trackIds = null,
    Object? description = freezed,
    Object? lastGenerated = null,
    Object? timesPlayed = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$SmartPlaylistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as PlaylistCriteria,
      trackIds: null == trackIds
          ? _value._trackIds
          : trackIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastGenerated: null == lastGenerated
          ? _value.lastGenerated
          : lastGenerated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timesPlayed: null == timesPlayed
          ? _value.timesPlayed
          : timesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartPlaylistImpl implements _SmartPlaylist {
  const _$SmartPlaylistImpl(
      {required this.id,
      required this.name,
      required this.criteria,
      required final List<String> trackIds,
      this.description,
      required this.lastGenerated,
      required this.timesPlayed,
      required this.isActive,
      required this.createdAt})
      : _trackIds = trackIds;

  factory _$SmartPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartPlaylistImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final PlaylistCriteria criteria;
  final List<String> _trackIds;
  @override
  List<String> get trackIds {
    if (_trackIds is EqualUnmodifiableListView) return _trackIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trackIds);
  }

  @override
  final String? description;
  @override
  final DateTime lastGenerated;
  @override
  final int timesPlayed;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SmartPlaylist(id: $id, name: $name, criteria: $criteria, trackIds: $trackIds, description: $description, lastGenerated: $lastGenerated, timesPlayed: $timesPlayed, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartPlaylistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            const DeepCollectionEquality().equals(other._trackIds, _trackIds) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lastGenerated, lastGenerated) ||
                other.lastGenerated == lastGenerated) &&
            (identical(other.timesPlayed, timesPlayed) ||
                other.timesPlayed == timesPlayed) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      criteria,
      const DeepCollectionEquality().hash(_trackIds),
      description,
      lastGenerated,
      timesPlayed,
      isActive,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartPlaylistImplCopyWith<_$SmartPlaylistImpl> get copyWith =>
      __$$SmartPlaylistImplCopyWithImpl<_$SmartPlaylistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartPlaylistImplToJson(
      this,
    );
  }
}

abstract class _SmartPlaylist implements SmartPlaylist {
  const factory _SmartPlaylist(
      {required final String id,
      required final String name,
      required final PlaylistCriteria criteria,
      required final List<String> trackIds,
      final String? description,
      required final DateTime lastGenerated,
      required final int timesPlayed,
      required final bool isActive,
      required final DateTime createdAt}) = _$SmartPlaylistImpl;

  factory _SmartPlaylist.fromJson(Map<String, dynamic> json) =
      _$SmartPlaylistImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  PlaylistCriteria get criteria;
  @override
  List<String> get trackIds;
  @override
  String? get description;
  @override
  DateTime get lastGenerated;
  @override
  int get timesPlayed;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SmartPlaylistImplCopyWith<_$SmartPlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MusicInsight _$MusicInsightFromJson(Map<String, dynamic> json) {
  return _MusicInsight.fromJson(json);
}

/// @nodoc
mixin _$MusicInsight {
  String get id => throw _privateConstructorUsedError;
  DateTime get weekOf => throw _privateConstructorUsedError;
  String get llmAnalysis => throw _privateConstructorUsedError;
  Map<String, dynamic> get dataSnapshot => throw _privateConstructorUsedError;
  bool get hasBeenRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MusicInsightCopyWith<MusicInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MusicInsightCopyWith<$Res> {
  factory $MusicInsightCopyWith(
          MusicInsight value, $Res Function(MusicInsight) then) =
      _$MusicInsightCopyWithImpl<$Res, MusicInsight>;
  @useResult
  $Res call(
      {String id,
      DateTime weekOf,
      String llmAnalysis,
      Map<String, dynamic> dataSnapshot,
      bool hasBeenRead,
      DateTime createdAt});
}

/// @nodoc
class _$MusicInsightCopyWithImpl<$Res, $Val extends MusicInsight>
    implements $MusicInsightCopyWith<$Res> {
  _$MusicInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekOf = null,
    Object? llmAnalysis = null,
    Object? dataSnapshot = null,
    Object? hasBeenRead = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekOf: null == weekOf
          ? _value.weekOf
          : weekOf // ignore: cast_nullable_to_non_nullable
              as DateTime,
      llmAnalysis: null == llmAnalysis
          ? _value.llmAnalysis
          : llmAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      dataSnapshot: null == dataSnapshot
          ? _value.dataSnapshot
          : dataSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      hasBeenRead: null == hasBeenRead
          ? _value.hasBeenRead
          : hasBeenRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MusicInsightImplCopyWith<$Res>
    implements $MusicInsightCopyWith<$Res> {
  factory _$$MusicInsightImplCopyWith(
          _$MusicInsightImpl value, $Res Function(_$MusicInsightImpl) then) =
      __$$MusicInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime weekOf,
      String llmAnalysis,
      Map<String, dynamic> dataSnapshot,
      bool hasBeenRead,
      DateTime createdAt});
}

/// @nodoc
class __$$MusicInsightImplCopyWithImpl<$Res>
    extends _$MusicInsightCopyWithImpl<$Res, _$MusicInsightImpl>
    implements _$$MusicInsightImplCopyWith<$Res> {
  __$$MusicInsightImplCopyWithImpl(
      _$MusicInsightImpl _value, $Res Function(_$MusicInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekOf = null,
    Object? llmAnalysis = null,
    Object? dataSnapshot = null,
    Object? hasBeenRead = null,
    Object? createdAt = null,
  }) {
    return _then(_$MusicInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekOf: null == weekOf
          ? _value.weekOf
          : weekOf // ignore: cast_nullable_to_non_nullable
              as DateTime,
      llmAnalysis: null == llmAnalysis
          ? _value.llmAnalysis
          : llmAnalysis // ignore: cast_nullable_to_non_nullable
              as String,
      dataSnapshot: null == dataSnapshot
          ? _value._dataSnapshot
          : dataSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      hasBeenRead: null == hasBeenRead
          ? _value.hasBeenRead
          : hasBeenRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MusicInsightImpl implements _MusicInsight {
  const _$MusicInsightImpl(
      {required this.id,
      required this.weekOf,
      required this.llmAnalysis,
      required final Map<String, dynamic> dataSnapshot,
      required this.hasBeenRead,
      required this.createdAt})
      : _dataSnapshot = dataSnapshot;

  factory _$MusicInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$MusicInsightImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime weekOf;
  @override
  final String llmAnalysis;
  final Map<String, dynamic> _dataSnapshot;
  @override
  Map<String, dynamic> get dataSnapshot {
    if (_dataSnapshot is EqualUnmodifiableMapView) return _dataSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dataSnapshot);
  }

  @override
  final bool hasBeenRead;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MusicInsight(id: $id, weekOf: $weekOf, llmAnalysis: $llmAnalysis, dataSnapshot: $dataSnapshot, hasBeenRead: $hasBeenRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MusicInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekOf, weekOf) || other.weekOf == weekOf) &&
            (identical(other.llmAnalysis, llmAnalysis) ||
                other.llmAnalysis == llmAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._dataSnapshot, _dataSnapshot) &&
            (identical(other.hasBeenRead, hasBeenRead) ||
                other.hasBeenRead == hasBeenRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      weekOf,
      llmAnalysis,
      const DeepCollectionEquality().hash(_dataSnapshot),
      hasBeenRead,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MusicInsightImplCopyWith<_$MusicInsightImpl> get copyWith =>
      __$$MusicInsightImplCopyWithImpl<_$MusicInsightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MusicInsightImplToJson(
      this,
    );
  }
}

abstract class _MusicInsight implements MusicInsight {
  const factory _MusicInsight(
      {required final String id,
      required final DateTime weekOf,
      required final String llmAnalysis,
      required final Map<String, dynamic> dataSnapshot,
      required final bool hasBeenRead,
      required final DateTime createdAt}) = _$MusicInsightImpl;

  factory _MusicInsight.fromJson(Map<String, dynamic> json) =
      _$MusicInsightImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get weekOf;
  @override
  String get llmAnalysis;
  @override
  Map<String, dynamic> get dataSnapshot;
  @override
  bool get hasBeenRead;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MusicInsightImplCopyWith<_$MusicInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotifyToken _$SpotifyTokenFromJson(Map<String, dynamic> json) {
  return _SpotifyToken.fromJson(json);
}

/// @nodoc
mixin _$SpotifyToken {
  String get id => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String get scope => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyTokenCopyWith<SpotifyToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyTokenCopyWith<$Res> {
  factory $SpotifyTokenCopyWith(
          SpotifyToken value, $Res Function(SpotifyToken) then) =
      _$SpotifyTokenCopyWithImpl<$Res, SpotifyToken>;
  @useResult
  $Res call(
      {String id,
      String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      DateTime expiresAt,
      String scope,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SpotifyTokenCopyWithImpl<$Res, $Val extends SpotifyToken>
    implements $SpotifyTokenCopyWith<$Res> {
  _$SpotifyTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? scope = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyTokenImplCopyWith<$Res>
    implements $SpotifyTokenCopyWith<$Res> {
  factory _$$SpotifyTokenImplCopyWith(
          _$SpotifyTokenImpl value, $Res Function(_$SpotifyTokenImpl) then) =
      __$$SpotifyTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String accessToken,
      String refreshToken,
      String tokenType,
      int expiresIn,
      DateTime expiresAt,
      String scope,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$SpotifyTokenImplCopyWithImpl<$Res>
    extends _$SpotifyTokenCopyWithImpl<$Res, _$SpotifyTokenImpl>
    implements _$$SpotifyTokenImplCopyWith<$Res> {
  __$$SpotifyTokenImplCopyWithImpl(
      _$SpotifyTokenImpl _value, $Res Function(_$SpotifyTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? scope = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SpotifyTokenImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyTokenImpl implements _SpotifyToken {
  const _$SpotifyTokenImpl(
      {required this.id,
      required this.accessToken,
      required this.refreshToken,
      required this.tokenType,
      required this.expiresIn,
      required this.expiresAt,
      required this.scope,
      required this.createdAt,
      required this.updatedAt});

  factory _$SpotifyTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyTokenImplFromJson(json);

  @override
  final String id;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final String tokenType;
  @override
  final int expiresIn;
  @override
  final DateTime expiresAt;
  @override
  final String scope;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SpotifyToken(id: $id, accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, expiresAt: $expiresAt, scope: $scope, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyTokenImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, accessToken, refreshToken,
      tokenType, expiresIn, expiresAt, scope, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyTokenImplCopyWith<_$SpotifyTokenImpl> get copyWith =>
      __$$SpotifyTokenImplCopyWithImpl<_$SpotifyTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyTokenImplToJson(
      this,
    );
  }
}

abstract class _SpotifyToken implements SpotifyToken {
  const factory _SpotifyToken(
      {required final String id,
      required final String accessToken,
      required final String refreshToken,
      required final String tokenType,
      required final int expiresIn,
      required final DateTime expiresAt,
      required final String scope,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$SpotifyTokenImpl;

  factory _SpotifyToken.fromJson(Map<String, dynamic> json) =
      _$SpotifyTokenImpl.fromJson;

  @override
  String get id;
  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  String get tokenType;
  @override
  int get expiresIn;
  @override
  DateTime get expiresAt;
  @override
  String get scope;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyTokenImplCopyWith<_$SpotifyTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
