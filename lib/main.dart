import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limusic/style/theme.dart';
import './pages/root_page.dart';
import 'blocs/root_bloc/root_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  await initialisation();
  runApp(const MyApp());
}

Future<void> initialisation() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );
  // Hive.box('user').clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limusic',
      theme: themeData(),
      home: BlocProvider(
        create: (context) => RootBloc(),
        child: const RootPage(),
      ),
    );
  }
}
