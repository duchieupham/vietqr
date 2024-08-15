import 'package:vierqr/commons/enums/enum_type.dart';
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

class RegisterEventReSentOTP extends RegisterEvent {
  final TypeOTP typeOTP;

  const RegisterEventReSentOTP({required this.typeOTP});

  @override
  List<Object?> get props => [typeOTP];
}

class RegisterEventUpdateHeight extends RegisterEvent {
  final double height;
  final bool showBT;

  const RegisterEventUpdateHeight({
    required this.height,
    required this.showBT,
  });

  @override
  List<Object?> get props => [height, showBT];
}

class RegisterEventUpdateVerifyId extends RegisterEvent {
  final String verificationId;

  const RegisterEventUpdateVerifyId({required this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class RegisterEventUpdateResendToken extends RegisterEvent {
  final int resendToken;

  const RegisterEventUpdateResendToken({required this.resendToken});

  @override
  List<Object?> get props => [resendToken];
}

class RegisterEventUpdatePhone extends RegisterEvent {
  final String phone;

  const RegisterEventUpdatePhone({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class RegisterEventUpdatePassword extends RegisterEvent {
  final String password;

  const RegisterEventUpdatePassword({required this.password});

  @override
  List<Object?> get props => [password];
}

class RegisterEventUpdateConfirmPassword extends RegisterEvent {
  final String confirmPassword;

  const RegisterEventUpdateConfirmPassword({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class RegisterEventUpdateErrs extends RegisterEvent {
  final bool phoneErr;
  final bool passErr;
  final bool confirmPassErr;

  const RegisterEventUpdateErrs({
    required this.phoneErr,
    required this.passErr,
    required this.confirmPassErr,
  });

  @override
  List<Object?> get props => [
        phoneErr,
        passErr,
        confirmPassErr,
      ];
}

class RegisterEventReset extends RegisterEvent {
  const RegisterEventReset();

  @override
  List<Object?> get props => [];
}

class RegisterEventUpdateIntroduce extends RegisterEvent {
  final String introduce;

  const RegisterEventUpdateIntroduce({required this.introduce});

  @override
  List<Object?> get props => [introduce];
}

class RegisterEventUpdatePage extends RegisterEvent {
  final int page;

  const RegisterEventUpdatePage({required this.page});

  @override
  List<Object?> get props => [page];
}

class RegisterEventPhoneAuthentication extends RegisterEvent {
  final String phone;

  const RegisterEventPhoneAuthentication({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class RegisterEventVerifyOTP extends RegisterEvent {
  final String otp;

  const RegisterEventVerifyOTP({required this.otp});

  @override
  List<Object?> get props => [otp];
}
