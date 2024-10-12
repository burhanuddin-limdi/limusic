import 'package:flutter/material.dart';

class Destination {
  final String label;
  final IconData icon;

  const Destination({required this.label, required this.icon});
}

const destinations = <Destination>[
  Destination(label: 'Home', icon: Icons.home),
  Destination(label: 'Search', icon: Icons.search),
  Destination(label: 'Playlists', icon: Icons.library_music),
  Destination(label: 'Downloads', icon: Icons.file_download_outlined),
];
