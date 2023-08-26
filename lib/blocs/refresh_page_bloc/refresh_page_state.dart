part of 'refresh_page_bloc.dart';

@immutable
sealed class RefreshPageState {}

final class RefreshPageInitial extends RefreshPageState {}

class RefreshPageActionState extends RefreshPageState {}
