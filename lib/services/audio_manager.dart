import 'package:just_audio/just_audio.dart';

import '../API/api.dart';

AudioPlayer audioPlayer = AudioPlayer();

Future<void> playSong(dynamic song) async {
  final songUrl = await getSong(song.id.toString(), song.isLive);
  final audioSource = AudioSource.uri(Uri.parse(songUrl));
  await audioPlayer.setAudioSource(audioSource);
  await audioPlayer.play();
}

Future<void> pauseSong() async {
  await audioPlayer.pause();
}

// Future<void> checkIfSponsorBlockIsAvailable(song, songUrl) async {
//   final _audioSource = AudioSource.uri(
//     Uri.parse(songUrl),
//     // tag: mapToMediaItem(song, songUrl),
//   );
//   // if (sponsorBlockSupport.value) {
//   //   final segments = await getSkipSegments(song['ytid']);
//   //   if (segments.isNotEmpty) {
//   //     if (segments.length == 1) {
//   //       await audioPlayer.setAudioSource(
//   //         ClippingAudioSource(
//   //           child: _audioSource,
//   //           start: Duration(seconds: segments[0]['end']!),
//   //           tag: _audioSource.tag,
//   //         ),
//   //       );
//   //       return;
//   //     } else {
//   //       await audioPlayer.setAudioSource(
//   //         ClippingAudioSource(
//   //           child: _audioSource,
//   //           start: Duration(seconds: segments[0]['end']!),
//   //           end: Duration(seconds: segments[1]['start']!),
//   //           tag: _audioSource.tag,
//   //         ),
//   //       );
//   //       return;
//   //     }
//   //   }
//   // }
//   await audioPlayer.setAudioSource(_audioSource);
// }