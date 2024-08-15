import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/repositories/register_repository.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/response_message_dto.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final RegisterRepository registerRepository;

  RegisterBloc(this.registerRepository)
      : super(const RegisterState()) {
    on<RegisterEventSubmit>(_register);
    on<RegisterEventSentOTP>(_sentOtp);
    on<RegisterEventUpdateHeight>(_updateHeight);
    // on<RegisterEventReSentOTP>(_reSentOtp);
    on<RegisterEventPhoneAuthentication>(_phoneAuthentication);
    on<RegisterEventVerifyOTP>(_verifyOTP);
  }

  // RegisterBloc() : super(RegisterInitialState()) {
  //   on<RegisterEventSubmit>(_register);
  //   on<RegisterEventSentOTP>(_sentOtp);
  //   // on<RegisterEventReSentOTP>(_reSentOtp);
  // }

  final auth = FirebaseAuth.instance;
  static const String countryCode = '+84';

  void _register(RegisterEvent event, Emitter emit) async {
    try {
      if (event is RegisterEventSubmit) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: RegisterType.NONE));
        ResponseMessageDTO responseMessageDTO =
            await registerRepository.register(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS, request: RegisterType.REGISTER));
        } else {
          String msg =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: msg));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _sentOtp(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventSentOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: RegisterType.SENT_OPT));
        if (event.typeOTP == TypeOTP.SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS, request: RegisterType.SENT_OPT));
        } else if (event.typeOTP == TypeOTP.FAILED) {
          emit(state.copyWith(
            msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
            status: BlocStatus.ERROR,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updateHeight(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdateHeight) {
        emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: RegisterType.UPDATE_HEIGHT,
            height: event.height,
            isShowButton: event.showBT));
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  Future<void> _phoneAuthentication(
      RegisterEvent event, Emitter<RegisterState> emit) async {
    try {
      if (event is RegisterEventPhoneAuthentication) {
        await auth.verifyPhoneNumber(
          phoneNumber: countryCode + event.phone,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          codeSent: (String verificationId, int? resendToken) {
            emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: RegisterType.PHONE_AUTHENTICATION,
              verificationId: verificationId,
              resendToken: resendToken,
              typeOTP: TypeOTP.SUCCESS,
            ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationFailed: (FirebaseAuthException e) {
            emit(state.copyWith(
                status: BlocStatus.ERROR,
                request: RegisterType.PHONE_AUTHENTICATION,
                typeOTP: TypeOTP.FAILED));
          },
          forceResendingToken: state.resendToken,
          timeout: const Duration(seconds: 120),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  Future<void> _verifyOTP(
      RegisterEvent event, Emitter<RegisterState> emit) async {
    try {
      if (event is RegisterEventVerifyOTP) {
        final data =
            await registerRepository.verifyOTP(event.otp, state.verificationId);
        if (data is bool) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: RegisterType.VERIFY_OTP,
              resendToken: null));
        } else if (data is String) {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: RegisterType.VERIFY_OTP,
              msgVerifyOTP: data,
              resendToken: null));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

//
// void _reSentOtp(RegisterEvent event, Emitter<RegisterState> emit) {
//   try {
//     if (event is RegisterEventReSentOTP) {
//       emit(RegisterSentOTPLoadingState());
//       if (event.typeOTP == TypeOTP.SUCCESS) {
//         emit(RegisterReSentOTPSuccessState());
//       } else if (event.typeOTP == TypeOTP.FAILED) {
//         emit(const RegisterReSentOTPFailedState(
//             msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.'));
//       }
//     }
//   } catch (e) {
//     print('Error at register - RegisterBloc: $e');
//     emit(const RegisterReSentOTPFailedState(
//         msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.'));
//   }
// }
}
