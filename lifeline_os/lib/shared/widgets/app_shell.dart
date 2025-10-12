import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/theme.dart';
import '../../features/today/providers/points_provider.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(totalPointsProvider);
    final streakAsync = ref.watch(streakProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // Custom draggable title bar
          DragToMoveArea(
            child: Container(
              height: 40,
              color: AppColors.surface,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'L',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pathway',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Window Controls
                  _WindowButton(
                    icon: Icons.remove,
                    onPressed: () => windowManager.minimize(),
                  ),
                  _WindowButton(
                    icon: Icons.crop_square,
                    onPressed: () async {
                      if (await windowManager.isMaximized()) {
                        windowManager.unmaximize();
                      } else {
                        windowManager.maximize();
                      }
                    },
                  ),
                  _WindowButton(
                    icon: Icons.close,
                    onPressed: () => windowManager.close(),
                    isClose: true,
                  ),
                ],
              ),
            ),
          ),
          // Main content with sidebar
          Expanded(
            child: Row(
              children: [
                // Sidebar Navigation
                _Sidebar(
                  pointsAsync: pointsAsync,
                  streakAsync: streakAsync,
                ),
                // Main Content
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final AsyncValue<int> pointsAsync;
  final AsyncValue<int> streakAsync;

  const _Sidebar({
    required this.pointsAsync,
    required this.streakAsync,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Logo/Title
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'L',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Pathway',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _NavItem(
                  icon: LucideIcons.calendar,
                  label: 'Today',
                  route: '/today',
                  isActive: currentRoute == '/today',
                ),
                _NavItem(
                  icon: LucideIcons.listChecks,
                  label: 'Tasks',
                  route: '/tasks',
                  isActive: currentRoute == '/tasks',
                ),
                _NavItem(
                  icon: LucideIcons.target,
                  label: 'Goals',
                  route: '/goals',
                  isActive: currentRoute == '/goals',
                ),
                _NavItem(
                  icon: LucideIcons.flag,
                  label: 'Milestones',
                  route: '/milestones',
                  isActive: currentRoute == '/milestones',
                ),
                _NavItem(
                  icon: LucideIcons.kanban,
                  label: 'Board View',
                  route: '/board',
                  isActive: currentRoute == '/board',
                ),
                _NavItem(
                  icon: LucideIcons.fileText,
                  label: 'Project Planner',
                  route: '/planner',
                  isActive: currentRoute == '/planner',
                ),
                _NavItem(
                  icon: LucideIcons.messageSquare,
                  label: 'Reflections',
                  route: '/reflections',
                  isActive: currentRoute == '/reflections',
                ),
                _NavItem(
                  icon: LucideIcons.gitBranch,
                  label: 'Git',
                  route: '/git-quick-commit',
                  isActive: currentRoute == '/git-quick-commit',
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'SYSTEM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                _NavItem(
                  icon: LucideIcons.settings,
                  label: 'Settings',
                  route: '/settings',
                  isActive: currentRoute == '/settings',
                ),
              ],
            ),
          ),

          // Footer (Points, Streak, etc.)
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.zap,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    pointsAsync.when(
                      data: (points) => Text(
                        '$points pts',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      loading: () => const Text(
                        '... pts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      error: (_, __) => const Text(
                        '0 pts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: streakAsync.when(
                        data: (streak) => Row(
                          children: [
                            const Text(
                              '🔥',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streak',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const Row(
                          children: [
                            Text(
                              '🔥',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '...',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        error: (_, __) => const Row(
                          children: [
                            Text(
                              '🔥',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isActive ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 40,
          color: _isHovered
              ? (widget.isClose ? Colors.red.shade600 : AppColors.border.withOpacity(0.3))
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 16,
            color: _isHovered && widget.isClose
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

