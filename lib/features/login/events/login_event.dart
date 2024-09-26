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
  final bool isToast;

  const LoginEventByPhone({required this.dto, this.isToast = false});

  @override
  List<Object?> get props => [dto];
}

class LoginEventByNFC extends LoginEvent {
  final AccountLoginDTO dto;
  final bool isToast;

  const LoginEventByNFC({required this.dto, this.isToast = false});

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

class CheckExitsPhoneEvent extends LoginEvent {
  final String phone;

  const CheckExitsPhoneEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class GetFreeToken extends LoginEvent {
  final bool isCheckVer;

  const GetFreeToken({this.isCheckVer = false});

  @override
  List<Object?> get props => [isCheckVer];
}

class UpdateEvent extends LoginEvent {}

class GetVersionAppEvent extends LoginEvent {
  final bool isCheckVer;

  const GetVersionAppEvent({this.isCheckVer = false});

  @override
  List<Object?> get props => [isCheckVer];
}
