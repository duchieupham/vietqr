import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/account/repositories/account_res.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/features/logout/repositories/log_out_repository.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    on<InitAccountEvent>(_getPointAccount);
    on<LogoutEventSubmit>(_logOutSubmit);
  }

  String userId = UserInformationHelper.instance.getUserId();
  final logoutRepository = const LogoutRepository();

  void _getPointAccount(AccountEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(
          status: BlocStatus.LOADING, request: AccountType.NONE));
      if (event is InitAccountEvent) {
        final result = await accRepository.getPointAccount(userId);
        emit(state.copyWith(introduceDTO: result, status: BlocStatus.UNLOADING));
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
}

AccountRepository accRepository = const AccountRepository();
