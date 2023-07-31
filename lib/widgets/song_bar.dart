import 'package:flutter/material.dart';
import 'bottom_song_menu.dart';
import '../services/audio_manager.dart';

class SongBar extends StatelessWidget {
  const SongBar(this.song, {super.key});
  final dynamic song;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: InkWell(
        onLongPress: () => openBottomSongMenu(context, song),
        onTap: () => playSong(song),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 0.5),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://img.youtube.com/vi/${song.id}/default.jpg'),
                      centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 15),
                      width: 200,
                      child: Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          createTitle(song.title.toString()),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: 200,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        song.author.toString(),
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
                IconButton(
                  onPressed: () => openBottomSongMenu(context, song),
                  icon: const Icon(Icons.more_vert_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// dynamic openBottomMenu(context, dynamic song) {
//   return showAdaptiveActionSheet(
//     androidBorderRadius: 10,
//     context: context,
//     actions: <BottomSheetAction>[
//       BottomSheetAction(
//         title: const Row(
//           children: [
//             Icon(Icons.download),
//             Padding(
//               padding: EdgeInsets.only(left: 10.0),
//               child: Text(
//                 'Download',
//                 textAlign: TextAlign.start,
//               ),
//             ),
//           ],
//         ),
//         onPressed: (_) {},
//       ),
//       BottomSheetAction(
//         title: const Row(
//           children: [
//             Icon(Icons.add_box_outlined),
//             Padding(
//               padding: EdgeInsets.only(left: 10.0),
//               child: Text(
//                 'Add to Playlist',
//                 textAlign: TextAlign.start,
//               ),
//             ),
//           ],
//         ),
//         onPressed: (BuildContext context) {
//           print(song.id.toString());
//         },
//       ),
//       BottomSheetAction(
//         title: const Row(
//           children: [
//             Icon(Icons.favorite),
//             Padding(
//               padding: EdgeInsets.only(left: 10.0),
//               child: Text(
//                 'Like',
//                 textAlign: TextAlign.start,
//               ),
//             ),
//           ],
//         ),
//         onPressed: (_) {},
//       ),
//     ],
//   );
// }

String createTitle(String title) {
  if (title.contains('-')) {
    title = title.split('-')[1];
  }
  if (title.contains('[')) {
    title = title.split('[')[0];
  }

  title =
      title.split('(')[0].replaceAll('&quot;', '"').replaceAll('&amp;', '&');
  return title;
}
