import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final yt = YoutubeExplode();

String topDailyMusicId = 'PLx0sYbCqOb8Sfi8H4gvgW-vS1g2fkxwLT';

const playlistIds = [
  {'name': 'Pop', 'id': 'PLw-VjHDlEOguL2K_NwIl_tYcs9_FSt5v_'},
  {'name': 'Hindi', 'id': 'PL3oW2tjiIxvTSdJ4zqjL9dijeZ0LjcuGS'},
  {'name': 'Rap', 'id': 'PL4xqRMQ2GXanSqin_ScadJd4coEBK_QCS'},
  {'name': 'Korean', 'id': 'PL4QNnZJr8sRNKjKzArmzTBAlNYBDN2h-J'},
  {'name': 'Punjabi', 'id': 'PL-QvSRz8uhNHYPsQFUyZ4vEDURCBqLiR1'},
  {'name': 'Party', 'id': 'PLm_3vnTS-pvnzdJZzI1jKXvjp_ssKTnP0'},
  {'name': 'Rock', 'id': 'PLDyMXoYglQpLxQKW_BLbkSh8KuIhYbIp8'},
  {'name': 'Japanese', 'id': 'PLHfGRdioXHaO6fpAWIUYTV2lBws-uWECA'},
  {'name': 'Tiktok', 'id': 'PLyORnIW1xT6xExONZqUnmdnfVAl0sJGeb'},
  {'name': 'Bhojpuri', 'id': 'PL2NFDAvOrsDVTOOuuVUJIakhBvZIjnF2j'},
];

Future getvideo() async {
  var video =
      await yt.videos.get('https://www.youtube.com/watch?v=OVLI6jWma9M');
  return video.description;
}

Future getTopDaily() async {
  var playlist =
      await yt.playlists.getVideos(topDailyMusicId).take(10).toList();
  return playlist;
}
