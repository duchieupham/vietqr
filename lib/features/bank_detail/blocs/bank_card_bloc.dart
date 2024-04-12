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
import 'package:vierqr/features/transaction_detail/blocs/transaction_bloc.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/merchant_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

class BankCardBloc extends Bloc<BankCardEvent, BankCardState> {
  final String bankId;
  final bool isLoading;

  BankCardBloc(this.bankId, {this.isLoading = true})
      : super(BankCardState(bankId: bankId)) {
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardGetDetailEvent>(_getDetail);
    on<BankCardEventUnRequestOTP>(_requestOTP);
    on<BankCardEventUnConfirmOTP>(_unConfirmOTP);
    on<BankCardEventUnLink>(_unLinkedBIDV);
    on<UpdateEvent>(_updateEvent);
    on<BankCardGenerateDetailQR>(_createQRUnAuthen);
    // on<GetMyListGroupEvent>(_getMyListGroup);
    on<GetMyListGroupEvent>(_getMyListGroupTrans);
    on<GetMerchantEvent>(_getMerchant);
  }

  void _getDetail(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardGetDetailEvent) {
        emit(state.copyWith(
            status: (event.isLoading || event.isInit)
                ? BlocStatus.LOADING_PAGE
                : BlocStatus.NONE,
            request: BankDetailType.NONE));
        final AccountBankDetailDTO dto =
            await bankCardRepository.getAccountBankDetail(bankId);

        emit(
          state.copyWith(
            bankDetailDTO: dto,
            status: BlocStatus.NONE,
            request: BankDetailType.SUCCESS,
            bankId: bankId,
            isInit: event.isInit,
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

  void _getMerchant(BankCardEvent event, Emitter emit) async {
    try {
      if (event is GetMerchantEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: BankDetailType.NONE));
        final result = await bankCardRepository.getMerchantInfo(bankId);
        bool isRegisterMerchant = false;
        if (result != null) {
          if (result is ResponseMessageDTO) {
            isRegisterMerchant = false;
            emit(state.copyWith(
                status: BlocStatus.NONE,
                request: BankDetailType.GET_MERCHANT_INFO,
                isRegisterMerchant: isRegisterMerchant));
          } else if (result is MerchantDTO) {
            isRegisterMerchant = true;
            emit(state.copyWith(
                status: BlocStatus.NONE,
                merchantDTO: result,
                request: BankDetailType.GET_MERCHANT_INFO,
                isRegisterMerchant: isRegisterMerchant));
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.NONE,
        request: BankDetailType.ERROR,
      ));
    }
  }

  void _createQRUnAuthen(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardGenerateDetailQR) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            request: BankDetailType.NONE,
          ),
        );
        final QRGeneratedDTO dto =
            await bankCardRepository.generateQR(event.dto);
        emit(
          state.copyWith(
            qrGeneratedDTO: dto,
            status: BlocStatus.NONE,
            request: BankDetailType.CREATE_QR,
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

  void _requestOTP(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventUnRequestOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankDetailType.NONE));
        final ResponseMessageDTO responseMessageDTO = await bankCardRepository
            .unRequestOTP({
          "accountNumber": event.accountNumber,
          "applicationType": "MOBILE"
        });
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            request: BankDetailType.REQUEST_OTP,
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

  void _unLinkedBIDV(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventUnLink) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankDetailType.NONE));
        final response = await bankCardRepository.unLinked(event.body);
        if (response.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: BankDetailType.UN_LINK_BIDV,
              status: BlocStatus.UNLOADING));
        } else if (response.status == Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(response.message);
          emit(state.copyWith(
              msg: message,
              request: BankDetailType.ERROR,
              status: BlocStatus.UNLOADING));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(response.message);
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

  // void _getMyListGroup(BankCardEvent event, Emitter emit) async {
  //   try {
  //     if (event is GetMyListGroupEvent) {
  //       emit(state.copyWith(request: BankDetailType.NONE));

  //       final TerminalDto terminalDto = await transactionRepository
  //           .getMyListGroup(event.userID, bankId, event.offset);

  //       emit(state.copyWith(
  //         terminalDto: terminalDto,
  //         request: BankDetailType.GET_LIST_GROUP,
  //       ));
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     emit(state.copyWith(status: BlocStatus.NONE));
  //   }
  // }


  void _getMyListGroupTrans(BankCardEvent event, Emitter emit) async {
    try {
      if (event is GetMyListGroupEvent) {
        emit(state.copyWith(request: BankDetailType.NONE));

        final TerminalAccountDTO  terminaAccountlDto = await transactionRepository
            .getMyListGroupTrans(event.userID, bankId, event.offset);
        emit(state.copyWith(
          status: BlocStatus.NONE,
          terminalAccountDto: terminaAccountlDto,
          request: BankDetailType.GET_LIST_GROUP,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE));
    }
  }

  void _updateEvent(BankCardEvent event, Emitter emit) {
    emit(state.copyWith(status: BlocStatus.NONE, request: BankDetailType.NONE));
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();
