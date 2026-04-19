import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../app/theme.dart';
import 'widgets/wrapped_summary_card.dart';
import 'widgets/top_artists_grid.dart';
import 'widgets/listening_timeline_chart.dart';
import 'widgets/listening_heatmap.dart';
import 'widgets/smart_playlists_section.dart';
import 'widgets/llm_insight_card.dart';
import 'widgets/spotify_connect_card.dart';
import '../providers/music_providers.dart';

class MusicPage extends ConsumerWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isSpotifyAuthenticatedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.music, size: 24, color: AppColors.accent),
                const SizedBox(width: 12),
                const Text(
                  'Music Intelligence',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                
                // Sync button (only if authenticated)
                isAuthenticated.when(
                  data: (authed) => authed
                      ? IconButton(
                          icon: const Icon(LucideIcons.refreshCw, size: 18),
                          onPressed: () => _syncSpotify(context, ref),
                          tooltip: 'Sync with Spotify',
                          color: AppColors.accent,
                        )
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: isAuthenticated.when(
              data: (authed) => authed
                  ? _buildDashboard(context, ref)
                  : const SpotifyConnectCard(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LLM Insight Card (Weekly)
          const LLMInsightCard(),
          const SizedBox(height: 24),

          // Wrapped Summary (This Week)
          const WrappedSummaryCard(),
          const SizedBox(height: 24),

          // Top Artists Grid
          const TopArtistsGrid(),
          const SizedBox(height: 24),

          // Listening Timeline
          const ListeningTimelineChart(),
          const SizedBox(height: 24),

          // Listening Heatmap
          const ListeningHeatmap(),
          const SizedBox(height: 24),

          // Smart Playlists
          const SmartPlaylistsSection(),
          
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Future<void> _syncSpotify(BuildContext context, WidgetRef ref) async {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Syncing with Spotify...'),
          ],
        ),
        duration: Duration(seconds: 30),
      ),
    );

    // TODO: Get client ID and secret from settings
    // For now, hardcoded - will move to settings
    const clientId = 'YOUR_CLIENT_ID';
    const clientSecret = 'YOUR_CLIENT_SECRET';

    try {
      final result = await ref.read(syncSpotifyProvider((clientId, clientSecret)).future);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

