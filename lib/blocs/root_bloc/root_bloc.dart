import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    on<ChangeRootRouteEvent>(changeRootRoute);
  }

  FutureOr<void> changeRootRoute(
      ChangeRootRouteEvent event, Emitter<RootState> emit) {
    emit(ChangeRootRoute(event.route));
  }
}

Widget rootRoute = Container();
