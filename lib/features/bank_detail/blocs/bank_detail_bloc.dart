import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

import '../events/bank_detail_event.dart';
import '../states/bank_detail_state.dart';

class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  BankDetailBloc() : super(BankDetailState()) {
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardGetDetailEvent>(_getDetail);
  }

  final bankCardRepository = const BankCardRepository();

  void _getDetail(BankDetailEvent event, Emitter emit) async {
    try {
      if (event is BankCardGetDetailEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final AccountBankDetailDTO dto =
            await bankCardRepository.getAccountBankDetail(event.bankId);
        emit(state.copyWith(status: BlocStatus.SUCCESS, bankDetailDTO: dto));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _removeBankAccount(BankDetailEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRemove) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.removeBankAccount(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(status: BlocStatus.DELETE));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: message));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: message));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối'));
    }
  }
}
