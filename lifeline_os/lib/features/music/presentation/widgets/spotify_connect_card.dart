import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';

/// Card shown when user needs to connect Spotify
class SpotifyConnectCard extends ConsumerWidget {
  const SpotifyConnectCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spotify logo (placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954), // Spotify green
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                LucideIcons.music,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Connect to Spotify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            const Text(
              'Track your listening habits, discover patterns, and get AI-powered insights about your music taste.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Features list
            _buildFeature('📊', 'Year-round Spotify Wrapped'),
            const SizedBox(height: 12),
            _buildFeature('🎧', 'Top artists, tracks, and genres'),
            const SizedBox(height: 12),
            _buildFeature('📈', 'Listening patterns and trends'),
            const SizedBox(height: 12),
            _buildFeature('🤖', 'AI-powered weekly insights'),
            const SizedBox(height: 12),
            _buildFeature('🎵', 'Smart auto-generated playlists'),
            const SizedBox(height: 32),

            // Connect button
            ElevatedButton.icon(
              onPressed: () => _showSetupDialog(context),
              icon: const Icon(LucideIcons.link),
              label: const Text('Connect Spotify'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Help text
            const Text(
              'You\'ll need Spotify API credentials from developer.spotify.com',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Setup Spotify Integration'),
        content: const Text(
          'Spotify integration setup will be added in Settings → Integrations.\n\n'
          'You\'ll need to:\n'
          '1. Create a Spotify app at developer.spotify.com\n'
          '2. Enter your Client ID and Client Secret\n'
          '3. Authorize the connection\n\n'
          'Coming soon!',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

