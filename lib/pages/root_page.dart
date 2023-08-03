import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
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
  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RootBloc, RootState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              state.route ?? const HomePage(),
              Positioned(
                  bottom: 10,
                  child: Visibility(
                      visible: state.song != null ? true : false,
                      child: MinMusicPlayer()))
            ],
          ),
          bottomNavigationBar: SnakeNavigationBar.color(
            behaviour: snakeBarStyle,
            snakeShape: snakeShape,
            shape: bottomBarShape,
            snakeViewColor: selectedColor,
            selectedItemColor:
                snakeShape == SnakeShape.indicator ? selectedColor : null,
            unselectedItemColor: unselectedColor,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() => selectedIndex = index);
              BlocProvider.of<RootBloc>(context)
                  .changeData(screens[selectedIndex], state.song);
              // context.bloc<RootBloc>().decrement();
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'playlists',
              ),
            ],
          ),
        );
      },
    );
  }
}
