import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/info_user_dto.dart';

// class RegisterState extends Equatable {
//   const RegisterState();

//   @override
//   List<Object?> get props => [];
// }

// class RegisterInitialState extends RegisterState {}

// class RegisterLoadingState extends RegisterState {}

// class RegisterSuccessState extends RegisterState {}

// class RegisterFailedState extends RegisterState {
//   final String msg;

//   const RegisterFailedState({required this.msg});

//   @override
//   List<Object?> get props => [msg];
// }

// class RegisterSentOTPLoadingState extends RegisterState {}

// class RegisterSentOTPSuccessState extends RegisterState {}

// class RegisterSentOTPFailedState extends RegisterState {
//   final String msg;

//   const RegisterSentOTPFailedState({required this.msg});

//   @override
//   List<Object?> get props => [msg];
// }

// class RegisterReSentOTPSuccessState extends RegisterState {}

// class RegisterReSentOTPFailedState extends RegisterState {
//   final String msg;

//   const RegisterReSentOTPFailedState({required this.msg});

//   @override
//   List<Object?> get props => [msg];
// }

class RegisterState extends Equatable {
  final String? msg;
  final BlocStatus? status;
  final RegisterType request;
  final bool isPhoneErr;
  final bool isPasswordErr;
  final bool isConfirmPassErr;
  final String verificationId;
  final int? resendToken;
  final int? page;
  final double height;
  final bool isShowButton;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String introduce;
  final bool isToast;
  final TypeOTP? typeOTP;
  final String msgVerifyOTP;
  final InfoUserDTO? infoUserDTO;

  const RegisterState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = RegisterType.NONE,
    this.isPhoneErr = false,
    this.isPasswordErr = false,
    this.isConfirmPassErr = false,
    this.verificationId = '',
    this.resendToken,
    this.page = 0,
    this.height = 0,
    this.isShowButton = false,
    this.phoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.introduce = '',
    this.typeOTP,
    this.msgVerifyOTP = '',
    this.isToast = false,
    this.infoUserDTO,
  });

  RegisterState copyWith({
    BlocStatus? status,
    RegisterType? request,
    String? msg,
    bool? isPhoneErr,
    bool? isPasswordErr,
    bool? isConfirmPassErr,
    String? verificationId,
    int? resendToken,
    int? page,
    double? height,
    bool? isShowButton,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? introduce,
    TypeOTP? typeOTP,
    String? msgVerifyOTP,
    bool? isToast,
    InfoUserDTO? infoUserDTO,
  }) {
    return RegisterState(
        status: status ?? this.status,
        request: request ?? this.request,
        msg: msg ?? this.msg,
        isPhoneErr: isPhoneErr ?? this.isPhoneErr,
        isPasswordErr: isPasswordErr ?? this.isPasswordErr,
        isConfirmPassErr: isConfirmPassErr ?? this.isConfirmPassErr,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken,
        page: page ?? this.page,
        height: height ?? this.height,
        isShowButton: isShowButton ?? this.isShowButton,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        introduce: introduce ?? this.introduce,
        typeOTP: typeOTP ?? this.typeOTP,
        msgVerifyOTP: msgVerifyOTP ?? this.msgVerifyOTP,
        isToast: isToast ?? this.isToast,
        infoUserDTO: infoUserDTO ?? this.infoUserDTO);
  }

  @override
  List<Object?> get props => [
        msg,
        status,
        request,
        isPhoneErr,
        isPasswordErr,
        isConfirmPassErr,
        verificationId,
        resendToken,
        page,
        height,
        isShowButton,
        phoneNumber,
        confirmPassword,
        introduce,
        typeOTP,
        msgVerifyOTP,
        isToast,
        infoUserDTO
      ];
}
