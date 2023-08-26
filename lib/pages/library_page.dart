// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/blocs/refresh_page_bloc/refresh_page_bloc.dart';
import 'package:limusic/pages/user_playlist_page.dart';
import 'package:limusic/widgets/library_menu.dart';
import '../API/api.dart';

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
    return BlocConsumer<RefreshPageBloc, RefreshPageState>(
      listener: (context, state) {
        if (state is RefreshPageActionState) {
          _refreshIndicatorKey.currentState?.show();
        }
      },
      builder: (context, state) {
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                onLongPress: () {
                                  if (snapshot.data?[index]['key'] !=
                                      'Liked Songs') {
                                    openLibraryMenu(
                                      context,
                                      snapshot.data?[index]['key'],
                                    );
                                  }
                                },
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPlaylistPage(
                                      playlist: snapshot.data?[index],
                                    ),
                                  ),
                                ),
                                child: SizedBox(
                                  width: 150.0,
                                  height: 150.0,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 5,
                                      right: 12,
                                      top: 0,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            offset: const Offset(9, 9),
                                            spreadRadius: -1,
                                            blurRadius: 0)
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        snapshot.data?[index]['key'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
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
                    bottom: 10,
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
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  child: const Text('Create'),
                                  onPressed: () async {
                                    if (myController.text.isNotEmpty) {
                                      if (await checkForDuplicatePlaylist(
                                          myController.text)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Playlist already exists. Try another name',
                                            ),
                                          ),
                                        );
                                        _refreshIndicatorKey.currentState
                                            ?.show();
                                      } else {
                                        addUserPlaylist(myController.text);
                                        myController.text = '';
                                        _refreshIndicatorKey.currentState
                                            ?.show();
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  },
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
      },
    );
  }
}
