import 'package:flutter/material.dart';
import '../API/api.dart';
import '../widgets/playlist_carousel.dart';
import '../widgets/song_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Text(
                greetings(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 27,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                        color: Theme.of(context).colorScheme.secondary,
                        offset: const Offset(1.5, 1.5),
                        // spreadRadius: -1,
                        blurRadius: 0)
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // const Divider(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150,
              child: PlaylistCarousel(
                playlist: getRecommendedPlaylsits(),
                // rootBloc: widget.rootBloc,
              ),
            ),
          ),
          // const Divider(),
          Container(
            alignment: const Alignment(-1, 0),
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'Top Trending Music',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  shadows: [
                    Shadow(
                        color: Theme.of(context).colorScheme.secondary,
                        offset: const Offset(1, 1),
                        // spreadRadius: -1,
                        blurRadius: 0)
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          FutureBuilder(
            future: getTopDaily(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (!snapshot.hasData) {
                    return const Text('Error');
                  }
                  return Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data.length as int,
                        itemBuilder: (context, index) {
                          return SongBar(snapshot.data[index]);
                        },
                      ),
                    ],
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

String greetings() {
  int time = DateTime.now().hour;
  if (time >= 5 && time < 12) {
    return 'Good Morning';
  } else if (time >= 12 && time < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
