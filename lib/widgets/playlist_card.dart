import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/root_bloc/root_bloc.dart';
import '../pages/playlist_page.dart';

class PlaylistCard extends StatelessWidget {
  // final RootBloc rootBloc;
  final dynamic playlist;
  const PlaylistCard({super.key, this.playlist});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => BlocProvider.of<RootBloc>(context)
              .changeData(PlaylistPage(playlist: playlist), state.song),
          // rootBloc.add(ChangeRootRouteEvent(PlaylistPage(playlist: playlist))),
          child: SizedBox(
            width: 150.0,
            height: 150.0,
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  playlist['name'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
