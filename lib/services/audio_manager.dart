import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../API/api.dart';

AudioPlayer audioPlayer = AudioPlayer();

Future<bool> playSong(dynamic song) async {
  await audioPlayer.stop();
  final songUrl = await getSong(song.id.toString(), song.isLive);
  if (songUrl.isNotEmpty) {
    final audioSource = AudioSource.uri(Uri.parse(songUrl));
    await audioPlayer.setAudioSource(audioSource);
    await audioPlayer.play();
    return true;
  } else {
    return false;
  }
}

Future<void> pauseSong() async {
  await audioPlayer.pause();
}

Stream<PositionData> get positionDataStream =>
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
