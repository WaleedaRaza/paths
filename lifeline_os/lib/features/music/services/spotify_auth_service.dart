import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/database/database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

/// Spotify OAuth and token management service
class SpotifyAuthService {
  final AppDatabase _db;
  
  // Spotify OAuth credentials (user will input these in Settings)
  static const String redirectUri = 'http://localhost:8888/callback';
  static const List<String> scopes = [
    'user-read-recently-played',
    'user-top-read',
    'user-read-playback-state',
    'user-read-currently-playing',
    'playlist-read-private',
    'playlist-read-collaborative',
  ];

  SpotifyAuthService(this._db);

  /// Start OAuth flow - opens browser for user to authorize
  Future<void> startAuth(String clientId) async {
    final state = const Uuid().v4();
    final scopeStr = scopes.join(' ');
    
    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'scope': scopeStr,
      'state': state,
    });

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Spotify authorization URL');
    }
  }

  /// Exchange authorization code for access token
  Future<void> exchangeCodeForToken(
    String code,
    String clientId,
    String clientSecret,
  ) async {
    final response = await http.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data);
    } else {
      throw Exception('Failed to exchange code for token: ${response.body}');
    }
  }

  /// Get current access token (refresh if expired)
  Future<String?> getAccessToken(String clientId, String clientSecret) async {
    final tokens = await (_db.select(_db.spotifyTokens)).get();
    
    if (tokens.isEmpty) {
      return null; // Not authenticated
    }

    final token = tokens.first;
    final now = DateTime.now();

    // Check if token is expired
    if (now.isAfter(token.expiresAt)) {
      // Refresh the token
      await _refreshToken(token.refreshToken, clientId, clientSecret);
      final newTokens = await (_db.select(_db.spotifyTokens)).get();
      return newTokens.first.accessToken;
    }

    return token.accessToken;
  }

  /// Refresh access token using refresh token
  Future<void> _refreshToken(
    String refreshToken,
    String clientId,
    String clientSecret,
  ) async {
    final response = await http.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data, existingRefreshToken: refreshToken);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  /// Save token to database
  Future<void> _saveToken(Map<String, dynamic> data, {String? existingRefreshToken}) async {
    final accessToken = data['access_token'] as String;
    final refreshToken = (data['refresh_token'] as String?) ?? existingRefreshToken;
    final expiresIn = data['expires_in'] as int;
    final scope = data['scope'] as String?;

    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    // Delete existing tokens and insert new one
    await _db.delete(_db.spotifyTokens).go();
    
    await _db.into(_db.spotifyTokens).insert(
      SpotifyTokensCompanion.insert(
        id: const Uuid().v4(),
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        expiresAt: expiresAt,
        scope: scope ?? scopes.join(' '),
      ),
    );
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final tokens = await (_db.select(_db.spotifyTokens)).get();
    return tokens.isNotEmpty;
  }

  /// Sign out (delete tokens)
  Future<void> signOut() async {
    await _db.delete(_db.spotifyTokens).go();
  }
}

