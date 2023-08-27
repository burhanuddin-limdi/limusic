// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:limusic/services/audio_manager.dart';
import 'package:limusic/utilities/formatter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

dynamic openMusicPlayer(ctx, song, playlist) {
  return showModalBottomSheet(
    context: ctx,
    backgroundColor: Theme.of(ctx).colorScheme.primary,
    isScrollControlled: true,
    builder: (context) {
      return MusicPlayer(
        song: song,
        playlist: playlist,
        ctx: ctx,
      );
    },
  );
}

class MusicPlayer extends StatefulWidget {
  dynamic song;
  final List? playlist;
  final BuildContext? ctx;
  MusicPlayer({super.key, this.song, this.playlist, this.ctx});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
  void setSongState(dynamic newSong) {
    BlocProvider.of<RootBloc>(ctx!).add(
      ChangeSongEvent(
        currentSong: newSong,
        currentPlaylist: playlist,
      ),
    );
  }
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 25,
      width: double.infinity,
      child: StreamBuilder<PositionData>(
        stream: positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          if (positionData == null) return const SizedBox.shrink();

          final positionText =
              formatDuration(positionData.position.inMilliseconds);
          final durationText =
              formatDuration(positionData.duration.inMilliseconds);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      formatSongTitle(widget.song.title.toString()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      formatSongTitle(widget.song.author.toString()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SleekCircularSlider(
                        min: 0,
                        max: positionData.duration.inMilliseconds.toDouble(),
                        initialValue:
                            positionData.position.inMilliseconds.toDouble(),
                        appearance: CircularSliderAppearance(
                          size: 300,
                          startAngle: -60,
                          angleRange: 300,
                          customColors: CustomSliderColors(
                            trackColor: Theme.of(context).colorScheme.secondary,
                            progressBarColors: [
                              const Color(0xffffae00),
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context).colorScheme.primary,
                            ],
                          ),
                          customWidths: CustomSliderWidths(
                            progressBarWidth: 5,
                            trackWidth: 5,
                            shadowWidth: 0,
                            handlerSize: 7,
                          ),
                        ),
                        onChange: (double value) {
                          setState(() {
                            audioPlayer
                                .seek(Duration(milliseconds: value.round()));
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
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
                      top: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$positionText | $durationText',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }

                  final currnetPosition = positionData.position.inMilliseconds;
                  final totalDuration = positionData.duration.inMilliseconds;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          audioPlayer.stop();
                          audioPlayer.seek(const Duration(milliseconds: 0));
                          final newSong = await playPrevious(
                            song: widget.song,
                            playlist: widget.playlist,
                          );
                          if (newSong != null) {
                            setState(() {
                              widget.song = newSong;
                            });
                            widget.setSongState(newSong);
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currnetPosition > 10000) {
                            audioPlayer.seek(
                              Duration(
                                milliseconds: currnetPosition.toInt() - 10000,
                              ),
                            );
                          } else {
                            audioPlayer.seek(Duration.zero);
                          }
                        },
                        icon: const Icon(
                          Icons.replay_10_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            playing ? audioPlayer.pause : audioPlayer.play,
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currnetPosition != totalDuration) {
                            if (totalDuration.toInt() -
                                    currnetPosition.toInt() >
                                10000) {
                              audioPlayer.seek(
                                Duration(
                                  milliseconds: currnetPosition.toInt() + 10000,
                                ),
                              );
                            } else {
                              audioPlayer.seek(
                                Duration(
                                  milliseconds: totalDuration.toInt(),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          audioPlayer.stop();
                          audioPlayer.seek(const Duration(milliseconds: 0));
                          final newSong = await playNext(
                            song: widget.song,
                            playlist: widget.playlist,
                          );
                          if (newSong != null) {
                            setState(() {
                              widget.song = newSong;
                            });
                            widget.setSongState(newSong);
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
