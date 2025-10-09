import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/database.dart';
import '../../../core/database/seed_wgu_data.dart';
import '../../../core/database/seed_all_domains.dart';
import '../../../core/providers/database_provider.dart';
import 'widgets/api_keys_panel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure your application',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Data Management Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // API Keys Panel
                    const ApiKeysPanel(),
                    const SizedBox(height: 24),

                    // Seed Database Section
                    Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            LucideIcons.database,
                            size: 24,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Seed Database',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Populate your database with structured MGTST data across all domains',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Seed All Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _seedData(context, db, seedAllDomains, 
                            '🌟 Seeding all domains...', 
                            '✅ All domains seeded! Check Milestones, Goals, and Tasks pages.'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.sparkles, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Seed All Domains',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 16),

                      const Text(
                        'Projects (Apps)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Projects Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        children: [
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: Icons.pets,
                            label: 'Petform',
                            subtitle: '1M • 3G • 6T',
                            color: Colors.pink,
                            seedFunction: seedPetform,
                            loadingMsg: '🐾 Seeding Petform...',
                            successMsg: '✅ Petform seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: Icons.sports_mma,
                            label: 'MMAmania',
                            subtitle: '1M • 4G • 8T',
                            color: Colors.red,
                            seedFunction: seedMMAmania,
                            loadingMsg: '🥊 Seeding MMAmania...',
                            successMsg: '✅ MMAmania seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: Icons.casino,
                            label: 'Pokeher',
                            subtitle: '1M • 4G • 5T',
                            color: Colors.green,
                            seedFunction: seedPokeher,
                            loadingMsg: '♠️ Seeding Pokeher...',
                            successMsg: '✅ Pokeher seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.trendingUp,
                            label: 'StockSurveyor',
                            subtitle: '1M • 4G • 5T',
                            color: Colors.blue,
                            seedFunction: seedStockSurveyor,
                            loadingMsg: '📈 Seeding StockSurveyor...',
                            successMsg: '✅ StockSurveyor seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.music,
                            label: 'Music App',
                            subtitle: '1M • 3G • 3T',
                            color: Colors.purple,
                            seedFunction: seedMusicApp,
                            loadingMsg: '🎵 Seeding Music App...',
                            successMsg: '✅ Music App seeded!',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 16),

                      const Text(
                        'Life Domains',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Life Domains Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        children: [
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.graduationCap,
                            label: 'School (WGU)',
                            subtitle: '8M • 29G • 116T',
                            color: Colors.indigo,
                            seedFunction: seedWGUData,
                            loadingMsg: '🎓 Seeding WGU data...',
                            successMsg: '✅ WGU CS degree seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.briefcase,
                            label: 'Career',
                            subtitle: '1M • 4G • 9T',
                            color: Colors.cyan,
                            seedFunction: seedCareer,
                            loadingMsg: '💼 Seeding Career...',
                            successMsg: '✅ Career advancement seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.dumbbell,
                            label: 'Fitness',
                            subtitle: '1M • 4G • 4T',
                            color: Colors.orange,
                            seedFunction: seedFitness,
                            loadingMsg: '💪 Seeding Fitness...',
                            successMsg: '✅ Fitness 8-week cycle seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.dollarSign,
                            label: 'Finance',
                            subtitle: '1M • 3G • 5T',
                            color: Colors.teal,
                            seedFunction: seedFinance,
                            loadingMsg: '💰 Seeding Finance...',
                            successMsg: '✅ Finance goals seeded!',
                          ),
                          _buildSeedButton(
                            context: context,
                            db: db,
                            icon: LucideIcons.bookOpen,
                            label: 'GRE',
                            subtitle: '1M • 3G • 3T',
                            color: Colors.amber,
                            seedFunction: seedGRE,
                            loadingMsg: '📚 Seeding GRE...',
                            successMsg: '✅ GRE prep seeded!',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Info box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Each seed creates a complete hierarchy: Milestones → Goals → Tasks.\n'
                                'M = Milestones, G = Goals, T = Tasks',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedButton({
    required BuildContext context,
    required AppDatabase db,
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required Future<void> Function(AppDatabase) seedFunction,
    required String loadingMsg,
    required String successMsg,
  }) {
    return OutlinedButton(
      onPressed: () => _seedData(context, db, seedFunction, loadingMsg, successMsg),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: color.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _seedData(
    BuildContext context,
    AppDatabase db,
    Future<void> Function(AppDatabase) seedFunction,
    String loadingMsg,
    String successMsg,
  ) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loadingMsg),
          duration: const Duration(seconds: 2),
        ),
      );

      await seedFunction(db);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMsg),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error seeding data: $e'),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
