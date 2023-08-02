part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}

class ChangeRootRouteEvent extends RootEvent {
  final dynamic route;

  ChangeRootRouteEvent(this.route);
}

class ChangeCurrentSongEvent extends RootEvent {
  final dynamic currentSong;

  ChangeCurrentSongEvent(this.currentSong);
}
