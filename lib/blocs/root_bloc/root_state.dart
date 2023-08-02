part of 'root_bloc.dart';

@immutable
abstract class RootState {
  final dynamic route;

  const RootState(this.route);
}

class RootInitial extends RootState {
  RootInitial(super.route);
}

class ChangeRootRoute extends RootState {
  ChangeRootRoute(
    super.route,
  );
}

// class ChangeCurrentSong extends RootState {
//   final dynamic currentSong;

//   ChangeCurrentSong(this.currentSong) {
//     song = currentSong;
//   }
// }
