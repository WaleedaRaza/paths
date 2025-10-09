import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme.dart';
import '../../../core/database/database.dart';
import '../../../core/database/seed_wgu_data.dart';
import '../../../core/database/seed_all_domains.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/llm_provider.dart';
import '../../../core/services/llm/llm_config.dart';
import 'widgets/api_keys_panel.dart';

class SettingsPageRedesigned extends ConsumerStatefulWidget {
  const SettingsPageRedesigned({super.key});

  @override
  ConsumerState<SettingsPageRedesigned> createState() => _SettingsPageRedesignedState();
}

class _SettingsPageRedesignedState extends ConsumerState<SettingsPageRedesigned> {
  String _selectedCategory = 'ai'; // 'ai' | 'appearance' | 'data' | 'developer'

  @override
  Widget build(BuildContext context) {
    final db = ref.read(databaseProvider);
    final llmConfigAsync = ref.watch(llmConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left sidebar - Categories
          Container(
            width: 240,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Configure Pathway',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Category list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      _buildCategoryItem(
                        icon: LucideIcons.brain,
                        label: 'AI Models',
                        category: 'ai',
                        badge: llmConfigAsync.maybeWhen(
                          data: (config) => _getAIStatusBadge(config),
                          orElse: () => null,
                        ),
                      ),
                      _buildCategoryItem(
                        icon: LucideIcons.palette,
                        label: 'Appearance',
                        category: 'appearance',
                      ),
                      _buildCategoryItem(
                        icon: LucideIcons.database,
                        label: 'Data & Storage',
                        category: 'data',
                      ),
                      const Divider(height: 24),
                      _buildCategoryItem(
                        icon: LucideIcons.code,
                        label: 'Developer',
                        category: 'developer',
                        isDangerous: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right content area
          Expanded(
            child: _buildContentArea(db),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required String category,
    String? badge,
    bool isDangerous = false,
  }) {
    final isSelected = _selectedCategory == category;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = category),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected 
                    ? AppColors.primary 
                    : isDangerous 
                      ? Colors.orange 
                      : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _getAIStatusBadge(LLMConfig config) {
    switch (config.provider) {
      case LLMProvider.local:
        return 'Local';
      case LLMProvider.openai:
        return 'OpenAI';
      case LLMProvider.claude:
        return 'Claude';
      default:
        return null;
    }
  }

  Widget _buildContentArea(AppDatabase db) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildSelectedContent(db),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(AppDatabase db) {
    switch (_selectedCategory) {
      case 'ai':
        return _buildAISection();
      case 'appearance':
        return _buildAppearanceSection();
      case 'data':
        return _buildDataSection();
      case 'developer':
        return _buildDeveloperSection(db);
      default:
        return const SizedBox();
    }
  }

  Widget _buildAISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: LucideIcons.brain,
          title: 'AI Models',
          subtitle: 'Configure language models for AI features',
        ),
        const SizedBox(height: 32),
        const ApiKeysPanel(),
        const SizedBox(height: 24),
        _buildInfoCard(
          'Local models run on your machine via Ollama. Cloud models require API keys but offer more capabilities.',
          icon: LucideIcons.info,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: LucideIcons.palette,
          title: 'Appearance',
          subtitle: 'Customize the look and feel',
        ),
        const SizedBox(height: 32),
        _buildSettingCard(
          icon: LucideIcons.sun,
          title: 'Theme',
          subtitle: 'Choose your preferred color scheme',
          trailing: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'light', label: Text('Light')),
              ButtonSegment(value: 'dark', label: Text('Dark')),
              ButtonSegment(value: 'auto', label: Text('Auto')),
            ],
            selected: {'dark'},
            onSelectionChanged: (set) {},
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: LucideIcons.zap,
          title: 'Animations',
          subtitle: 'Enable smooth transitions and effects',
          trailing: Switch(
            value: true,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: LucideIcons.database,
          title: 'Data & Storage',
          subtitle: 'Manage your local database',
        ),
        const SizedBox(height: 32),
        _buildSettingCard(
          icon: LucideIcons.hardDrive,
          title: 'Storage Location',
          subtitle: 'Database stored in application documents',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.externalLink, size: 14),
            label: const Text('Open Folder'),
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: LucideIcons.download,
          title: 'Export Data',
          subtitle: 'Download a backup of all your data',
          trailing: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.download, size: 14),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          icon: LucideIcons.upload,
          title: 'Import Data',
          subtitle: 'Restore from a previous backup',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.upload, size: 14),
            label: const Text('Import'),
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperSection(AppDatabase db) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: LucideIcons.code,
          title: 'Developer Tools',
          subtitle: 'Advanced options and test data',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.info, size: 20, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'These tools are for development and testing. Use with caution.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSeedDatabaseCard(db),
      ],
    );
  }

  Widget _buildSeedDatabaseCard(AppDatabase db) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.database, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text(
                'Seed Database',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Populate database with structured MGTST test data',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Seed All Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _seedData(context, db, seedAllDomains, 
                '🌟 Seeding all domains...', 
                '✅ All domains seeded!'),
              icon: const Icon(LucideIcons.sparkles, size: 18),
              label: const Text('Seed All Domains'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Expandable sections
          _buildExpandableSection(
            title: 'Projects (Apps)',
            icon: LucideIcons.folder,
            children: [
              _buildCompactSeedButton(context, db, '🐾 Petform', seedPetform, Colors.pink),
              _buildCompactSeedButton(context, db, '🥊 MMAmania', seedMMAmania, Colors.red),
              _buildCompactSeedButton(context, db, '♠️ Pokeher', seedPokeher, Colors.green),
              _buildCompactSeedButton(context, db, '📈 StockSurveyor', seedStockSurveyor, Colors.blue),
              _buildCompactSeedButton(context, db, '🎵 Music App', seedMusicApp, Colors.purple),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildExpandableSection(
            title: 'Life Domains',
            icon: LucideIcons.target,
            children: [
              _buildCompactSeedButton(context, db, '🎓 School (WGU)', seedWGUData, Colors.indigo),
              _buildCompactSeedButton(context, db, '💼 Career', seedCareer, Colors.cyan),
              _buildCompactSeedButton(context, db, '💪 Fitness', seedFitness, Colors.orange),
              _buildCompactSeedButton(context, db, '💰 Finance', seedFinance, Colors.teal),
              _buildCompactSeedButton(context, db, '📚 GRE Prep', seedGRE, Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text, {required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, size: 18, color: AppColors.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: children,
    );
  }

  Widget _buildCompactSeedButton(
    BuildContext context,
    AppDatabase db,
    String label,
    Future<void> Function(AppDatabase) seedFunction,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () => _seedData(
          context,
          db,
          seedFunction,
          '⏳ Seeding $label...',
          '✅ $label seeded!',
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
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
        SnackBar(content: Text(loadingMsg), duration: const Duration(seconds: 2)),
      );
      await seedFunction(db);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMsg), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

