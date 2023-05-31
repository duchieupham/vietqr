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
import 'package:vierqr/models/bank_name_information_dto.dart';
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
    on<BankCardEventRegisterAuthentication>(_registerAuthentication);
    on<BankCardEventSearchName>(_searchBankName);
  }
}

const BankCardRepository bankCardRepository = BankCardRepository();

void _registerAuthentication(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventRegisterAuthentication) {
      emit(BankCardLoadingState());
      final ResponseMessageDTO result =
          await bankCardRepository.updateRegisterAuthenticationBank(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardUpdateAuthenticateSuccessState());
      } else {
        emit(BankCardUpdateAuthenticateFailedState(
            msg: ErrorUtils.instance.getErrorMessage(result.message)));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
  }
}

void _insertBankCardUnauthenticated(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventInsertUnauthenticated) {
      emit(BankCardLoadingState());
      final ResponseMessageDTO result =
          await bankCardRepository.insertBankCardUnauthenticated(event.dto);
      if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        String bankId = '';
        String qr = '';
        if (result.message.isNotEmpty) {
          if (result.message.contains('*')) {
            bankId = result.message.split('*')[0];
            qr = result.message.split('*')[1];
          }
        }
        emit(
          BankCardInsertUnauthenticatedSuccessState(
            bankId: bankId,
            qr: qr,
          ),
        );
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
        String bankId = '';
        String qr = '';
        if (responseMessageDTO.message.isNotEmpty) {
          if (responseMessageDTO.message.contains('*')) {
            bankId = responseMessageDTO.message.split('*')[0];
            qr = responseMessageDTO.message.split('*')[1];
          }
        }
        emit(
          BankCardInsertSuccessfulState(bankId: bankId, qr: qr),
        );
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
      emit(BankCardLoadingListState());
      List<BankAccountDTO> list =
          await bankCardRepository.getListBankAccount(event.userId);
      final List<Color> colors = [];
      PaletteGenerator? paletteGenerator;
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      if (list.isNotEmpty) {
        List<BankAccountDTO> listLinked =
            list.where((e) => e.isAuthenticated).toList();
        List<BankAccountDTO> listNotLinked =
            list.where((e) => !e.isAuthenticated).toList();

        list = [...listLinked, ...listNotLinked];

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
      emit(BankCardRemoveLoadingState());
      final ResponseMessageDTO responseMessageDTO =
          await bankCardRepository.removeBankAccount(event.dto);
      if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(BankCardRemoveSuccessState());
      } else if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_CHECK) {
        String message =
            CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
        emit(BankCardRemoveFailedState(message: message));
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

void _searchBankName(BankCardEvent event, Emitter emit) async {
  try {
    if (event is BankCardEventSearchName) {
      emit(BankCardSearchingNameState());
      BankNameInformationDTO dto =
          await bankCardRepository.searchBankName(event.dto);
      if (dto.accountName.trim().isNotEmpty) {
        emit(BankCardSearchNameSuccessState(dto: dto));
      } else {
        emit(const BankCardSearchNameFailedState(
            msg: 'Không tìm thấy tên chủ TK'));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(const BankCardSearchNameFailedState(msg: 'Không tìm thấy tên chủ TK'));
  }
}
