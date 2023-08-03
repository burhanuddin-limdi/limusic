import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:limusic/services/audio_manager.dart';
import 'package:limusic/utilities/formatter.dart';

dynamic openMusicPlayer(context, song) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.red,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return MusicPlayer(song: song);
    },
  );
}

class MusicPlayer extends StatefulWidget {
  final dynamic song;
  const MusicPlayer({super.key, this.song});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 25,
      width: double.infinity,
      child: Column(
        children: [
          Container(
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
          Text(
            widget.song.title,
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
          buildPlayer(),
        ],
      ),
    );
  }

  Widget buildPlayer() {
    return Container(
      child: Column(
        children: [
          StreamBuilder<PositionData>(
            stream: positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              if (positionData == null) return const SizedBox.shrink();

              final positionText =
                  formatDuration(positionData.position.inMilliseconds);
              final durationText =
                  formatDuration(positionData.duration.inMilliseconds);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.green[50],
                    value: positionData.position.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        audioPlayer.seek(Duration(milliseconds: value.round()));
                      });
                    },
                    max: positionData.duration.inMilliseconds.toDouble(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        positionText,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        durationText,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      if (playerState == null) return const SizedBox.shrink();

                      final processingState = playerState.processingState;
                      final playing = playerState.playing;

                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return const CircularProgressIndicator();
                      }

                      return GestureDetector(
                        onTap: playing ? audioPlayer.pause : audioPlayer.play,
                        child: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
