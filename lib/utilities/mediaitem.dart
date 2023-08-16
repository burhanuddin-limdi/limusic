import 'package:audio_service/audio_service.dart';

MediaItem mapToMediaItem(dynamic song, String songUrl) => MediaItem(
      id: song.id.toString(),
      album: '',
      artist: song.author.toString(),
      title: song.title.toString(),
      artUri: Uri.parse(
        'https://img.youtube.com/vi/${song.id}/hqdefault.jpg',
      ),
    );
