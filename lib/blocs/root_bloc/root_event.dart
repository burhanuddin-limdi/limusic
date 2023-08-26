part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}

class ChangeSongEvent extends RootEvent {
  final dynamic currentSong;
  final List? currentPlaylist;
  ChangeSongEvent({this.currentSong, this.currentPlaylist});
}
