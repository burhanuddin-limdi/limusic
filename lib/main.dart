import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './pages/root_page.dart';
import 'blocs/root_bloc/root_bloc.dart';

void main() async {
  await initialisation();
  runApp(const MyApp());
}

Future<void> initialisation() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  // Hive.box('user').clear();
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
      home: BlocProvider(
        create: (context) => RootBloc(),
        child: const RootPage(),
      ),
    );
  }
}
