import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/repostiroties/dashboard_repository.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState>
    with BaseManager {
  @override
  final BuildContext context;

  DashBoardBloc(this.context) : super(const DashBoardState(themes: [])) {
    on<TokenEventCheckValid>(_checkValidToken);
    on<TokenFcmUpdateEvent>(_updateFcmToken);
    on<GetUserInformation>(_getUserInformation);
    on<TokenEventLogout>(_logout);
    on<PermissionEventGetStatus>(_getPermissionStatus);
    on<GetPointEvent>(_getPointAccount);
    on<GetVersionAppEvent>(_getVersionApp);
    on<PermissionEventRequest>(_requestPermissions);
    on<DashBoardEventSearchName>(_searchBankName);
    on<DashBoardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
    on<UpdateEvent>(_updateEvent);
    on<GetListThemeEvent>(_getListTheme);
    on<UpdateThemeEvent>(_updateTheme);
    on<UpdateKeepBrightEvent>(_updateKeepBright);
  }

  void _checkValidToken(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is TokenEventCheckValid) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        int check = await dashBoardRepository.checkValidToken();
        TokenType type = TokenType.NONE;
        if (check == 0) {
          type = TokenType.InValid;
        } else if (check == 1) {
          type = TokenType.Valid;
        } else if (check == 2) {
          type = TokenType.MainSystem;
        } else if (check == 3) {
          type = TokenType.Internet;
        } else if (check == 4) {
          type = TokenType.Expired;
        }

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.TOKEN,
            typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DashBoardType.TOKEN,
          typeToken: TokenType.InValid));
    }
  }

  void _logout(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is TokenEventLogout) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        bool check = await accRepository.logout();
        TokenType type = TokenType.NONE;
        if (check) {
          type = TokenType.Logout;
        } else {
          type = TokenType.Logout_failed;
        }

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.TOKEN,
            typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DashBoardType.TOKEN,
          typeToken: TokenType.Logout_failed));
    }
  }

  void _updateFcmToken(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is TokenFcmUpdateEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        bool check = await dashBoardRepository.updateFcmToken();
        TokenType type = TokenType.NONE;
        if (check) {
          type = TokenType.Fcm_success;
        } else {
          type = TokenType.Fcm_failed;
        }
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.TOKEN,
            typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DashBoardType.TOKEN,
          typeToken: TokenType.Fcm_failed));
    }
  }

  void _getPointAccount(DashBoardEvent event, Emitter emit) async {
    try {
      emit(
          state.copyWith(status: BlocStatus.NONE, request: DashBoardType.NONE));
      if (event is GetPointEvent) {
        final result = await dashBoardRepository.getPointAccount(userId);
        await UserInformationHelper.instance.setWalletId(result.walletId!);
        emit(state.copyWith(
          introduceDTO: result,
          status: BlocStatus.NONE,
          request: DashBoardType.POINT,
        ));
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _getVersionApp(DashBoardEvent event, Emitter emit) async {
    try {
      emit(
          state.copyWith(status: BlocStatus.NONE, request: DashBoardType.NONE));
      if (event is GetVersionAppEvent) {
        final result = await dashBoardRepository.getVersionApp();

        print(result.themeVer);
        emit(state.copyWith(
          appInfoDTO: result,
          status: BlocStatus.NONE,
          request: DashBoardType.APP_VERSION,
          isCheckApp: event.isCheckVer,
        ));
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _getPermissionStatus(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventGetStatus) {
        Map<String, PermissionStatus> permissions =
            await dashBoardRepository.checkPermissions();
        // if (!permissions['sms']!.isGranted) {
        //   emit(PermissionSmsDeniedState());
        // } else {
        //   emit(PermissionSMSAllowedState());
        // }
        if (!permissions['camera']!.isGranted) {
          emit(state.copyWith(
              typePermission: DashBoardTypePermission.CameraDenied));
        } else {
          emit(state.copyWith(
              typePermission: DashBoardTypePermission.CameraAllow));
        }
        // if (permissions['sms']!.isGranted && permissions['camera']!.isGranted) {
        //   emit(PermissionAllowedState());
        //}
      }
    } catch (e) {
      LOG.error('Error at _getPermissionStatus - PermissionBloc: $e');
      emit(state.copyWith(typePermission: DashBoardTypePermission.Error));
    }
  }

  void _requestPermissions(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventRequest) {
        bool check = await dashBoardRepository.requestPermissions();
        if (check) {
          emit(state.copyWith(typePermission: DashBoardTypePermission.Allow));
        } else {
          emit(state.copyWith(typePermission: DashBoardTypePermission.Request));
        }
      }
    } catch (e) {
      LOG.error('Error at _requestPermissions - PermissionBloc: $e');
      emit(state.copyWith(typePermission: DashBoardTypePermission.Error));
    }
  }

  void _searchBankName(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardEventSearchName) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              informationDTO: dto,
              request: DashBoardType.SEARCH_BANK_NAME));
        } else {
          emit(
            state.copyWith(
              request: DashBoardType.SCAN_NOT_FOUND,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: DashBoardType.SCAN_NOT_FOUND, status: BlocStatus.NONE));
    }
  }

  void _insertBankCardUnauthenticated(
      DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardEventInsertUnauthenticated) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        final ResponseMessageDTO result =
            await bankCardRepository.insertBankCardUnauthenticated(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(
            state.copyWith(
                request: DashBoardType.INSERT_BANK,
                status: BlocStatus.UNLOADING),
          );
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.UNLOADING,
              request: DashBoardType.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
        msg: ErrorUtils.instance.getErrorMessage(dto.message),
        status: BlocStatus.UNLOADING,
        request: DashBoardType.ERROR,
      ));
    }
  }

  void _getUserInformation(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is GetUserInformation) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        final result = await accRepository.getUserInformation(userId);
        if (result.userId.isNotEmpty) {
          await UserInformationHelper.instance.setAccountInformation(result);
        }
        final settingAccount = await accRepository.getSettingAccount(userId);
        if (settingAccount.userId.isNotEmpty) {
          await UserInformationHelper.instance
              .setAccountSetting(settingAccount);
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: DashBoardType.GET_USER_SETTING));
        }
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
    }
  }

  void _getListTheme(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is GetListThemeEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        List<ThemeDTO> result = await accRepository.getListTheme();
        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DashBoardType.THEMES,
          themes: result,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _updateTheme(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is UpdateThemeEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        final ResponseMessageDTO result = await accRepository.updateTheme(
          UserInformationHelper.instance.getUserId(),
          event.type,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          ThemeDTO dto =
              state.themes.where((element) => element.type == event.type).first;

          emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.UPDATE_THEME,
            themeDTO: dto,
          ));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.NONE,
              request: DashBoardType.UPDATE_THEME_ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
        msg: ErrorUtils.instance.getErrorMessage(dto.message),
        status: BlocStatus.NONE,
        request: DashBoardType.UPDATE_THEME_ERROR,
      ));
    }
  }

  void _updateKeepBright(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is UpdateKeepBrightEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        final ResponseMessageDTO result = await accRepository.updateKeepBright(
          UserInformationHelper.instance.getUserId(),
          event.keepValue,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(
            state.copyWith(
                status: BlocStatus.NONE,
                request: DashBoardType.KEEP_BRIGHT,
                keepValue: event.keepValue),
          );
        } else {
          emit(
            state.copyWith(
                msg: ErrorUtils.instance.getErrorMessage(result.message),
                request: DashBoardType.ERROR),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO responseMessageDTO = const ResponseMessageDTO(
        status: 'FAILED',
        message: 'E05',
      );

      emit(
        state.copyWith(
            msg:
                ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
            request: DashBoardType.ERROR),
      );

      LOG.error(e.toString());
    }
  }

  void _updateEvent(DashBoardEvent event, Emitter emit) {
    emit(state.copyWith(
      status: BlocStatus.NONE,
      request: DashBoardType.NONE,
      typePermission: DashBoardTypePermission.None,
      typeQR: TypeQR.NONE,
    ));
  }
}

DashboardRepository dashBoardRepository = const DashboardRepository();
