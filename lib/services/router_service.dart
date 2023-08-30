import 'package:flutter/material.dart';
import 'package:limusic/pages/downloads_page.dart';
import 'package:limusic/pages/home_page.dart';
import 'package:limusic/pages/library_page.dart';
// import 'package:limusic/pages/playlist_page.dart';
import 'package:limusic/pages/search_page.dart';

class RoutePaths {
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String downloads = '/downloads';
}

final destinations = [
  RoutePaths.home,
  RoutePaths.search,
  RoutePaths.library,
  RoutePaths.downloads
];

// ignore: avoid_classes_with_only_static_members
class RouterService {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RoutePaths.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case RoutePaths.library:
        return MaterialPageRoute(builder: (_) => const LibraryPage());
      case RoutePaths.downloads:
        return MaterialPageRoute(builder: (_) => const DownloadsPage());

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
