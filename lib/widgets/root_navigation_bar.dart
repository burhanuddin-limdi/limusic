import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/utilities/destination.dart';
import 'package:limusic/widgets/min_music_player.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class RootNavigationBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const RootNavigationBar({super.key, required this.navigationShell});

  @override
  State<RootNavigationBar> createState() => _RootNavigationBarState();
}

class _RootNavigationBarState extends State<RootNavigationBar> {
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  SnakeShape snakeShape = SnakeShape.circle;
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.black,
      width: 0.5,
      strokeAlign: BorderSide.strokeAlignInside,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<RootBloc, RootState>(
          builder: (context, state) {
            final songState = state as ChangeSongState;
            return Visibility(
              visible: songState.song != null ? true : false,
              child: const MinMusicPlayer(),
            );
          },
        ),
        SnakeNavigationBar.color(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          behaviour: snakeBarStyle,
          snakeShape: snakeShape,
          shape: bottomBarShape,
          snakeViewColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: snakeShape == SnakeShape.indicator
              ? Theme.of(context).colorScheme.primary
              : null,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: widget.navigationShell.currentIndex,
          onTap: widget.navigationShell.goBranch,
          items: destinations
              .map((destination) => BottomNavigationBarItem(
                    icon: Icon(destination.icon),
                    label: destination.label,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
