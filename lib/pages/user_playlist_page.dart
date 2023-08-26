import 'package:flutter/material.dart';
import 'package:limusic/API/api.dart';

import '../widgets/song_bar.dart';

class UserPlaylistPage extends StatelessWidget {
  final dynamic playlist;
  const UserPlaylistPage({super.key, this.playlist});
  @override
  Widget build(BuildContext context) {
    print(playlist);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Text(
                playlist['key'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          const Divider(),
          FutureBuilder(
              future: getUserPlaylistSongs(playlist['value']),
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
                            return SongBar(
                              song: snapshot.data[index],
                              playlist: snapshot.data,
                            );
                          },
                        ),
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              })
        ],
      ),
    );
  }
}
