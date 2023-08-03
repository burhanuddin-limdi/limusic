import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(const RootInitial());
  void changeData(dynamic route, dynamic song) =>
      emit(ChangeRootRoute(route: route, song: song));
}
