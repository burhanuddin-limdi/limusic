import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:limusic/API/api.dart';
import 'package:limusic/services/data_manager.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadSong(dynamic song) async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final androidVersion = int.parse(androidInfo.version.release);

    final songUrl = await getSong(song.id.toString(), song.isLive);

    final PermissionStatus status;

    if (androidVersion < 13) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.manageExternalStorage.request();
    }

    String fileName = song.title
        .toString()
        .replaceAll(
          RegExp(r'[^\w\s-]'),
          '',
        )
        .replaceAll(RegExp(r'(\s)+'), '-');
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (status == PermissionStatus.denied) {
      Permission.storage.request();
    } else if (status == PermissionStatus.restricted) {
      openAppSettings();
    } else if (status == PermissionStatus.granted) {
      final directory = Directory('/storage/emulated/0/Download/Limusic');

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
}

Future<void> checkNecessaryPermissions() async {
  await Permission.audio.request();
  await Permission.notification.request();
  await Permission.storage.request();
  await Permission.manageExternalStorage.request();
}
