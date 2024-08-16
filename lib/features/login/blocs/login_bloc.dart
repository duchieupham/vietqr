import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/login/events/login_event.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/login/states/login_state.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import '../../dashboard/blocs/auth_provider.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with BaseManager {
  @override
  final BuildContext context;

  final LoginRepository loginRepository;

  LoginBloc(this.context, this.loginRepository)
      : super(LoginState(appInfoDTO: AppInfoDTO())) {
    on<LoginEventByPhone>(_login);
    on<LoginEventByNFC>(_loginNFC);
    on<CheckExitsPhoneEvent>(_checkExitsPhone);
    on<GetFreeToken>(_loadFreeToken);
    on<UpdateEvent>(_updateEvent);
    on<GetVersionAppEvent>(_getVersionApp);
  }

  Future<void> _login(LoginEvent event, Emitter emit) async {
    try {
      if (event is LoginEventByPhone) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: LoginType.NONE));
        AccountLoginDTO dto = AccountLoginDTO(
            phoneNo: event.dto.phoneNo,
            password:
                'c9b6800dcc470c39048c8e53259044092751d7905ca4693879175b4cdff6a5b6');
        bool check = await loginRepository.login(event.dto);
        if (check) {
          emit(state.copyWith(
              isToast: event.isToast,
              request: LoginType.LOGIN,
              status: BlocStatus.UNLOADING));
          Provider.of<AuthenProvider>(context, listen: false)
              .checkStateLogin(false);
        } else {
          emit(state.copyWith(
              request: LoginType.ERROR,
              msg: 'Sai mật khẩu. Vui lòng kiểm tra lại mật khẩu của bạn'));
          Provider.of<AuthenProvider>(context, listen: false)
              .checkStateLogin(true);
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
              request: LoginType.LOGIN,
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
        await loginRepository.checkExistPhone(event.phone).then(
          (value) {
            if (value is InfoUserDTO) {
              // Provider.of<RegisterProvider>(context, listen: false)
              //     .updatePhone(event.phone);

              emit(
                state.copyWith(
                    request: LoginType.CHECK_EXIST,
                    status: BlocStatus.UNLOADING,
                    infoUserDTO: value),
              );
            }
          },
        ).catchError((onError) {
          emit(
            state.copyWith(
              request: LoginType.REGISTER,
              status: BlocStatus.UNLOADING,
              phone: event.phone,
            ),
          );
        });
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
