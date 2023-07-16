// import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'bottom_playist_menu.dart';

dynamic openBottomSongMenu(context, dynamic song) {
  double getLeftOffset() {
    return (MediaQuery.of(context).size.width - 250) / 2;
  }

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 350,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: getLeftOffset(),
              top: 175,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 0.5),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://img.youtube.com/vi/${song.id}/hqdefault.jpg',
                    ),
                    centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 450,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Download',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            openBottomPlaylistMenu(context, song);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Add to Playlist',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Like this Song',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'close',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// dynamic openBottomSongMenu(context, dynamic song) {
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
//           // CancelAction(title: Text(''));
//           Navigator.of(context).pop();
//           openBottomPlaylistMenu(context, song);
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
