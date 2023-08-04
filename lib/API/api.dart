import 'dart:async';

import 'package:hive/hive.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../services/data_manager.dart';
// import '../utilities/formatter.dart';

final yt = YoutubeExplode();

List userPlaylists = Hive.box('user').get('playlists', defaultValue: []);

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
      await yt.playlists.getVideos(topDailyMusicId).take(25).toList();
  return playlist;
}

Future getPlaylist(String id) async {
  return await yt.playlists.getVideos(id).toList();
}

Future<List> getUserPlaylist() async {
  // print(userPlaylists);
  return userPlaylists;
}

void addUserPlaylist(String playlistName) {
  final playlsitMap = {
    'key': playlistName,
    'value': [],
  };
  userPlaylists.add(playlsitMap);
  addOrUpdateData('user', 'playlists', userPlaylists);
}

void addSongToUserPlaylist(String playlsitName, String songId) {
  dynamic foundPlaylist =
      userPlaylists.firstWhere((element) => element['key'] == playlsitName);
  foundPlaylist['value'].add(songId);
  addOrUpdateData('user', 'playlists', userPlaylists);
}

Future getUserPlaylistSongs(songIds) async {
  // var video = yt.videos.get('https://youtube.com/watch?v=Dpp1sIL1m5Q');
  // print(video);
  // print('songIds' + songIds.toString());
  List songs = [];
  for (var songId in songIds) {
    var song = await yt.videos.get('https://youtube.com/watch?v=$songId');
    // print(song);
    songs.add(song);
  }
  return songs;
}

Future<String> getSong(String songId, bool isLive) async {
  try {
    if (isLive) {
      final streamInfo =
          await yt.videos.streamsClient.getHttpLiveStreamUrl(VideoId(songId));
      return streamInfo;
    } else {
      final manifest = await yt.videos.streamsClient.getManifest(songId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    }
  } catch (e) {
    return '';
  }
}

Future<List> fetchSongsList(String searchQuery) async {
  try {
    final List list = await yt.search.search(searchQuery);
    // final searchedList = [
    //   for (final s in list)
    //     returnSongLayout(
    //       0,
    //       s,
    //     )
    // ];

    // return searchedList;
    return list;
  } catch (e) {
    // Logger.log('Error in fetchSongsList: $e');
    return [];
  }
}

// void runVideo() {
//   print(userPlaylists);
//   getUserPlaylistSongs(userPlaylists[0]['value']);
// }
