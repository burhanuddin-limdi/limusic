import 'package:flutter/material.dart';

class MinMusicPlayer extends StatefulWidget {
  const MinMusicPlayer({super.key});

  @override
  State<MinMusicPlayer> createState() => _MinMusicPlayerState();
}

class _MinMusicPlayerState extends State<MinMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 50,
        // color: Colors.amber,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(),
      ),
    );
  }
}
