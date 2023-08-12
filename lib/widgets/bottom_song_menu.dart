import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:limusic/API/api.dart';
import 'bottom_playist_menu.dart';

dynamic openBottomSongMenu(context, dynamic song) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BottomSongMenu(
        song: song,
      );
    },
  );
}

class BottomSongMenu extends StatefulWidget {
  final dynamic song;
  const BottomSongMenu({super.key, this.song});

  @override
  State<BottomSongMenu> createState() => _BottomSongMenuState();
}

class _BottomSongMenuState extends State<BottomSongMenu> {
  late bool songLiked;
  double getLeftOffset() {
    return (MediaQuery.of(context).size.width - 250) / 2;
  }

  @override
  void initState() {
    super.initState();
    songLiked = checkForSongLiked(widget.song.id.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                  // color: Colors.black.withOpacity(0.5),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
                    'https://img.youtube.com/vi/${widget.song.id}/hqdefault.jpg',
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
                          widget.song.title,
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
                      ListTile(
                        onTap: () {},
                        leading: const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: const Text(
                          'Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          openBottomPlaylistMenu(context, widget.song);
                        },
                        leading: const Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: const Text(
                          'Add to Playlist',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          String sondId = widget.song.id.toString();
                          songLiked
                              ? onDislikeSong(sondId)
                              : onLikeSong(sondId);
                          setState(() {
                            songLiked = checkForSongLiked(sondId);
                          });
                        },
                        leading: Icon(
                          songLiked
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: const Text(
                          'Like this Song',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'close',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
  }
}
