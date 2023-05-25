import 'package:equatable/equatable.dart';

class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object?> get props => [];
}

class TokenInitialState extends TokenState {}

//return check valid token
//0: ignore
//1: success
//2: maintain
//3: connection failed
//4: token expired
class TokenCheckingState extends TokenState {}

//0
class TokenInvalidState extends TokenState {}

//1
class TokenValidState extends TokenState {}

//2
class SystemMaintainState extends TokenState {}

//3
class SystemConnectionFailedState extends TokenState {}

//4
class TokenExpiredState extends TokenState {}

///
//
//
class TokenFcmUpdateSuccessState extends TokenState {}

class TokenFcmUpdateFailedState extends TokenState {}

//
class TokenExpiredLogoutState extends TokenState {}

class TokenLogoutFailedState extends TokenState {}
