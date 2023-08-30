import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:limusic/services/offline_music.dart';
import 'package:path/path.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Text(
                'Downloads',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 27,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                        color: Theme.of(context).colorScheme.secondary,
                        offset: const Offset(1.5, 1.5),
                        // spreadRadius: -1,
                        blurRadius: 0)
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const Divider(),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: getDownloadedSongs().length,
            itemBuilder: (context, index) {
              List<FileSystemEntity> songs = getDownloadedSongs();
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<RootBloc>(context).add(
                    ChangeSongEvent(
                      currentSong: songs[index],
                      currentPlaylist: songs,
                    ),
                  );
                  playOfflineMusic(songs[index]);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                      left: 10, right: 12, top: 0, bottom: 15),
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
                    children: [
                      SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: Container(
                          // width: 700,
                          // height: 00,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/other_images/offline_music.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15),
                        width: 190,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          basename(songs[index].path),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
