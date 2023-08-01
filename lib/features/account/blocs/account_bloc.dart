import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/account/repositories/account_res.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/features/logout/repositories/log_out_repository.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    on<InitAccountEvent>(_getPointAccount);
    on<LogoutEventSubmit>(_logOutSubmit);
    on<UpdateAvatarEvent>(_updateAvatar);
  }

  final logoutRepository = const LogoutRepository();

  void _getPointAccount(AccountEvent event, Emitter emit) async {
    String userId = UserInformationHelper.instance.getUserId();
    try {
      emit(state.copyWith(status: BlocStatus.NONE, request: AccountType.NONE));
      if (event is InitAccountEvent) {
        final result = await accRepository.getPointAccount(userId);
        await UserInformationHelper.instance.setWalletId(result.walletId!);
        emit(state.copyWith(
          introduceDTO: result,
          status: BlocStatus.NONE,
          request: AccountType.POINT,
        ));
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }

  void _logOutSubmit(AccountEvent event, Emitter emit) async {
    try {
      if (event is LogoutEventSubmit) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AccountType.NONE));
        bool check = await logoutRepository.logout();
        if (check) {
          emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: AccountType.LOG_OUT,
          ));
        } else {
          emit(state.copyWith(status: BlocStatus.ERROR));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _updateAvatar(AccountEvent event, Emitter emit) async {
    try {
      if (event is UpdateAvatarEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AccountType.NONE));
        final ResponseMessageDTO result = await accRepository.updateAvatar(
          event.imgId,
          event.userId,
          event.image,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, request: AccountType.AVATAR));
        } else {
          emit(
            state.copyWith(
                msg: ErrorUtils.instance.getErrorMessage(result.message),
                request: AccountType.ERROR),
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
            request: AccountType.ERROR),
      );

      LOG.error(e.toString());
    }
  }
}

AccountRepository accRepository = const AccountRepository();
