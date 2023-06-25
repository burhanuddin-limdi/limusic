part of 'root_bloc.dart';

@immutable
abstract class RootState {}

class RootInitial extends RootState {}

class ChangeRootRoute extends RootState {
  final dynamic route;

  ChangeRootRoute(this.route) {
    rootRoute = route;
  }
}
