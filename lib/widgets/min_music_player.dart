import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:limusic/widgets/music_player.dart';

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
        return Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            onTap: () => openMusicPlayer(context, state.song),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 1),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://img.youtube.com/vi/${state.song.id}/default.jpg',
                  ),
                  centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
                  fit: BoxFit.fill,
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
                state.song?.title.toString() ?? '',
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
