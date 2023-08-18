import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:limusic/services/download_manager.dart';
import 'package:limusic/widgets/min_music_player.dart';
import './home_page.dart';
import './search_page.dart';
import './library_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  List screens = [const HomePage(), const SearchPage(), const LibraryPage()];

  int selectedIndex = 0;
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  SnakeShape snakeShape = SnakeShape.circle;
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.black,
      width: 0.5,
      strokeAlign: BorderSide.strokeAlignInside,
    ),
  );

  final ReceivePort _port = ReceivePort();
  int progress = 0;
  @override
  void initState() {
    super.initState();
    unawaited(checkNecessaryPermissions());
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((progress) {
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RootBloc, RootState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      child: state.route ?? const HomePage(),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Visibility(
                        visible: state.song != null ? true : false,
                        child: const MinMusicPlayer(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SnakeNavigationBar.color(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            behaviour: snakeBarStyle,
            snakeShape: snakeShape,
            shape: bottomBarShape,
            snakeViewColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            selectedItemColor: snakeShape == SnakeShape.indicator
                ? Theme.of(context).colorScheme.primary
                : null,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() => selectedIndex = index);
              BlocProvider.of<RootBloc>(context)
                  .changeData(screens[selectedIndex], state.song);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_music,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'playlists',
              ),
            ],
          ),
        );
      },
    );
  }
}
