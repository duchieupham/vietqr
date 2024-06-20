// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/popup_bank/events/popup_bank_event.dart';
import 'package:vierqr/features/popup_bank/states/popup_bank_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class PopupBankBloc extends Bloc<PopupBankEvent, PopupBankState> {
  final BankAccountDTO bankAccountDTO;

  PopupBankBloc(this.bankAccountDTO)
      : super(PopupBankState(bankAccountDTO: bankAccountDTO)) {
    on<PopupBankEventRemove>(_removeBankAccount);
    on<PopupBankEventUnlink>(_unlinkBankAccount);
    on<PopupUnLinkBIDVEvent>(_unLinkBidv);
    on<PopupBankEventUnConfirmOTP>(_unConfirmOTP);
    on<PopupBankEventUnRegisterBDSD>(_unRegisterBDSD);
    on<UpdateBankAccountEvent>(_updateBankAccount);
  }

  void _updateBankAccount(PopupBankEvent event, Emitter emit) async {
    if (event is UpdateBankAccountEvent) {
      emit(state.copyWith(
          status: BlocStatus.NONE,
          bankAccountDTO: event.dto,
          request: PopupBankType.UPDATE));
    }
  }

  void _unLinkBidv(PopupBankEvent event, Emitter emit) async {
    try {
      if (event is PopupUnLinkBIDVEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: PopupBankType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.unLinked(event.request);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: PopupBankType.UNLINK_BIDV,
            status: BlocStatus.UNLOADING,
          ));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: PopupBankType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: PopupBankType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: PopupBankType.ERROR,
      ));
    }
  }

  void _unRegisterBDSD(PopupBankEvent event, Emitter emit) async {
    try {
      if (event is PopupBankEventUnRegisterBDSD) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: PopupBankType.NONE));
        final ResponseMessageDTO responseMessageDTO = await bankCardRepository
            .unRegisterBDSD(userId: event.userId, bankId: event.bankId);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: PopupBankType.UN_BDSD, status: BlocStatus.UNLOADING));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: PopupBankType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: PopupBankType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: PopupBankType.ERROR,
      ));
    }
  }

  void _removeBankAccount(PopupBankEvent event, Emitter emit) async {
    try {
      if (event is PopupBankEventRemove) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: PopupBankType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.removeBankAccount(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: PopupBankType.DELETED, status: BlocStatus.UNLOADING));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: PopupBankType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: PopupBankType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: PopupBankType.ERROR,
      ));
    }
  }

  void _unlinkBankAccount(PopupBankEvent event, Emitter emit) async {
    try {
      if (event is PopupBankEventUnlink) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: PopupBankType.NONE));
        final ResponseMessageDTO responseMessageDTO = await bankCardRepository
            .unRequestOTP({
          "accountNumber": event.accountNumber,
          "applicationType": "MOBILE"
        });
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: PopupBankType.UN_LINK,
            status: BlocStatus.UNLOADING,
            requestId: responseMessageDTO.message,
          ));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: PopupBankType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: PopupBankType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: PopupBankType.ERROR,
      ));
    }
  }

  void _unConfirmOTP(PopupBankEvent event, Emitter emit) async {
    try {
      if (event is PopupBankEventUnConfirmOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: PopupBankType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.unConfirmOTP(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          BankAccountDTO dto = state.bankAccountDTO;
          dto.isAuthenticated = false;
          emit(state.copyWith(
              request: PopupBankType.OTP,
              status: BlocStatus.UNLOADING,
              bankAccountDTO: dto));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(
              msg: message,
              request: PopupBankType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            msg: message,
            status: BlocStatus.UNLOADING,
            request: PopupBankType.ERROR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối',
        status: BlocStatus.UNLOADING,
        request: PopupBankType.ERROR,
      ));
    }
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();
