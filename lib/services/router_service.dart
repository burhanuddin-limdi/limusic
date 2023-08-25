import 'package:flutter/material.dart';
import 'package:limusic/pages/home_page.dart';
import 'package:limusic/pages/library_page.dart';
// import 'package:limusic/pages/playlist_page.dart';
import 'package:limusic/pages/search_page.dart';

class RoutePaths {
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
}

final destinations = [
  RoutePaths.home,
  RoutePaths.search,
  RoutePaths.library,
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

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
