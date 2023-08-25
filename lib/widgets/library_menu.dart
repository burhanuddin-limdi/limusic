import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:limusic/API/api.dart';

dynamic openLibraryMenu(context, playlistKey) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => deleteUserPlaylist(playlistKey),
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
      });
}
