import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';

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
        onLongPress: () => openBottomMenu(context),
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
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        song.title
                            .toString()
                            .split('(')[0]
                            .replaceAll('&quot;', '"')
                            .replaceAll('&amp;', '&')
                            .split('-')[1]
                            .split('[')[0],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
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
                  onPressed: () => openBottomMenu(context),
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

dynamic openBottomMenu(context) {
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
        onPressed: (_) {},
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
