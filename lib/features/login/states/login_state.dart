import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessfulState extends LoginState {}

class LoginFailedState extends LoginState {}
