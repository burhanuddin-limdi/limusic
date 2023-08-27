import 'package:just_audio/just_audio.dart';
import 'package:limusic/utilities/mediaitem.dart';
import 'package:rxdart/rxdart.dart';

import '../API/api.dart';

AudioPlayer audioPlayer = AudioPlayer();

Future<bool> playSong(dynamic song) async {
  await audioPlayer.stop();
  final songUrl = await getSong(song.id.toString(), song.isLive);
  if (songUrl.isNotEmpty) {
    final audioSource = AudioSource.uri(
      Uri.parse(songUrl),
      tag: mapToMediaItem(song, songUrl),
    );
    final segments = await getSkipSegments(song.id.toString());
    if (segments.isNotEmpty) {
      if (segments.length == 1) {
        try {
          await audioPlayer.setAudioSource(
            ClippingAudioSource(
              child: audioSource,
              start: Duration(seconds: segments[0]['end']!),
              tag: audioSource.tag,
            ),
          );
        } catch (e) {
          print(e);
          return false;
        }
      } else {
        try {
          await audioPlayer.setAudioSource(
            ClippingAudioSource(
              child: audioSource,
              start: Duration(seconds: segments[0]['end']!),
              end: Duration(seconds: segments[1]['start']!),
              tag: audioSource.tag,
            ),
          );
        } catch (e) {
          print(e);
          return false;
        }
      }
    } else {
      try {
        await audioPlayer.setAudioSource(audioSource);
      } catch (e) {
        print(e);
        return false;
      }
    }
    await audioPlayer.play();
    return true;
  } else {
    return false;
  }
}

Future<dynamic> playNext({song, playlist}) async {
  int index = playlist.indexWhere((item) => item.id == song.id);
  if (index < playlist.length - 1) {
    playSong(playlist[index + 1]);
    return playlist[index + 1];
  }
}

Future<dynamic> playPrevious({song, playlist}) async {
  int index = playlist.indexWhere((item) => item.id == song.id);
  if (index >= 0) {
    playSong(playlist[index - 1]);
    return playlist[index - 1];
  }
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
