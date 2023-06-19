import 'package:flutter/material.dart';
import './pages/root_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limusic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff292D32)),
        scaffoldBackgroundColor: const Color(0xffeeeeee),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffeeeeee),
          foregroundColor: Color(0xff111111),
          titleTextStyle: TextStyle(
            color: Color(0xff111111),
            fontSize: 25,
          ),
        ),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}
