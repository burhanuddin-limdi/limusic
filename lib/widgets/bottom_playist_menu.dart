import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import '../API/api.dart';

dynamic openBottomPlaylistMenu(context, song) async {
  return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 10,
      actions: await createPLaylistList(song));
}

Future<List<BottomSheetAction>> createPLaylistList(song) async {
  List<BottomSheetAction> playlistList = [];
  dynamic userPlaylist = await getUserPlaylist();
  for (final playlist in userPlaylist) {
    dynamic playlistTile = BottomSheetAction(
      title: Row(
        children: [
          Text(playlist['key'].toString()),
        ],
      ),
      onPressed: (context) {
        addSongToUserPlaylist(playlist['key'], song.id.toString());
        Navigator.of(context).pop();
      },
    );
    playlistList.add(playlistTile);
  }
  return playlistList;
}
