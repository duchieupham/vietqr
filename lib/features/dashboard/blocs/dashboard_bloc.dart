import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState>
    with BaseManager {
  @override
  final BuildContext context;

  DashBoardBloc(this.context)
      : super(const DashBoardState(themes: [], listBanks: [])) {
    on<TokenEventCheckValid>(_checkValidToken);
    on<TokenFcmUpdateEvent>(_updateFcmToken);
    on<GetUserInformation>(_getUserInformation);
    on<TokenEventLogout>(_logout);
    on<GetPointEvent>(_getPointAccount);
    on<GetVersionAppEvent>(_getVersionApp);
    on<UpdateEvent>(_updateEvent);
    on<GetListThemeEvent>(_getListTheme);
    on<GetBanksEvent>(_getListBankTypes);
    on<UpdateThemeEvent>(_updateTheme);
    on<UpdateKeepBrightEvent>(_updateKeepBright);
    on<GetCountNotifyEvent>(_getCounter);
    on<NotifyUpdateStatusEvent>(_updateNotificationStatus);
  }

  Future _getListBankTypes(DashBoardEvent event, Emitter emit) async {
    if (banks.isNotEmpty) {
      emit(state.copyWith(
          listBanks: banks, request: DashBoardType.GET_BANK_LOCAL));
      return;
    }
    try {
      if (event is GetBanksEvent) {
        List<BankTypeDTO> list = await bankCardRepository.getBankTypes();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
          banks = list;
          emit(
              state.copyWith(listBanks: list, request: DashBoardType.GET_BANK));
        } else {
          emit(state.copyWith(status: BlocStatus.ERROR));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
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
        await UserHelper.instance.setWalletId(result.walletId!);
        emit(state.copyWith(
            introduceDTO: result,
            status: BlocStatus.NONE,
            request: DashBoardType.POINT));
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
        if (result.id.isNotEmpty) {
          result.isCheckApp = event.isCheckVer;
          emit(state.copyWith(
            appInfoDTO: result,
            status: BlocStatus.NONE,
            request: DashBoardType.APP_VERSION,
          ));
        } else {
          emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
        }
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _getUserInformation(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is GetUserInformation) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        final result = await accRepository.getUserInformation(userId);
        if (result.userId.isNotEmpty) {
          await UserHelper.instance.setAccountInformation(result);
        }
        final settingAccount = await accRepository.getSettingAccount(userId);
        if (settingAccount.userId.isNotEmpty) {
          await UserHelper.instance.setAccountSetting(settingAccount);
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
            themes: result));
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
        final result = await accRepository.updateTheme(
          UserHelper.instance.getUserId(),
          event.type,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          ThemeDTO dto =
              state.themes.where((element) => element.type == event.type).first;

          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: DashBoardType.UPDATE_THEME,
              themeDTO: dto));
        } else {
          emit(state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.NONE,
              request: DashBoardType.UPDATE_THEME_ERROR));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      final dto = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
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
        final result = await accRepository.updateKeepBright(
          UserHelper.instance.getUserId(),
          event.keepValue,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: DashBoardType.KEEP_BRIGHT,
              keepValue: event.keepValue));
        } else {
          emit(state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              request: DashBoardType.ERROR));
        }
      }
    } catch (e) {
      final res = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(res.message),
          request: DashBoardType.ERROR));
      LOG.error(e.toString());
    }
  }

  void _getCounter(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is GetCountNotifyEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        int counter = await notificationRepository.getCounter(userId);
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.COUNT_NOTIFY,
            countNotify: counter));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(msg: '', status: BlocStatus.NONE));
    }
  }

  void _updateNotificationStatus(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is NotifyUpdateStatusEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        bool check =
            await notificationRepository.updateNotificationStatus(userId);
        if (check) {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: DashBoardType.UPDATE_STATUS_NOTIFY,
              countNotify: 0));
        } else {
          emit(state.copyWith(msg: '', status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(msg: '', status: BlocStatus.NONE));
    }
  }

  void _updateEvent(DashBoardEvent event, Emitter emit) {
    emit(state.copyWith(
      status: BlocStatus.NONE,
      request: DashBoardType.NONE,
      typeQR: TypeQR.NONE,
    ));
  }
}

DashboardRepository dashBoardRepository = const DashboardRepository();
