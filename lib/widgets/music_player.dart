// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:limusic/API/api.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:limusic/services/audio_manager.dart';
import 'package:limusic/services/download_manager.dart';
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
  late bool songLiked;
  @override
  void initState() {
    super.initState();
    songLiked = checkForSongLiked(widget.song.id.toString());
  }

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ], // Replace with your desired colors
          center: Alignment.center,
          radius: 0.6,
          focal: Alignment.center,
          focalRadius: 0.1,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
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
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 50),
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      formatSongTitle(widget.song.title.toString()),
                      overflow: TextOverflow.ellipsis,
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
                          size: 350,
                          startAngle: -60,
                          angleRange: 300,
                          customColors: CustomSliderColors(
                            trackColor: Theme.of(context).colorScheme.primary,
                            progressBarColors: [
                              const Color(0xffffae00),
                              Theme.of(context).scaffoldBackgroundColor,
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
                        width: 320,
                        height: 320,
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
                      processingState == ProcessingState.buffering ||
                      processingState == ProcessingState.idle) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  void playNextSong() async {
                    audioPlayer.seek(const Duration(milliseconds: 0));
                    audioPlayer.stop();
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
                  }

                  audioPlayer.processingStateStream.listen((state) {
                    if (state == ProcessingState.completed) {
                      print('Song has finished playing!');
                      playNextSong();
                    }
                  });

                  final currnetPosition = positionData.position.inMilliseconds;
                  final totalDuration = positionData.duration.inMilliseconds;

                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => downloadSong(widget.song),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
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
                            size: 25,
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
                            size: 25,
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
                                    milliseconds:
                                        currnetPosition.toInt() + 10000,
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
                            size: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            playNextSong();
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            String sondId = widget.song.id.toString();
                            songLiked
                                ? onDislikeSong(sondId)
                                : onLikeSong(sondId);
                            setState(() {
                              songLiked = checkForSongLiked(sondId);
                            });
                          },
                          icon: Icon(
                            songLiked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
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
