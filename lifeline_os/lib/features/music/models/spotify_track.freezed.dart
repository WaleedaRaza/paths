// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifyTrack _$SpotifyTrackFromJson(Map<String, dynamic> json) {
  return _SpotifyTrack.fromJson(json);
}

/// @nodoc
mixin _$SpotifyTrack {
  String get id => throw _privateConstructorUsedError;
  String get trackId => throw _privateConstructorUsedError;
  String get trackName => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  String get albumName => throw _privateConstructorUsedError;
  String get albumId => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  DateTime get playedAt => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;
  String? get playedDuringTaskId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyTrackCopyWith<SpotifyTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyTrackCopyWith<$Res> {
  factory $SpotifyTrackCopyWith(
          SpotifyTrack value, $Res Function(SpotifyTrack) then) =
      _$SpotifyTrackCopyWithImpl<$Res, SpotifyTrack>;
  @useResult
  $Res call(
      {String id,
      String trackId,
      String trackName,
      String artistName,
      String artistId,
      String albumName,
      String albumId,
      List<String> genres,
      DateTime playedAt,
      int durationMs,
      String? context,
      String? playedDuringTaskId,
      DateTime createdAt});
}

/// @nodoc
class _$SpotifyTrackCopyWithImpl<$Res, $Val extends SpotifyTrack>
    implements $SpotifyTrackCopyWith<$Res> {
  _$SpotifyTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackId = null,
    Object? trackName = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? genres = null,
    Object? playedAt = null,
    Object? durationMs = null,
    Object? context = freezed,
    Object? playedDuringTaskId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      playedDuringTaskId: freezed == playedDuringTaskId
          ? _value.playedDuringTaskId
          : playedDuringTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyTrackImplCopyWith<$Res>
    implements $SpotifyTrackCopyWith<$Res> {
  factory _$$SpotifyTrackImplCopyWith(
          _$SpotifyTrackImpl value, $Res Function(_$SpotifyTrackImpl) then) =
      __$$SpotifyTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trackId,
      String trackName,
      String artistName,
      String artistId,
      String albumName,
      String albumId,
      List<String> genres,
      DateTime playedAt,
      int durationMs,
      String? context,
      String? playedDuringTaskId,
      DateTime createdAt});
}

/// @nodoc
class __$$SpotifyTrackImplCopyWithImpl<$Res>
    extends _$SpotifyTrackCopyWithImpl<$Res, _$SpotifyTrackImpl>
    implements _$$SpotifyTrackImplCopyWith<$Res> {
  __$$SpotifyTrackImplCopyWithImpl(
      _$SpotifyTrackImpl _value, $Res Function(_$SpotifyTrackImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackId = null,
    Object? trackName = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? genres = null,
    Object? playedAt = null,
    Object? durationMs = null,
    Object? context = freezed,
    Object? playedDuringTaskId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$SpotifyTrackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      playedDuringTaskId: freezed == playedDuringTaskId
          ? _value.playedDuringTaskId
          : playedDuringTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyTrackImpl implements _SpotifyTrack {
  const _$SpotifyTrackImpl(
      {required this.id,
      required this.trackId,
      required this.trackName,
      required this.artistName,
      required this.artistId,
      required this.albumName,
      required this.albumId,
      required final List<String> genres,
      required this.playedAt,
      required this.durationMs,
      this.context,
      this.playedDuringTaskId,
      required this.createdAt})
      : _genres = genres;

  factory _$SpotifyTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyTrackImplFromJson(json);

  @override
  final String id;
  @override
  final String trackId;
  @override
  final String trackName;
  @override
  final String artistName;
  @override
  final String artistId;
  @override
  final String albumName;
  @override
  final String albumId;
  final List<String> _genres;
  @override
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final DateTime playedAt;
  @override
  final int durationMs;
  @override
  final String? context;
  @override
  final String? playedDuringTaskId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SpotifyTrack(id: $id, trackId: $trackId, trackName: $trackName, artistName: $artistName, artistId: $artistId, albumName: $albumName, albumId: $albumId, genres: $genres, playedAt: $playedAt, durationMs: $durationMs, context: $context, playedDuringTaskId: $playedDuringTaskId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.trackName, trackName) ||
                other.trackName == trackName) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.playedDuringTaskId, playedDuringTaskId) ||
                other.playedDuringTaskId == playedDuringTaskId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      trackId,
      trackName,
      artistName,
      artistId,
      albumName,
      albumId,
      const DeepCollectionEquality().hash(_genres),
      playedAt,
      durationMs,
      context,
      playedDuringTaskId,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyTrackImplCopyWith<_$SpotifyTrackImpl> get copyWith =>
      __$$SpotifyTrackImplCopyWithImpl<_$SpotifyTrackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyTrackImplToJson(
      this,
    );
  }
}

