import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/account/repositories/account_res.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    on<InitAccountEvent>(_getPointAccount);
  }

  String userId = UserInformationHelper.instance.getUserId();

  void _getPointAccount(AccountEvent event, Emitter emit) async {
    try {
      if (event is InitAccountEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final result = await accRepository.getPointAccount(userId);
        emit(state.copyWith(introduceDTO: result, status: BlocStatus.SUCCESS));
      }
    } catch (e) {
      LOG.error('Error at _getPointAccount: $e');
      emit(state.copyWith(msg: '', status: BlocStatus.ERROR));
    }
  }
}

AccountRepository accRepository = const AccountRepository();
