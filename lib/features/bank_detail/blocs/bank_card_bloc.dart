// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankCardBloc extends Bloc<BankCardEvent, BankCardState> {
  final String bankId;

  BankCardBloc(this.bankId) : super(BankCardState(bankId: bankId)) {
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardGetDetailEvent>(_getDetail);
    on<BankCardEventUnlink>(_unlinkBankAccount);
    on<BankCardEventUnConfirmOTP>(_unConfirmOTP);
    on<UpdateEvent>(_updateEvent);
  }

  void _getDetail(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardGetDetailEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING_PAGE,
            request: BankDetailType.NONE,
          ),
        );
        final AccountBankDetailDTO dto =
            await bankCardRepository.getAccountBankDetail(bankId);
        emit(
          state.copyWith(
            bankDetailDTO: dto,
            status: BlocStatus.NONE,
            request: BankDetailType.SUCCESS,
            bankId: bankId,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: BankDetailType.ERROR,
      ));
    }
  }

  void _removeBankAccount(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRemove) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankDetailType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.removeBankAccount(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: BankDetailType.DELETED, status: BlocStatus.UNLOADING));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: BankDetailType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: BankDetailType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: BankDetailType.ERROR,
      ));
    }
  }

  void _unlinkBankAccount(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventUnlink) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankDetailType.NONE));
        final ResponseMessageDTO responseMessageDTO = await bankCardRepository
            .unRequestOTP({
          "accountNumber": event.accountNumber,
          "applicationType": "MOBILE"
        });
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: BankDetailType.UN_LINK,
            status: BlocStatus.UNLOADING,
            requestId: responseMessageDTO.message,
          ));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: BankDetailType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: BankDetailType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: BankDetailType.ERROR,
      ));
    }
  }

  void _unConfirmOTP(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventUnConfirmOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankDetailType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.unConfirmOTP(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: BankDetailType.OTP, status: BlocStatus.UNLOADING));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: BankDetailType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: BankDetailType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: BankDetailType.ERROR,
      ));
    }
  }

  void _updateEvent(BankCardEvent event, Emitter emit) {
    emit(state.copyWith(status: BlocStatus.NONE, request: BankDetailType.NONE));
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();
