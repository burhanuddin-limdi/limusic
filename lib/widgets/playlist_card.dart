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
              // color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 0.5),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/playlist_thumbnails/${playlist['name']}.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // child: Center(
              //   child: Text(
              //     playlist['name'],
              //     style: TextStyle(
              //         fontSize: 25,
              //         fontWeight: FontWeight.w600,
              //         color: Theme.of(context).colorScheme.secondary),
              //   ),
              // ),
            ),
          ),
        );
      },
    );
  }
}
