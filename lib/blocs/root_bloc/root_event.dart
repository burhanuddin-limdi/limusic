part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}

class ChangeCurrentSongEvent extends RootEvent {
  final dynamic currentSong;

  ChangeCurrentSongEvent(this.currentSong);
}
