import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankCardBloc extends Bloc<BankCardEvent, BankCardState> {
  BankCardBloc() : super(BankCardInitialState()) {
    on<BankCardEventInsert>(_insertBankCard);
    on<BankCardEventGetList>(_getBankAccounts);
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardEventRequestOTP>(_requestOTP);
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();

void _insertBankCard(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventInsert) {
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.insertBankCard(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardInsertSuccessfulState());
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankCardInsertFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankCardInsertFailedState(
        message: 'Không thể thêm tài khoản. Vui lòng kiểm tra lại kết nối.'));
  }
}

void _getBankAccounts(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventGetList) {
      emit(BankCardLoadingState());
      final List<BankAccountDTO> list =
          await bankCardRepository.getListBankAccount(event.userId);
      emit(BankCardGetListSuccessState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankCardInsertFailedState(
        message: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
  }
}

void _removeBankAccount(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventRemove) {
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.removeBankAccount(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardRemoveSuccessState());
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankCardRemoveFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankCardRemoveFailedState(
        message: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối'));
  }
}

void _requestOTP(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventRequestOTP) {
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.requestOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardRequestOTPSuccessState(
            requestId: responseMessageDTO.message));
      } else {
        emit(
            BankCardRequestOTPFailedState(message: responseMessageDTO.message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}
