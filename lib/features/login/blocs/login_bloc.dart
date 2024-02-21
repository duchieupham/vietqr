import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(appInfoDTO: AppInfoDTO())) {
    on<LoginEventByPhone>(_login);
    on<LoginEventByNFC>(_loginNFC);
    on<CheckExitsPhoneEvent>(_checkExitsPhone);
    on<GetFreeToken>(_loadFreeToken);
    on<UpdateEvent>(_updateEvent);
    on<GetVersionAppEvent>(_getVersionApp);
  }

  void _login(LoginEvent event, Emitter emit) async {
    try {
      if (event is LoginEventByPhone) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: LoginType.NONE));
        bool check = await loginRepository.login(event.dto);
        if (check) {
          emit(state.copyWith(
              isToast: event.isToast,
              request: LoginType.TOAST,
              status: BlocStatus.UNLOADING));
        } else {
          emit(state.copyWith(
              request: LoginType.ERROR,
              msg: 'Sai mật khẩu. Vui lòng kiểm tra lại mật khẩu của bạn'));
        }
      }
    } catch (e) {
      emit(state.copyWith(request: LoginType.ERROR));
    }
  }

  void _loginNFC(LoginEvent event, Emitter emit) async {
    try {
      if (event is LoginEventByNFC) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: LoginType.NONE));
        bool check = await loginRepository.loginNFC(event.dto);
        if (check) {
          emit(state.copyWith(
              isToast: event.isToast,
              request: LoginType.TOAST,
              status: BlocStatus.UNLOADING));
        } else {
          emit(state.copyWith(
              request: LoginType.ERROR,
              msg: 'Sai mật khẩu. Vui lòng kiểm tra lại mật khẩu của bạn'));
        }
      }
    } catch (e) {
      emit(state.copyWith(request: LoginType.ERROR));
    }
  }

  void _checkExitsPhone(LoginEvent event, Emitter emit) async {
    try {
      if (event is CheckExitsPhoneEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: LoginType.NONE));
        final data = await loginRepository.checkExistPhone(event.phone);
        if (data is InfoUserDTO) {
          emit(
            state.copyWith(
                request: LoginType.CHECK_EXIST,
                status: BlocStatus.UNLOADING,
                infoUserDTO: data),
          );
        } else if (data is ResponseMessageDTO) {
          if (data.status == Stringify.RESPONSE_STATUS_CHECK) {
            String message = CheckUtils.instance.getCheckMessage(data.message);
            emit(
              state.copyWith(
                msg: message,
                request: LoginType.REGISTER,
                status: BlocStatus.UNLOADING,
                phone: event.phone,
              ),
            );
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(request: LoginType.ERROR));
    }
  }

  void _loadFreeToken(LoginEvent event, Emitter emit) async {
    if (event is GetFreeToken) {
      emit(state.copyWith(status: BlocStatus.NONE, request: LoginType.NONE));
      await loginRepository.getFreeToken();
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: LoginType.FREE_TOKEN,
          isCheckApp: event.isCheckVer));
    }
  }

  void _getVersionApp(LoginEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: BlocStatus.NONE, request: LoginType.NONE));
      if (event is GetVersionAppEvent) {
        final result = await dashBoardRepository.getVersionApp();
        result.isCheckApp = event.isCheckVer;
        emit(state.copyWith(
          appInfoDTO: result,
          status: BlocStatus.NONE,
          request: LoginType.APP_VERSION,
          isCheckApp: event.isCheckVer,
        ));
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _updateEvent(LoginEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.NONE, request: LoginType.NONE));
  }
}

const LoginRepository loginRepository = LoginRepository();
