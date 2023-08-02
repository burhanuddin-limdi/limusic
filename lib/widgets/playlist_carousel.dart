import 'package:flutter/material.dart';
import 'package:limusic/widgets/playlist_card.dart';

class PlaylistCarousel extends StatelessWidget {
  // final RootBloc rootBloc;
  final dynamic playlist;
  const PlaylistCarousel({super.key, this.playlist});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        return PlaylistCard(
          // rootBloc: rootBloc,
          playlist: playlist[index],
        );
      },
    );
  }
}
