part of 'root_bloc.dart';

@immutable
abstract class RootState {
  final dynamic song;

  const RootState({this.song});
}

class RootInitial extends RootState {
  const RootInitial();
}

class ChangeRootRoute extends RootState {
  const ChangeRootRoute({super.song});
}
