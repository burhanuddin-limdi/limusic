import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(const ChangeSongState()) {
    on<ChangeSongEvent>(changSong);
  }

  FutureOr<void> changSong(ChangeSongEvent event, Emitter<RootState> emit) {
    emit(ChangeSongState(song: event.currentSong));
  }
}
//  void changeSong(dynamic song) => emit(ChangeSongState(song: song));