import 'dart:ui';
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:limusic/blocs/root_bloc/root_bloc.dart';
import 'package:limusic/services/download_manager.dart';
import 'package:limusic/widgets/root_navigation_bar.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:limusic/blocs/refresh_page_bloc/refresh_page_bloc.dart';
import 'package:limusic/widgets/scaffold_background.dart';

class RootPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootPage({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('root_page'));

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final ReceivePort _port = ReceivePort();
  int progress = 0;
  @override
  void initState() {
    super.initState();
    unawaited(checkNecessaryPermissions());
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((progress) {
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RootBloc()),
        BlocProvider(create: (context) => RefreshPageBloc()),
      ],
      child: Scaffold(
        body: Stack(
            children: [const ScaffoldBackground(), widget.navigationShell]),
        bottomNavigationBar: RootNavigationBar(
          navigationShell: widget.navigationShell,
        ),
      ),
    );
  }
}
