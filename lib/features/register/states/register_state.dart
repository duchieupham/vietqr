import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFailedState extends RegisterState {
  final String msg;

  const RegisterFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class RegisterSentOTPLoadingState extends RegisterState {}

class RegisterSentOTPSuccessState extends RegisterState {}

class RegisterSentOTPFailedState extends RegisterState {
  final String msg;

  const RegisterSentOTPFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class RegisterReSentOTPSuccessState extends RegisterState {}

class RegisterReSentOTPFailedState extends RegisterState {
  final String msg;

  const RegisterReSentOTPFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
