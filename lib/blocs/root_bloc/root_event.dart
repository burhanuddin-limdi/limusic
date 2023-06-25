part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}

// class RootInitialEvent extends RootEvent {
//   final dynamic route;

//   RootInitialEvent(this.route);
// }

class ChangeRootRouteEvent extends RootEvent {
  final dynamic route;

  ChangeRootRouteEvent(this.route);
}
