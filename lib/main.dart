import 'package:flutter/material.dart';
import 'package:limusic/style/theme.dart';
import 'package:limusic/services/router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  await initialisation();
  runApp(const MyApp());
}

Future<void> initialisation() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  await JustAudioBackground.init(
    androidNotificationOngoing: true,
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  );
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Limusic',
      theme: themeData(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
