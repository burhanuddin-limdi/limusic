import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/API/api.dart';
import 'package:limusic/blocs/refresh_page_bloc/refresh_page_bloc.dart';

dynamic openLibraryMenu(context, playlistKey) {
  void refreshPage() {
    BlocProvider.of<RefreshPageBloc>(context).add(OnRefreshPageEvent());
  }

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
                      )
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
