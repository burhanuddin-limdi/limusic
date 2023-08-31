import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/root_bloc/root_bloc.dart';
import '../pages/playlist_page.dart';

class PlaylistCard extends StatelessWidget {
  final dynamic playlist;
  const PlaylistCard({super.key, this.playlist});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistPage(playlist: playlist),
            ),
          ),
          child: SizedBox(
            width: 150.0,
            height: 150.0,
            child: Container(
              margin:
                  const EdgeInsets.only(left: 0, right: 17, top: 0, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 3),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      offset: const Offset(9, 9),
                      spreadRadius: -1,
                      blurRadius: 0)
                ],
                image: DecorationImage(
                  image: AssetImage(
                      'assets/playlist_thumbnails/${playlist['name']}.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
