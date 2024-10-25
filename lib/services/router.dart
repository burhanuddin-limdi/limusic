import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limusic/pages/home_page.dart';
import 'package:limusic/pages/root_page.dart';
import 'package:limusic/pages/search_page.dart';
import 'package:limusic/pages/library_page.dart';
import 'package:limusic/pages/playlist_page.dart';
import 'package:limusic/pages/downloads_page.dart';
import 'package:limusic/pages/user_playlist_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootPage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: RoutePaths.playlist,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: PlaylistPage(playlist: state.extra),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    transitionsBuilder: (_, __, ___, Widget child) => child,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.search,
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.library,
              builder: (context, state) => const LibraryPage(),
              routes: [
                GoRoute(
                  path: RoutePaths.userPlaylist,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: UserPlaylistPage(playlist: state.extra),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    transitionsBuilder: (_, __, ___, Widget child) => child,
                  ),
                ),
              ],
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.downloads,
              builder: (context, state) => const DownloadsPage(),
            )
          ],
        ),
      ],
    )
  ],
);

class RoutePaths {
  RoutePaths._();
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String downloads = '/downloads';
  static const String userPlaylist = 'user-playlist';
  static const String nestedUserPlaylist = '/library/user-playlist';
  static const String playlist = 'playlist';
  static const String nestedPlaylist = '/playlist';
}
