import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:limusic/widgets/music_player.dart';
import 'package:path/path.dart';

import '../blocs/root_bloc/root_bloc.dart';
import '../services/audio_manager.dart';

class MinMusicPlayer extends StatefulWidget {
  const MinMusicPlayer({super.key});

  @override
  State<MinMusicPlayer> createState() => _MinMusicPlayerState();
}

class _MinMusicPlayerState extends State<MinMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        final songState = state as ChangeSongState;
        bool isSongDownloaded = false;
        String getTitle() {
          try {
            return state.song?.title.toString() ?? '';
          } catch (e) {
            isSongDownloaded = true;
            return basename(state.song.path);
          }
        }

        dynamic getImageUrl() {
          try {
            if (state.song.id != null) {
              return NetworkImage(
                  'https://img.youtube.com/vi/${state.song.id}/default.jpg');
            }
            isSongDownloaded = true;
            return const AssetImage('assets/other_images/offline_music.jpg');
          } catch (e) {
            isSongDownloaded = true;
            return const AssetImage('assets/other_images/offline_music.jpg');
          }
        }

        return Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            onTap: () => openMusicPlayer(
              context,
              songState.song,
              songState.playlist,
              isSongDownloaded,
            ),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 1),
                image: DecorationImage(
                  image: getImageUrl(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: SizedBox(
              width: 50,
              child: Text(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                overflow: TextOverflow.ellipsis,
                getTitle(),
              ),
            ),
            trailing: StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                IconData? icon;
                VoidCallback? onPressed;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  icon = null;
                  onPressed = null;
                } else if (playing != true) {
                  if (processingState != ProcessingState.idle) {
                    icon = Icons.play_arrow;
                    onPressed = audioPlayer.play;
                  }
                } else if (processingState != ProcessingState.completed) {
                  icon = Icons.pause;
                  onPressed = audioPlayer.pause;
                } else {
                  icon = Icons.replay;
                  onPressed = () => audioPlayer.seek(
                        Duration.zero,
                        index: audioPlayer.effectiveIndices!.first,
                      );
                }

                return icon != null
                    ? IconButton(
                        icon: Icon(
                          icon,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        iconSize: 45,
                        onPressed: onPressed,
                        splashColor: Colors.transparent,
                      )
                    : CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      );
              },
            ),
          ),
        );
      },
    );
  }
}
