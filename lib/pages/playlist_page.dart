import 'package:flutter/material.dart';
import '../API/api.dart';
import '../widgets/song_bar.dart';

class PlaylistPage extends StatefulWidget {
  final dynamic playlist;
  const PlaylistPage({super.key, required this.playlist});
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
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
                widget.playlist['name'],
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
            future: getPlaylist(widget.playlist['id']),
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
          )
        ],
      ),
    );
  }
}
