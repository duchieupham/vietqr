// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankCardBloc extends Bloc<BankCardEvent, BankCardState> {
  BankCardBloc() : super(BankCardInitialState()) {
    on<BankCardEventInsert>(_insertBankCard);
    on<BankCardEventGetList>(_getBankAccounts);
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardEventRequestOTP>(_requestOTP);
    on<BankCardEventConfirmOTP>(_confirmOTP);
    on<BankCardGetDetailEvent>(_getDetail);
    on<BankCardCheckExistedEvent>(_checkExistedBank);
    on<BankCardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();

void _insertBankCardUnauthenticated(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventInsertUnauthenticated) {
      emit(BankCardLoadingState());
      final ResponseMessageDTO result =
          await bankCardRepository.insertBankCardUnauthenticated(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardInsertUnauthenticatedSuccessState());
      } else {
        emit(BankCardInsertUnauthenticatedFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO dto =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(BankCardInsertUnauthenticatedFailedState(
        msg: ErrorUtils.instance.getErrorMessage(dto.message)));
  }
}

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
      final List<Color> colors = [];
      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      if (list.isNotEmpty) {
        for (BankAccountDTO dto in list) {
          NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
          paletteGenerator = await PaletteGenerator.fromImageProvider(image);
          if (paletteGenerator.dominantColor != null) {
            colors.add(paletteGenerator.dominantColor!.color);
          } else {
            colors.add(Theme.of(context).cardColor);
          }
        }
      }
      emit(BankCardGetListSuccessState(list: list, colors: colors));
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
      emit(BankCardReuqestOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.requestOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(
          BankCardRequestOTPSuccessState(
            dto: event.dto,
            requestId: responseMessageDTO.message,
          ),
        );
      } else {
        emit(BankCardRequestOTPFailedState(
            message: ErrorUtils.instance
                .getErrorMessage(responseMessageDTO.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(BankCardRequestOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message)));
  }
}

void _confirmOTP(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventConfirmOTP) {
      emit(BankCardConfirmOTPLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.confirmOTP(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardConfirmOTPSuccessState());
      } else {
        emit(
          BankCardConfirmOTPFailedState(
            message:
                ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          ),
        );
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    ResponseMessageDTO responseMessageDTO =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    emit(
      BankCardConfirmOTPFailedState(
        message:
            ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
      ),
    );
  }
}

void _getDetail(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardGetDetailEvent) {
      emit(BankCardGetDetailLoadingState());
      final AccountBankDetailDTO dto =
          await bankCardRepository.getAccountBankDetail(event.bankId);
      emit(BankCardGetDetailSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankCardGetDetailFailedState());
  }
}

void _checkExistedBank(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardCheckExistedEvent) {
      emit(BankCardLoadingState());
      final ResponseMessageDTO result = await bankCardRepository
          .checkExistedBank(event.bankAccount, event.bankTypeId);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardCheckNotExistedState());
      } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
        emit(BankCardCheckExistedState(
            msg: CheckUtils.instance.getCheckMessage(result.message)));
      } else {
        emit(BankCardCheckFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankCardCheckFailedState());
  }
}
