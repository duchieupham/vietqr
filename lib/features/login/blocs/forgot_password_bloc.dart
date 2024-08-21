import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/features/login/events/forgot_password_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/login/states/forgot_password_state.dart';
import 'package:vierqr/features/verify_email/repositories/verify_email_repositories.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<ForgotPasswordEventSendOTP>(_sendOTP);
    on<ForgotPasswordEventResendOTP>(_resendOTP);
    on<ForgotPasswordEventVerifyOTP>(_verifyOTP);
    on<ForgotPasswordEventNewPass>(_inputNewPass);
    on<ForgotPasswordEventConfirmPassword>(_confirmPass);
    on<ForgotPasswordEventChangePassword>(_changePass);
  }

  EmailRepository emailRepository = EmailRepository();

  void _sendOTP(ForgotPasswordEvent event, Emitter emit) async {
    ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
    try {
      if (event is ForgotPasswordEventSendOTP) {
        dto = await emailRepository.sendOTP(event.param);
        if (dto.status == "SUCCESS") {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ForgotPasswordType.SEND_OTP,
          ));
        } else {
          emit(state.copyWith(
              msg: 'Không thể gửi OTP. Vui lòng kiểm tra lại kết nối.',
              status: BlocStatus.ERROR,
              request: ForgotPasswordType.SEND_OTP));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Không thể gửi OTP. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: ForgotPasswordType.ERROR));
    }
  }

  void _resendOTP(ForgotPasswordEvent event, Emitter emit) async {
    ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
    try {
      if (event is ForgotPasswordEventResendOTP) {
        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: ForgotPasswordType.NONE,
          isVerified: false,
          isErrVerify: false,
        ));
        dto = await emailRepository.sendOTP(event.param);
        if (dto.status == "SUCCESS") {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ForgotPasswordType.RESEND_OTP,
          ));
        } else {
          emit(state.copyWith(
              msg: 'Không thể gửi OTP. Vui lòng kiểm tra lại kết nối.',
              status: BlocStatus.ERROR,
              request: ForgotPasswordType.RESEND_OTP));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Không thể gửi OTP. Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: ForgotPasswordType.ERROR));
    }
  }

  void _verifyOTP(ForgotPasswordEvent event, Emitter emit) async {
    ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
    try {
      if (event is ForgotPasswordEventVerifyOTP) {
        dto = await emailRepository.confirmOTP(event.param);

        if (dto.status == "SUCCESS") {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: ForgotPasswordType.VERIFY_OTP,
              isVerified: true,
              isErrVerify: false));
        } else if (dto.message == 'E175') {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: ForgotPasswordType.VERIFY_OTP,
              isTimeOut: true,
              isVerified: false,
              isErrVerify: true,
              msg: 'Mã OTP đã hết hạn.'));
        } else {
          emit(state.copyWith(
              msg: 'Mã OTP không hợp lệ.',
              status: BlocStatus.ERROR,
              isErrVerify: true,
              request: ForgotPasswordType.VERIFY_OTP,
              isVerified: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: ForgotPasswordType.ERROR));
    }
  }

  void _inputNewPass(ForgotPasswordEvent event, Emitter emit) async {
    emit(
      state.copyWith(
        status: BlocStatus.NONE,
        isSamePass: true,
        request: ForgotPasswordType.CONFIRM_PASS,
      ),
    );
    if (event is ForgotPasswordEventNewPass) {
      emit(state.copyWith(
          status: BlocStatus.SUCCESS, request: ForgotPasswordType.NEW_PASS));
    }
  }

  void _confirmPass(ForgotPasswordEvent event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          status: BlocStatus.NONE,
          isSamePass: false,
          request: ForgotPasswordType.CONFIRM_PASS,
        ),
      );
      if (event is ForgotPasswordEventConfirmPassword) {
        if (event.password == event.confirmPassword) {
          emit(
            state.copyWith(
              isSamePass: false,
              status: BlocStatus.SUCCESS,
              request: ForgotPasswordType.CONFIRM_PASS,
            ),
          );
        } else if (event.confirmPassword.isEmpty) {
          emit(
            state.copyWith(
                isSamePass: true,
                status: BlocStatus.NONE,
                request: ForgotPasswordType.CONFIRM_PASS,
                msg: ''),
          );
        } else {
          emit(
            state.copyWith(
                isSamePass: true,
                status: BlocStatus.ERROR,
                request: ForgotPasswordType.CONFIRM_PASS,
                msg: 'Mật khẩu không trùng khớp'),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: ForgotPasswordType.ERROR));
    }
  }

  void _changePass(ForgotPasswordEvent event, Emitter emit) async {
    LoginRepository loginRepo = getIt.get<LoginRepository>();
    ResponseMessageDTO dto = const ResponseMessageDTO(status: '', message: '');
    try {
      
      if (event is ForgotPasswordEventChangePassword) {
         emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: ForgotPasswordType.CHANGE_PASS,
          ));

        final body = {
          'phoneNo': event.phoneNo,
          'password':
              EncryptUtils.instance.encrypted(event.phoneNo, event.password)
        };

        dto = await loginRepo.forgotPass(body);
        if (dto.status == "SUCCESS") {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ForgotPasswordType.CHANGE_PASS,
          ));
        } else if (dto.message == 'E05') {
          emit(
            state.copyWith(
              status: BlocStatus.ERROR,
              request: ForgotPasswordType.CHANGE_PASS,
              msg: 'Không thể thay đổi mật khẩu.Vui lòng kiểm tra lại kết nối.',
            ),
          );
        } else {
          emit(state.copyWith(
            msg: 'Không thể thay đổi mật khẩu.Vui lòng kiểm tra lại kết nối.',
            status: BlocStatus.ERROR,
            request: ForgotPasswordType.CHANGE_PASS,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          msg: 'Không thể thay đổi mật khẩu.Vui lòng kiểm tra lại kết nối.',
          status: BlocStatus.ERROR,
          request: ForgotPasswordType.ERROR));
    }
  }
}
