import 'package:equatable/equatable.dart';

class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEventSendOTP extends ForgotPasswordEvent {
  final Map<String, dynamic> param;
  const ForgotPasswordEventSendOTP({required this.param});

  @override
  List<Object?> get props => [param];
}

class ForgotPasswordEventResendOTP extends ForgotPasswordEvent {
  final Map<String, dynamic> param;
  const ForgotPasswordEventResendOTP({required this.param});

  @override
  List<Object?> get props => [param];
}

class ForgotPasswordEventVerifyOTP extends ForgotPasswordEvent {
  final Map<String, dynamic> param;
  const ForgotPasswordEventVerifyOTP({required this.param});

  @override
  List<Object?> get props => [param];
}

class ForgotPasswordEventConfirmPassword extends ForgotPasswordEvent {
  final String password;
  final String confirmPassword;

  const ForgotPasswordEventConfirmPassword(
      {required this.password, required this.confirmPassword});

  @override
  List<Object?> get props => [password, confirmPassword];
}

class ForgotPasswordEventNewPass extends ForgotPasswordEvent {
  const ForgotPasswordEventNewPass();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEventChangePassword extends ForgotPasswordEvent {
  final String phoneNo;
  final String password;
  final String confirmPassword;
  const ForgotPasswordEventChangePassword(
      this.password, this.confirmPassword, this.phoneNo);

  @override
  List<Object?> get props => [password, confirmPassword, phoneNo];
}
