import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:vierqr/models/code_login_dto.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEventByPhone extends LoginEvent {
  final AccountLoginDTO dto;
  const LoginEventByPhone({required this.dto});

  @override
  List<Object?> get props => [dto];
}

// class LoginEventGetUserInformation extends LoginEvent {
//   final String userId;

//   const LoginEventGetUserInformation({required this.userId});

//   @override
//   List<Object?> get props => [userId];
// }

class LoginEventInsertCode extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventInsertCode({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventListen extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventListen({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventReceived extends LoginEvent {
  final CodeLoginDTO dto;

  const LoginEventReceived({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginEventUpdateCode extends LoginEvent {
  final String code;
  final String userId;

  const LoginEventUpdateCode({required this.code, required this.userId});

  @override
  List<Object?> get props => [code, userId];
}
