part of 'root_bloc.dart';

@immutable
abstract class RootState {
  const RootState();
}

class ChangeSongState extends RootState {
  final dynamic song;
  const ChangeSongState({this.song});
}
