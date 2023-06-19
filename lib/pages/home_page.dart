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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150,
              child: PlaylistCarousel(playlistIds),
            ),
          ),
          const Divider(),
          Container(
            alignment: const Alignment(-1, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'Top Trending Music',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
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
