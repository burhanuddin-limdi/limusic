import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'refresh_page_event.dart';
part 'refresh_page_state.dart';

class RefreshPageBloc extends Bloc<RefreshPageEvent, RefreshPageState> {
  RefreshPageBloc() : super(RefreshPageInitial()) {
    on<OnRefreshPageEvent>((event, emit) {
      emit(RefreshPageActionState());
    });
  }
}
