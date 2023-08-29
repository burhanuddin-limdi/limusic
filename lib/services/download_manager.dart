import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:limusic/API/api.dart';
import 'package:limusic/services/data_manager.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadSong(dynamic song) async {
  print('download pressed');
  final songUrl = await getSong(song.id.toString(), song.isLive);
  var status = await Permission.manageExternalStorage.request();
  String fileName = song.title.toString();
  print(status);
  if (status.isPermanentlyDenied) {
    openAppSettings();
  } else if (status.isDenied) {
    Permission.manageExternalStorage.request();
  } else if (status.isGranted) {
    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    await FlutterDownloader.enqueue(
      url: songUrl,
      fileName: '$fileName.mp3',
      headers: {},
      savedDir: directory.path,
      showNotification: true,
      openFileFromNotification: true,
    );
    addOrUpdateData('user', 'downloadedSongName', fileName);
  }
}

Future<void> checkNecessaryPermissions() async {
  await Permission.audio.request();
  await Permission.notification.request();
  // await Permission.storage.request();
  // await Permission.manageExternalStorage.request();
  try {
    await Permission.storage.request();
  } catch (e) {
    print(e);
  }
}
