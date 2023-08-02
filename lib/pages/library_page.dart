import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/pages/user_playlist_page.dart';
import '../API/api.dart';
import '../blocs/root_bloc/root_bloc.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final myController = TextEditingController();

  late Future<List<dynamic>> _getUserPlaylist;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _getUserPlaylistData();
  }

  Future<void> _getUserPlaylistData() async {
    setState(() {
      _getUserPlaylist = getUserPlaylist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: const Alignment(-1, 0),
          child: const Padding(
            padding: EdgeInsets.only(top: 40, left: 10),
            child: Text(
              'Library',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _getUserPlaylistData,
                child: FutureBuilder(
                  future: _getUserPlaylist,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal,
                        ),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => BlocProvider.of<RootBloc>(context)
                                .changeRoute(UserPlaylistPage(
                                    playlist: snapshot.data?[index])),
                            child: Card(
                              color: Colors.amber,
                              child: Center(
                                child: Text(
                                  snapshot.data?[index]['key'],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Create Playlist'),
                          content: TextField(
                            controller: myController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Playlist Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                addUserPlaylist(myController.text);
                                myController.text = '';
                                _refreshIndicatorKey.currentState?.show();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Create'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
