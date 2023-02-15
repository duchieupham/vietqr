import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_member/events/bank_member_event.dart';
import 'package:vierqr/features/bank_member/repositoties/bank_member_repository.dart';
import 'package:vierqr/features/bank_member/states/bank_member_state.dart';
import 'package:vierqr/models/bank_member_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankMemberBloc extends Bloc<BankMemberEvent, BankMemberState> {
  BankMemberBloc() : super(BankMemberInitialState()) {
    on<BankMemberEventGetList>(_getBankMembers);
    on<BankMemberEventCheck>(_checkBankMember);
    on<BankMemberEventInsert>(_insertBankMember);
    on<BankMemberInitialEvent>(_initial);
    on<BankMemberRemoveEvent>(_removeBankMember);
  }
}

const BankMemberRepository bankMemberRepository = BankMemberRepository();

void _getBankMembers(BankMemberEvent event, Emitter emit) async {
  try {
    if (event is BankMemberEventGetList) {
      final List<BankMemberDTO> list =
          await bankMemberRepository.getBankMembersByBankId(event.bankId);
      emit(BankMemberGetListSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankMemberGetListFailedState());
  }
}

void _initial(BankMemberEvent event, Emitter emit) async {
  if (event is BankMemberInitialEvent) {
    emit(BankMemberInitialState());
  }
}

void _checkBankMember(BankMemberEvent event, Emitter emit) async {
  try {
    if (event is BankMemberEventCheck) {
      final dynamic responseDTO =
          await bankMemberRepository.checkBankMember(event.dto);
      if (responseDTO.status != null &&
          responseDTO.status == Stringify.RESPONSE_STATUS_FAILED) {
        if (responseDTO.message == 'E07') {
          emit(BankMemberCheckNotExistedState());
        } else if (responseDTO.message == 'E08') {
          emit(BankMemberCheckAddedBeforeState());
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseDTO.message);
          emit(BankMemberCheckFailedState(message: message));
        }
      } else {
        emit(BankMemberCheckSuccessfulState(dto: responseDTO));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankMemberCheckFailedState(
        message: 'Không thể thực hiện thao tác này. Vui lòng thử lại sau'));
  }
}

void _insertBankMember(BankMemberEvent event, Emitter emit) async {
  try {
    if (event is BankMemberEventInsert) {
      final ResponseMessageDTO responseMessageDTO =
          await bankMemberRepository.insertBankMember(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankMemberInsertSuccessfulState());
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankMemberInsertFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankMemberInsertFailedState(
        message: 'Không thể thực hiện thao tác này. Vui lòng thử lại sau'));
  }
}

void _removeBankMember(BankMemberEvent event, Emitter emit) async {
  try {
    if (event is BankMemberRemoveEvent) {
      ResponseMessageDTO responseMessageDTO =
          await bankMemberRepository.deleteBankMember(event.id);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankMemberRemoveSuccessfulState());
      } else {
        String message =
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
        emit(BankMemberRemoveFailedState(message: message));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankMemberRemoveFailedState(
        message: 'Không thể thực hiện thao tác này. Vui lòng thử lại sau'));
  }
}
