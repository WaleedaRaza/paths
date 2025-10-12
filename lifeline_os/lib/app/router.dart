import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/today/presentation/today_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import '../features/goals/presentation/goals_page.dart';
import '../features/milestones/presentation/milestones_page.dart';
import '../features/board/presentation/board_page.dart';
import '../features/planner/presentation/planner_page.dart';
import '../features/reflections/presentation/reflections_page.dart';
import '../features/git_quick_commit/presentation/git_quick_commit_page.dart';
import '../features/settings/presentation/settings_page_redesigned.dart';
import '../shared/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/today',
            name: 'today',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TodayPage(),
            ),
          ),
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TasksPage(),
            ),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const GoalsPage(),
            ),
          ),
          GoRoute(
            path: '/milestones',
            name: 'milestones',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MilestonesPage(),
            ),
          ),
          GoRoute(
            path: '/board',
            name: 'board',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const BoardPage(),
            ),
          ),
          GoRoute(
            path: '/planner',
            name: 'planner',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const PlannerPage(),
            ),
          ),
          GoRoute(
            path: '/reflections',
            name: 'reflections',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ReflectionsPage(),
            ),
          ),
          GoRoute(
            path: '/git-quick-commit',
            name: 'git-quick-commit',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const GitQuickCommitPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsPageRedesigned(),
            ),
          ),
        ],
      ),
    ],
  );
});

