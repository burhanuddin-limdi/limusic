import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:limusic/blocs/root_bloc/root_route.dart';
import 'package:meta/meta.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    // on<RootInitialEvent>(initialRootRoute);
    on<ChangeRootRouteEvent>(changeRootRoute);
  }

  // FutureOr<void> initialRootRoute(
  //     RootInitialEvent event, Emitter<RootState> emit) {
  //   emit(ChangeRootRoute(event.route));
  // }

  FutureOr<void> changeRootRoute(
      ChangeRootRouteEvent event, Emitter<RootState> emit) {
    emit(ChangeRootRoute(event.route));
  }
}
