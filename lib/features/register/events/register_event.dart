import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEventSubmit extends RegisterEvent {
  final AccountLoginDTO dto;

  const RegisterEventSubmit({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class RegisterEventSentOTP extends RegisterEvent {
  final TypeOTP typeOTP;

  const RegisterEventSentOTP({required this.typeOTP});

  @override
  List<Object?> get props => [typeOTP];
}
