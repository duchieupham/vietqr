import 'package:firebase_auth/firebase_auth.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/features/register/repositories/register_repository.dart';
import 'package:vierqr/features/register/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // @override
  // final BuildContext context;

  final RegisterRepository registerRepository;

  RegisterBloc(this.registerRepository)
      : super(const RegisterState()) {
    on<RegisterEventSubmit>(_register);
    on<RegisterEventSentOTP>(_sentOtp);
    on<RegisterEventUpdateHeight>(_updateHeight);
    on<RegisterEventPhoneAuthentication>(_phoneAuthentication);
    on<RegisterEventVerifyOTP>(_verifyOTP);
    on<RegisterEventUpdatePage>(_updatePage);
    on<RegisterEventUpdatePhone>(_updatePhone);
    on<RegisterEventUpdatePassword>(_updatePassword);
    on<RegisterEventUpdateConfirmPassword>(_updateConfirmPassword);
    on<RegisterEventUpdateIntroduce>(_updateIntroduce);
    on<RegisterEventReset>(_reset);
    on<RegisterEventResetPassword>(_resetPassword);
    on<RegisterEventResetConfirmPassword>(_resetConfirmPassword);
    on<RegisterEventUpdateErrs>(_updateErrs);
    on<RegisterEventRefresh>(_refresh);
    on<RegisterEventLoginAfterRegister>(_loginAfterRegister);
  }


  final auth = FirebaseAuth.instance;
  static const String countryCode = '+84';

  void _register(RegisterEvent event, Emitter emit) async {
    try {
      if (event is RegisterEventSubmit) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: RegisterType.REGISTER));
        ResponseMessageDTO responseMessageDTO =
            await registerRepository.register(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: RegisterType.REGISTER,
            isPhoneErr: false,
            isPasswordErr: false,
            isConfirmPassErr: false,
            verificationId: '',
            resendToken: null,
            page: 0,
            height: 0,
            isShowButton: false,
            // phoneNumber: '',
            // password: '',
            // confirmPassword: '',
            introduce: '',
            typeOTP: null,
            msgVerifyOTP: '',
          ));
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

  void _updatePage(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdatePage) {
        emit(state.copyWith(
            page: event.page,
            status: BlocStatus.UNLOADING,
            request: RegisterType.UPDATE_PAGE));
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updatePhone(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdatePhone) {
        String phone = event.phone.replaceAll(" ", "");
        if (phone.isNotEmpty) {
          var isValid = StringUtils.instance.isValidatePhone(phone);
          emit(state.copyWith(
              phoneNumber: phone,
              isPhoneErr: !isValid,
              status: BlocStatus.UNLOADING,
              request: RegisterType.UPDATE_PHONE));
        } else {
          emit(state.copyWith(
              phoneNumber: phone,
              isPhoneErr: false,
              status: BlocStatus.ERROR,
              request: RegisterType.UPDATE_PHONE));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updatePassword(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdatePassword) {
        String password = event.password;
        if (password.isNotEmpty) {
          emit(state.copyWith(
              password: password,
              isPasswordErr: false,
              status: BlocStatus.UNLOADING,
              request: RegisterType.UPDATE_PASSWORD));
        } else {
          emit(state.copyWith(
              isPasswordErr: true,
              status: BlocStatus.ERROR,
              request: RegisterType.UPDATE_PASSWORD));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updateConfirmPassword(
      RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdateConfirmPassword) {
        String confirmPass = event.confirmPassword;
        String password = event.password;
        if (confirmPass.isNotEmpty && password.isNotEmpty) {
          if (confirmPass == password) {
            emit(state.copyWith(
                confirmPassword: confirmPass,
                isConfirmPassErr: false,
                status: BlocStatus.UNLOADING,
                request: RegisterType.UPDATE_PASSWORD));
          } else {
            emit(state.copyWith(
                isConfirmPassErr: true,
                status: BlocStatus.UNLOADING,
                request: RegisterType.UPDATE_PASSWORD));
          }
        } else {
          emit(state.copyWith(
              isConfirmPassErr: true,
              status: BlocStatus.ERROR,
              request: RegisterType.UPDATE_PASSWORD));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updateIntroduce(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdateIntroduce) {
        String introduce = event.introduce;
        if (introduce.isNotEmpty) {
          emit(state.copyWith(
              introduce: introduce,
              status: BlocStatus.UNLOADING,
              request: RegisterType.UPDATE_INTRODUCE));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _updateErrs(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventUpdateErrs) {
        emit(state.copyWith(
            isPhoneErr: event.phoneErr,
            isPasswordErr: event.passErr,
            isConfirmPassErr: event.confirmPassErr,
            status: BlocStatus.UNLOADING,
            request: RegisterType.UPDATE_ERROR));
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _reset(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventReset) {
        emit(
          state.copyWith(
              status: BlocStatus.UNLOADING,
              request: RegisterType.RESET,
              isPhoneErr: false,
              isPasswordErr: false,
              isConfirmPassErr: false),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _refresh(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventRefresh) {
        emit(
          state.copyWith(
            status: BlocStatus.NONE,
            request: RegisterType.NONE,
            isPhoneErr: false,
            isPasswordErr: false,
            isConfirmPassErr: false,
            verificationId: '',
            resendToken: null,
            page: 0,
            height: 0,
            isShowButton: false,
            phoneNumber: '',
            password: '',
            confirmPassword: '',
            introduce: '',
            typeOTP: null,
            msgVerifyOTP: '',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _resetPassword(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventResetPassword) {
        emit(
          state.copyWith(
            status: BlocStatus.UNLOADING,
            request: RegisterType.RESET,
            password: '',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: RegisterType.ERROR));
    }
  }

  void _resetConfirmPassword(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventReset) {
        emit(
          state.copyWith(
            status: BlocStatus.UNLOADING,
            request: RegisterType.RESET,
            confirmPassword: '',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
        msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.',
        status: BlocStatus.ERROR,
        request: RegisterType.ERROR,
      ));
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

  Future<void> _loginAfterRegister(RegisterEvent event, Emitter emit) async {
    try {
      final LoginRepository loginRepository = getIt.get<LoginRepository>();
      if (event is RegisterEventLoginAfterRegister) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: RegisterType.NONE));
        AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: state.phoneNumber,
            password:
                'c9b6800dcc470c39048c8e53259044092751d7905ca4693879175b4cdff6a5b6');

        AccountLoginDTO accountDTO = AccountLoginDTO(
          phoneNo: state.phoneNumber,
          password: EncryptUtils.instance.encrypted(
            state.phoneNumber,
            state.password,
          ),
          device: '',
          fcmToken: '',
          platform: '',
          sharingCode: '',
        );
        bool check = await loginRepository.login(accountDTO);

        if (check) {
          await loginRepository.checkExistPhone(state.phoneNumber).then(
            (value) {
              if (value is InfoUserDTO) {
                emit(state.copyWith(
                    isToast: event.isToast,
                    infoUserDTO: value,
                    isPhoneErr: false,
                    isPasswordErr: false,
                    isConfirmPassErr: false,
                    verificationId: '',
                    resendToken: null,
                    page: 0,
                    height: 0,
                    isShowButton: false,
                    phoneNumber: '',
                    password: '',
                    confirmPassword: '',
                    introduce: '',
                    typeOTP: null,
                    msgVerifyOTP: '',
                    request: RegisterType.NONE,
                    status: BlocStatus.UNLOADING));
                // ignore: use_build_context_synchronously
                // Provider.of<AuthenProvider>(context, listen: false)
                //     .checkStateLogin(false);
              }
            },
          ).catchError((onError) {
            emit(
              state.copyWith(
                request: RegisterType.NONE,
                status: BlocStatus.ERROR,
                phoneNumber: state.phoneNumber,
              ),
            );
          });
        } else {
          emit(state.copyWith(
              request: RegisterType.ERROR,
              msg: 'Sai mật khẩu. Vui lòng kiểm tra lại mật khẩu của bạn'));
          // Provider.of<AuthenProvider>(context, listen: false)
          //     .checkStateLogin(true);
        }
      }
    } catch (e) {
      emit(state.copyWith(request: RegisterType.ERROR));
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
