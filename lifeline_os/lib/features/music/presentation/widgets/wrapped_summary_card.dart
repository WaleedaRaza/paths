import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../app/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/music_providers.dart';

/// Spotify Wrapped-style summary card
class WrappedSummaryCard extends ConsumerWidget {
  const WrappedSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalMinutes = ref.watch(totalListeningMinutesProvider);
    final recentListens = ref.watch(recentListensProvider);
    final streak = ref.watch(listeningStreakProvider);
    final lastSync = ref.watch(lastSyncTimeProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1DB954).withOpacity(0.2), // Spotify green
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 20, color: AppColors.accent),
              const SizedBox(width: 8),
              const Text(
                'Your Week in Music',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              lastSync.when(
                data: (time) => time != null
                    ? Text(
                        'Synced ${timeago.format(time)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Grid
          Row(
            children: [
              // Total Minutes
              Expanded(
                child: totalMinutes.when(
                  data: (minutes) => _buildStatItem(
                    icon: LucideIcons.clock,
                    label: 'Total Time',
                    value: _formatMinutes(minutes),
                    color: AppColors.primary,
                  ),
                  loading: () => _buildStatItem(
                    icon: LucideIcons.clock,
                    label: 'Total Time',
                    value: '...',
                    color: AppColors.primary,
                  ),
                  error: (_, __) => _buildStatItem(
                    icon: LucideIcons.clock,
                    label: 'Total Time',
                    value: 'Error',
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Tracks Played
              Expanded(
                child: recentListens.when(
                  data: (listens) => _buildStatItem(
                    icon: LucideIcons.music,
                    label: 'Tracks',
                    value: '${listens.length}',
                    color: const Color(0xFF1DB954),
                  ),
                  loading: () => _buildStatItem(
                    icon: LucideIcons.music,
                    label: 'Tracks',
                    value: '...',
                    color: const Color(0xFF1DB954),
                  ),
                  error: (_, __) => _buildStatItem(
                    icon: LucideIcons.music,
                    label: 'Tracks',
                    value: 'Error',
                    color: const Color(0xFF1DB954),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Streak
              Expanded(
                child: streak.when(
                  data: (days) => _buildStatItem(
                    icon: LucideIcons.flame,
                    label: 'Streak',
                    value: '$days days',
                    color: Colors.orange,
                  ),
                  loading: () => _buildStatItem(
                    icon: LucideIcons.flame,
                    label: 'Streak',
                    value: '...',
                    color: Colors.orange,
                  ),
                  error: (_, __) => _buildStatItem(
                    icon: LucideIcons.flame,
                    label: 'Streak',
                    value: 'Error',
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }
}

