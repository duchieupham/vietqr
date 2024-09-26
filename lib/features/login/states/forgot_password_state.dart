import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

class ForgotPasswordState extends Equatable {
  final BlocStatus? status;
  final ForgotPasswordType? request;
  final String msg;
  final bool isVerified;
  final bool isErrVerify;
  final bool? isOldPass;
  final bool isSamePass;
  final bool? isTimeOut;

  const ForgotPasswordState(
      {this.status = BlocStatus.NONE,
      this.request = ForgotPasswordType.NONE,
      this.msg = '',
      this.isVerified = false,
      this.isOldPass,
      this.isErrVerify = false,
      this.isSamePass = true,
      this.isTimeOut});

  ForgotPasswordState copyWith({
    BlocStatus? status,
    ForgotPasswordType? request,
    String? msg,
    bool? isVerified,
    bool? isOldPass,
    bool? isErrVerify,
    bool? isSamePass,
    bool? isTimeOut,
  }) {
    return ForgotPasswordState(
        status: status ?? this.status,
        request: request ?? this.request,
        msg: msg ?? this.msg,
        isErrVerify: isErrVerify ?? this.isErrVerify,
        isOldPass: isOldPass ?? this.isOldPass,
        isSamePass: isSamePass ?? this.isSamePass,
        isVerified: isVerified ?? this.isVerified,
        isTimeOut: isTimeOut ?? this.isTimeOut);
  }

  @override
  List<Object?> get props => [
        status,
        request,
        msg,
        isVerified,
        isOldPass,
        isSamePass,
        isTimeOut,
        isErrVerify
      ];
}
