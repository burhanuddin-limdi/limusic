// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/services/audio_manager.dart';
import '../API/api.dart';
import '../blocs/root_bloc/root_bloc.dart';
import 'bottom_song_menu.dart';

class SongBar extends StatefulWidget {
  const SongBar({
    super.key,
    this.song,
    this.playlist,
  });
  final dynamic song;
  final List? playlist;

  @override
  State<SongBar> createState() => _SongBarState();
}

class _SongBarState extends State<SongBar> {
  late bool songLiked;

  @override
  void initState() {
    super.initState();
    songLiked = checkForSongLiked(widget.song.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => openBottomSongMenu(context, widget.song),
      onTap: () async {
        BlocProvider.of<RootBloc>(context).add(
          ChangeSongEvent(
            currentSong: widget.song,
            currentPlaylist: widget.playlist,
          ),
        );
        bool removeConstBar = await playSong(widget.song);
        if (!removeConstBar) {
          BlocProvider.of<RootBloc>(context).add(
            ChangeSongEvent(
              currentSong: null,
              currentPlaylist: null,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(left: 10, right: 12, top: 0, bottom: 15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.primary,
                offset: const Offset(8, 8),
                spreadRadius: -1,
                blurRadius: 0)
          ],
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://img.youtube.com/vi/${widget.song.id}/default.jpg'),
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
                      width: 190,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        createTitle(widget.song.title.toString()),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
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
                      width: 190,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        widget.song.author.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
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
                  onPressed: () {
                    String sondId = widget.song.id.toString();
                    songLiked ? onDislikeSong(sondId) : onLikeSong(sondId);
                    setState(() {
                      songLiked = checkForSongLiked(sondId);
                    });
                  },
                  icon: Icon(
                    songLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                IconButton(
                  onPressed: () => openBottomSongMenu(context, widget.song),
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
