import 'package:flutter/material.dart';

class PlaylistCarousel extends StatelessWidget {
  const PlaylistCarousel(this.playlist, {super.key});
  final dynamic playlist;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 150.0,
          height: 150.0,
          child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                playlist[index]['name']!,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
