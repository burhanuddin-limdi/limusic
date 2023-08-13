import 'package:audio_service/audio_service.dart';

MediaItem mapToMediaItem(dynamic song, String songUrl) => MediaItem(
      id: song.id.toString(),
      album: '',
      artist: song.author.toString(),
      title: song.title.toString(),
      // extras: {
      //   'url': songUrl,
      //   'lowResImage': song['lowResImage'],
      //   'ytid': song['ytid'],
      //   'localSongId': song['localSongId'],
      //   'isLive': song['isLive'],
      // },
    );
