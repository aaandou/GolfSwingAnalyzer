import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'application/dtos/playback_args.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/history/history_screen.dart';
import 'presentation/screens/playback/playback_screen.dart';
import 'presentation/screens/record/record_screen.dart';

final _router = GoRouter(
  initialLocation: '/record',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/record', builder: (_, _) => const RecordScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/history', builder: (_, _) => const HistoryScreen())],
        ),
      ],
    ),
    GoRoute(
      path: '/playback',
      builder: (_, state) {
        final args = state.extra as PlaybackArgs;
        return PlaybackScreen(args: args);
      },
    ),
  ],
);

class GolfSwingAnalyzerApp extends StatelessWidget {
  const GolfSwingAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShotPointAnalyzer',
      theme: appTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _ScaffoldWithNav({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: '撮影'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
        ],
      ),
    );
  }
}