abstract class _SpotifyTrack implements SpotifyTrack {
  const factory _SpotifyTrack(
      {required final String id,
      required final String trackId,
      required final String trackName,
      required final String artistName,
      required final String artistId,
      required final String albumName,
      required final String albumId,
      required final List<String> genres,
      required final DateTime playedAt,
      required final int durationMs,
      final String? context,
      final String? playedDuringTaskId,
      required final DateTime createdAt}) = _$SpotifyTrackImpl;

  factory _SpotifyTrack.fromJson(Map<String, dynamic> json) =
      _$SpotifyTrackImpl.fromJson;

  @override
  String get id;
  @override
  String get trackId;
  @override
  String get trackName;
  @override
  String get artistName;
  @override
  String get artistId;
  @override
  String get albumName;
  @override
  String get albumId;
  @override
  List<String> get genres;
  @override
  DateTime get playedAt;
  @override
  int get durationMs;
  @override
  String? get context;
  @override
  String? get playedDuringTaskId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyTrackImplCopyWith<_$SpotifyTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotifyArtist _$SpotifyArtistFromJson(Map<String, dynamic> json) {
  return _SpotifyArtist.fromJson(json);
}

/// @nodoc
mixin _$SpotifyArtist {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int? get popularity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyArtistCopyWith<SpotifyArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyArtistCopyWith<$Res> {
  factory $SpotifyArtistCopyWith(
          SpotifyArtist value, $Res Function(SpotifyArtist) then) =
      _$SpotifyArtistCopyWithImpl<$Res, SpotifyArtist>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> genres,
      String? imageUrl,
      int? popularity});
}

/// @nodoc
class _$SpotifyArtistCopyWithImpl<$Res, $Val extends SpotifyArtist>
    implements $SpotifyArtistCopyWith<$Res> {
  _$SpotifyArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? genres = null,
    Object? imageUrl = freezed,
    Object? popularity = freezed,
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
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyArtistImplCopyWith<$Res>
    implements $SpotifyArtistCopyWith<$Res> {
  factory _$$SpotifyArtistImplCopyWith(
          _$SpotifyArtistImpl value, $Res Function(_$SpotifyArtistImpl) then) =
      __$$SpotifyArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> genres,
      String? imageUrl,
      int? popularity});
}

