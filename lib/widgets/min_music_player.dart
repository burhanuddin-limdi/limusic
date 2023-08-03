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
          height: 50,
          // color: Colors.amber,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            onTap: () => openMusicPlayer(context, state.song),
            title: Container(
              width: 50,
              child: Text(
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
                IconData icon;
                VoidCallback? onPressed;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  icon = Icons.radio_button_off_rounded;
                  onPressed = null;
                } else if (playing != true) {
                  icon = Icons.play_arrow;
                  onPressed = audioPlayer.play;
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

                return IconButton(
                  icon: Icon(icon, color: Colors.black),
                  iconSize: 45,
                  onPressed: onPressed,
                  splashColor: Colors.transparent,
                );
              },
            ),
            // trailing: IconButton(
            //   icon: const Icon(Icons.pause),
            //   onPressed: () {
            //     pauseSong();
            //   },
            // ),
          ),
        );
      },
    );
  }
}
