import 'package:equatable/equatable.dart';

class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitialState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessfulState extends LogoutState {}

class LogoutFailedState extends LogoutState {}
