import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../services/data_manager.dart';
import 'package:http/http.dart' as http;

final yt = YoutubeExplode();

List userPlaylists = Hive.box('user').get('playlists', defaultValue: [
  {
    'key': 'Liked Songs',
    'value': [],
  }
]);

String topDailyMusicId = 'PLx0sYbCqOb8Sfi8H4gvgW-vS1g2fkxwLT';

List getRecommendedPlaylsits() {
  playlistIds.shuffle();
  return playlistIds.toList();
}

final playlistIds = [
  {'name': 'pop', 'id': 'PLw-VjHDlEOguL2K_NwIl_tYcs9_FSt5v_'},
  {'name': 'hindi', 'id': 'PL3oW2tjiIxvTSdJ4zqjL9dijeZ0LjcuGS'},
  {'name': 'rap', 'id': 'PL4xqRMQ2GXanSqin_ScadJd4coEBK_QCS'},
  {'name': 'korean', 'id': 'PL4QNnZJr8sRNKjKzArmzTBAlNYBDN2h-J'},
  {'name': 'punjabi', 'id': 'PL-QvSRz8uhNHYPsQFUyZ4vEDURCBqLiR1'},
  {'name': 'party', 'id': 'PLm_3vnTS-pvnzdJZzI1jKXvjp_ssKTnP0'},
  {'name': 'rock', 'id': 'PLDyMXoYglQpLxQKW_BLbkSh8KuIhYbIp8'},
  {'name': 'japanese', 'id': 'PLHfGRdioXHaO6fpAWIUYTV2lBws-uWECA'},
  {'name': 'tiktok', 'id': 'PLyORnIW1xT6xExONZqUnmdnfVAl0sJGeb'},
  {'name': 'bhojpuri', 'id': 'PL2NFDAvOrsDVTOOuuVUJIakhBvZIjnF2j'},
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

void onLikeSong(String songId) {
  dynamic likedSongsPlaylist = userPlaylists[0];
  likedSongsPlaylist['value'].add(songId);
  addOrUpdateData('user', 'playlists', userPlaylists);
}

void onDislikeSong(String songId) {
  dynamic likedSongsPlaylist = userPlaylists[0];
  likedSongsPlaylist['value'].remove(songId);
}

bool checkForSongLiked(String sondId) {
  dynamic likedSongsPlaylist = userPlaylists[0];
  if (likedSongsPlaylist['value'].length == 0) {
    return false;
  } else {
    return likedSongsPlaylist['value'].contains(sondId);
  }
}

Future getUserPlaylistSongs(songIds) async {
  List songs = [];
  for (var songId in songIds) {
    var song = await yt.videos.get('https://youtube.com/watch?v=$songId');
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
    return list;
  } catch (e) {
    return [];
  }
}

Future<List<Map<String, int>>> getSkipSegments(String id) async {
  try {
    final res = await http.get(
      Uri(
        scheme: 'https',
        host: 'sponsor.ajay.app',
        path: '/api/skipSegments',
        queryParameters: {
          'videoID': id,
          'category': [
            'sponsor',
            'selfpromo',
            'interaction',
            'intro',
            'outro',
            'music_offtopic'
          ],
          'actionType': 'skip'
        },
      ),
    );
    if (res.body != 'Not Found') {
      final data = jsonDecode(res.body);
      final segments = data.map((obj) {
        return Map.castFrom<String, dynamic, String, int>({
          'start': obj['segment'].first.toInt(),
          'end': obj['segment'].last.toInt(),
        });
      }).toList();
      return List.castFrom<dynamic, Map<String, int>>(segments);
    } else {
      return [];
    }
  } catch (e) {
    // Logger.log('Error in getSkipSegments: $e $stack');
    return [];
  }
}
