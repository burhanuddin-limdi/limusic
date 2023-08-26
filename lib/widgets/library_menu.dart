// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/API/api.dart';
import 'package:limusic/blocs/refresh_page_bloc/refresh_page_bloc.dart';

dynamic openLibraryMenu(context, playlistKey) {
  void refreshPage() {
    BlocProvider.of<RefreshPageBloc>(context).add(OnRefreshPageEvent());
  }

  final myController = TextEditingController();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 350,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          deleteUserPlaylist(playlistKey);
                          refreshPage();
                        },
                        title: const Text('Delete playlist'),
                      ),
                      ListTile(
                        onTap: () {
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    child: const Text('Rename'),
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
                                        } else {
                                          renameUserPlaylist(
                                            playlistKey,
                                            myController.text,
                                          );
                                          myController.text = '';
                                        }
                                        refreshPage();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        title: const Text('Rename playlist'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