/// @nodoc
class __$$SpotifyArtistImplCopyWithImpl<$Res>
    extends _$SpotifyArtistCopyWithImpl<$Res, _$SpotifyArtistImpl>
    implements _$$SpotifyArtistImplCopyWith<$Res> {
  __$$SpotifyArtistImplCopyWithImpl(
      _$SpotifyArtistImpl _value, $Res Function(_$SpotifyArtistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? genres = null,
    Object? imageUrl = freezed,
    Object? popularity = freezed,
  }) {
    return _then(_$SpotifyArtistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyArtistImpl implements _SpotifyArtist {
  const _$SpotifyArtistImpl(
      {required this.id,
      required this.name,
      required final List<String> genres,
      this.imageUrl,
      this.popularity})
      : _genres = genres;

  factory _$SpotifyArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyArtistImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _genres;
  @override
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final String? imageUrl;
  @override
  final int? popularity;

  @override
  String toString() {
    return 'SpotifyArtist(id: $id, name: $name, genres: $genres, imageUrl: $imageUrl, popularity: $popularity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyArtistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_genres), imageUrl, popularity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyArtistImplCopyWith<_$SpotifyArtistImpl> get copyWith =>
      __$$SpotifyArtistImplCopyWithImpl<_$SpotifyArtistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyArtistImplToJson(
      this,
    );
  }
}

abstract class _SpotifyArtist implements SpotifyArtist {
  const factory _SpotifyArtist(
      {required final String id,
      required final String name,
      required final List<String> genres,
      final String? imageUrl,
      final int? popularity}) = _$SpotifyArtistImpl;

  factory _SpotifyArtist.fromJson(Map<String, dynamic> json) =
      _$SpotifyArtistImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get genres;
  @override
  String? get imageUrl;
  @override
  int? get popularity;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyArtistImplCopyWith<_$SpotifyArtistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotifyAlbum _$SpotifyAlbumFromJson(Map<String, dynamic> json) {
  return _SpotifyAlbum.fromJson(json);
}

/// @nodoc
mixin _$SpotifyAlbum {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get releaseDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyAlbumCopyWith<SpotifyAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyAlbumCopyWith<$Res> {
  factory $SpotifyAlbumCopyWith(
          SpotifyAlbum value, $Res Function(SpotifyAlbum) then) =
      _$SpotifyAlbumCopyWithImpl<$Res, SpotifyAlbum>;
  @useResult
  $Res call(
      {String id,
      String name,
      String artistName,
      String? imageUrl,
      DateTime? releaseDate});
}

/// @nodoc
class _$SpotifyAlbumCopyWithImpl<$Res, $Val extends SpotifyAlbum>
    implements $SpotifyAlbumCopyWith<$Res> {
  _$SpotifyAlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artistName = null,
    Object? imageUrl = freezed,
    Object? releaseDate = freezed,
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
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyAlbumImplCopyWith<$Res>
    implements $SpotifyAlbumCopyWith<$Res> {
  factory _$$SpotifyAlbumImplCopyWith(
          _$SpotifyAlbumImpl value, $Res Function(_$SpotifyAlbumImpl) then) =
      __$$SpotifyAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String artistName,
      String? imageUrl,
      DateTime? releaseDate});
}

/// @nodoc
class __$$SpotifyAlbumImplCopyWithImpl<$Res>
    extends _$SpotifyAlbumCopyWithImpl<$Res, _$SpotifyAlbumImpl>
    implements _$$SpotifyAlbumImplCopyWith<$Res> {
  __$$SpotifyAlbumImplCopyWithImpl(
      _$SpotifyAlbumImpl _value, $Res Function(_$SpotifyAlbumImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artistName = null,
    Object? imageUrl = freezed,
    Object? releaseDate = freezed,
  }) {
    return _then(_$SpotifyAlbumImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyAlbumImpl implements _SpotifyAlbum {
  const _$SpotifyAlbumImpl(
      {required this.id,
      required this.name,
      required this.artistName,
      this.imageUrl,
      this.releaseDate});

  factory _$SpotifyAlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyAlbumImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String artistName;
  @override
  final String? imageUrl;
  @override
  final DateTime? releaseDate;

  @override
  String toString() {
    return 'SpotifyAlbum(id: $id, name: $name, artistName: $artistName, imageUrl: $imageUrl, releaseDate: $releaseDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyAlbumImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, artistName, imageUrl, releaseDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyAlbumImplCopyWith<_$SpotifyAlbumImpl> get copyWith =>
      __$$SpotifyAlbumImplCopyWithImpl<_$SpotifyAlbumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyAlbumImplToJson(
      this,
    );
  }
}

abstract class _SpotifyAlbum implements SpotifyAlbum {
  const factory _SpotifyAlbum(
      {required final String id,
      required final String name,
      required final String artistName,
      final String? imageUrl,
      final DateTime? releaseDate}) = _$SpotifyAlbumImpl;

  factory _SpotifyAlbum.fromJson(Map<String, dynamic> json) =
      _$SpotifyAlbumImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get artistName;
  @override
  String? get imageUrl;
  @override
  DateTime? get releaseDate;
  @override
  @JsonKey(ignore: true)
  _$$SpotifyAlbumImplCopyWith<_$SpotifyAlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentlyPlayed _$RecentlyPlayedFromJson(Map<String, dynamic> json) {
  return _RecentlyPlayed.fromJson(json);
}

/// @nodoc
mixin _$RecentlyPlayed {
  String get trackId => throw _privateConstructorUsedError;
  String get trackName => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  String get albumName => throw _privateConstructorUsedError;
  String get albumId => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  DateTime get playedAt => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentlyPlayedCopyWith<RecentlyPlayed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentlyPlayedCopyWith<$Res> {
  factory $RecentlyPlayedCopyWith(
          RecentlyPlayed value, $Res Function(RecentlyPlayed) then) =
      _$RecentlyPlayedCopyWithImpl<$Res, RecentlyPlayed>;
  @useResult
  $Res call(
      {String trackId,
      String trackName,
      String artistName,
      String artistId,
      String albumName,
      String albumId,
      List<String> genres,
      DateTime playedAt,
      int durationMs,
      String? context});
}

/// @nodoc
class _$RecentlyPlayedCopyWithImpl<$Res, $Val extends RecentlyPlayed>
    implements $RecentlyPlayedCopyWith<$Res> {
  _$RecentlyPlayedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? trackName = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? genres = null,
    Object? playedAt = null,
    Object? durationMs = null,
    Object? context = freezed,
  }) {
    return _then(_value.copyWith(
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      genres: null == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentlyPlayedImplCopyWith<$Res>
    implements $RecentlyPlayedCopyWith<$Res> {
  factory _$$RecentlyPlayedImplCopyWith(_$RecentlyPlayedImpl value,
          $Res Function(_$RecentlyPlayedImpl) then) =
      __$$RecentlyPlayedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String trackId,
      String trackName,
      String artistName,
      String artistId,
      String albumName,
      String albumId,
      List<String> genres,
      DateTime playedAt,
      int durationMs,
      String? context});
}

/// @nodoc
class __$$RecentlyPlayedImplCopyWithImpl<$Res>
    extends _$RecentlyPlayedCopyWithImpl<$Res, _$RecentlyPlayedImpl>
    implements _$$RecentlyPlayedImplCopyWith<$Res> {
  __$$RecentlyPlayedImplCopyWithImpl(
      _$RecentlyPlayedImpl _value, $Res Function(_$RecentlyPlayedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? trackName = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? genres = null,
    Object? playedAt = null,
    Object? durationMs = null,
    Object? context = freezed,
  }) {
    return _then(_$RecentlyPlayedImpl(
      trackId: null == trackId
          ? _value.trackId
          : trackId // ignore: cast_nullable_to_non_nullable
              as String,
      trackName: null == trackName
          ? _value.trackName
          : trackName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      genres: null == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentlyPlayedImpl implements _RecentlyPlayed {
  const _$RecentlyPlayedImpl(
      {required this.trackId,
      required this.trackName,
      required this.artistName,
      required this.artistId,
      required this.albumName,
      required this.albumId,
      required final List<String> genres,
      required this.playedAt,
      required this.durationMs,
      this.context})
      : _genres = genres;

  factory _$RecentlyPlayedImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentlyPlayedImplFromJson(json);

  @override
  final String trackId;
  @override
  final String trackName;
  @override
  final String artistName;
  @override
  final String artistId;
  @override
  final String albumName;
  @override
  final String albumId;
  final List<String> _genres;
  @override
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final DateTime playedAt;
  @override
  final int durationMs;
  @override
  final String? context;

  @override
  String toString() {
    return 'RecentlyPlayed(trackId: $trackId, trackName: $trackName, artistName: $artistName, artistId: $artistId, albumName: $albumName, albumId: $albumId, genres: $genres, playedAt: $playedAt, durationMs: $durationMs, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentlyPlayedImpl &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.trackName, trackName) ||
                other.trackName == trackName) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.context, context) || other.context == context));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      trackId,
      trackName,
      artistName,
      artistId,
      albumName,
      albumId,
      const DeepCollectionEquality().hash(_genres),
      playedAt,
      durationMs,
      context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentlyPlayedImplCopyWith<_$RecentlyPlayedImpl> get copyWith =>
      __$$RecentlyPlayedImplCopyWithImpl<_$RecentlyPlayedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentlyPlayedImplToJson(
      this,
    );
  }
}

abstract class _RecentlyPlayed implements RecentlyPlayed {
  const factory _RecentlyPlayed(
      {required final String trackId,
      required final String trackName,
      required final String artistName,
      required final String artistId,
      required final String albumName,
      required final String albumId,
      required final List<String> genres,
      required final DateTime playedAt,
      required final int durationMs,
      final String? context}) = _$RecentlyPlayedImpl;

  factory _RecentlyPlayed.fromJson(Map<String, dynamic> json) =
      _$RecentlyPlayedImpl.fromJson;

  @override
  String get trackId;
  @override
  String get trackName;
  @override
  String get artistName;
  @override
  String get artistId;
  @override
  String get albumName;
  @override
  String get albumId;
  @override
  List<String> get genres;
  @override
  DateTime get playedAt;
  @override
  int get durationMs;
  @override
  String? get context;
  @override
  @JsonKey(ignore: true)
  _$$RecentlyPlayedImplCopyWith<_$RecentlyPlayedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
