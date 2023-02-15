import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/personal/events/bank_manage_event.dart';
import 'package:vierqr/features/bank_card/repositories/bank_manage_repository.dart';
import 'package:vierqr/features/bank_card/states/bank_manage_state.dart';
import 'package:vierqr/models/account_balance_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankManageBloc extends Bloc<BankManageEvent, BankManageState> {
  BankManageBloc() : super(BankManageInitialState()) {
    // on<BankManageEventGetList>(_getListBankAccount);
    on<BankManageEventAddDTO>(_addBankAccount);
    on<BankManageEventRemoveDTO>(_removeBankAccount);
    on<BankManageEventGetDTO>(_getBankAccount);
    on<BankManageEventGetAccountBalance>(_getAccountBalance);
  }

  final BankManageRepository bankManageRepository =
      const BankManageRepository();

  // void _getListBankAccount(BankManageEvent event, Emitter emit) async {
  //   try {
  //     if (event is BankManageEventGetList) {
  //       emit(BankManageLoadingListState());
  //       final List<BankAccountDTO> list =
  //           await bankManageRepository.getListBankAccount(event.userId);
  //       emit(
  //         BankManageListSuccessState(list: list),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error at getListBankAccount - BankManageBloc: $e');
  //     emit(BankManageListFailedState());
  //   }
  // }

  void _addBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventAddDTO) {
        emit(BankManageLoadingState());
        bool result = await bankManageRepository.addBankAccount(
          event.userId,
          event.dto,
          event.phoneNo,
        );
        if (result) {
          emit(BankManageAddSuccessState());
        }
      }
    } catch (e) {
      print('Error at getListBankAccount - BankManageBloc: $e');
      emit(BankManageAddFailedState());
    }
  }

  void _removeBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventRemoveDTO) {
        emit(BankManageLoadingState());
        bool result = await bankManageRepository.removeBankAccount(
            event.userId, event.bankCode, event.bankId);
        if (result) {
          emit(BankManageRemoveSuccessState());
        }
      }
    } catch (e) {
      print('Error at getListBankAccount - BankManageBloc: $e');
      emit(BankManageRemoveFailedState());
    }
  }

  void _getBankAccount(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventGetDTO) {
        // BankAccountDTO dto =
        //     await bankManageRepository.getBankAccountByUserIdAndBankAccount(
        //         event.userId, event.bankAccount);
        // emit(BankManageGetDTOSuccessfulState(bankAccountDTO: dto));
      }
    } catch (e) {
      print('Error at _getBankAccount - BankManageBloc: $e');
      emit(BankManageGetDTOFailedState());
    }
  }

  void _getAccountBalance(BankManageEvent event, Emitter emit) async {
    try {
      if (event is BankManageEventGetAccountBalance) {
        // AccountBalanceDTO dto =
        await bankManageRepository.getBankToken();
        AccountBalanceDTO dto = await bankManageRepository.getAccountBalace(
            event.customerId, event.accountNumber);
        emit(BankManageGetAccountBalanceSuccessState(accountBalanceDTO: dto));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(BankManageGetAccountBalanceFailedState());
    }
  }
}
