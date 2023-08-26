part of 'refresh_page_bloc.dart';

@immutable
sealed class RefreshPageEvent {}

class OnRefreshPageEvent extends RefreshPageEvent {}
