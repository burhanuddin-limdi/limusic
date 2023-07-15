import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'bottom_playist_menu.dart';

dynamic openBottomSongMenu(context, dynamic song) {
  return showAdaptiveActionSheet(
    androidBorderRadius: 10,
    context: context,
    actions: <BottomSheetAction>[
      BottomSheetAction(
        title: const Row(
          children: [
            Icon(Icons.download),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Download',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        onPressed: (_) {},
      ),
      BottomSheetAction(
        title: const Row(
          children: [
            Icon(Icons.add_box_outlined),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Add to Playlist',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        onPressed: (BuildContext context) {
          // CancelAction(title: Text(''));
          Navigator.of(context).pop();
          openBottomPlaylistMenu(context, song);
        },
      ),
      BottomSheetAction(
        title: const Row(
          children: [
            Icon(Icons.favorite),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Like',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        onPressed: (_) {},
      ),
    ],
  );
}
