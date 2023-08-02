import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial(null));
  void changeRoute(dynamic route) => emit(ChangeRootRoute(route));
}

dynamic song;
