import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:limusic/services/audio_manager.dart';
import 'package:limusic/utilities/mediaitem.dart';

List<FileSystemEntity> getDownloadedSongs() {
  try {
    final directory = Directory('/storage/emulated/0/Download/Limusic');
    if (!directory.existsSync()) {
      return [];
    }
    List<FileSystemEntity> audioFiles = directory.listSync().where((element) {
      return element.path.endsWith('.mp3');
    }).toList();
    return audioFiles;
  } catch (e) {
    return [];
  }
}

Future playOfflineMusic(song) async {
  final audioSource = AudioSource.uri(
    Uri.parse(song.path.toString()),
    tag: offlineMedia(song, song.path.toString()),
  );
  await audioPlayer.setAudioSource(audioSource);
  audioPlayer.play();
}
