import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/home/blocs/home_bloc.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class AddBankBloc extends Bloc<AddBankEvent, AddBankState> with BaseManager {
  @override
  final BuildContext context;

  AddBankBloc(this.context) : super(AddBankState(listBanks: [])) {
    on<LoadDataBankEvent>(_getBankTypes);
    on<BankCardEventSearchName>(_searchBankName);
    on<BankCardCheckExistedEvent>(_checkExistedBank);
    on<BankCardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
    on<BankCardEventRequestOTP>(_requestOTP);
    on<BankCardEventConfirmOTP>(_confirmOTP);
    on<BankCardEventInsert>(_insertBankCard);
    on<BankCardEventRegisterLinkBank>(_registerLinkBank);
    on<ScanQrEventGetBankType>(_getDataScan);
    on<UpdateAddBankEvent>(_updateEvent);
    on<RequestRegisterBankAccount>(_requestRegisterBankAccount);
  }

  final bankCardRepository = const BankCardRepository();

  void _getBankTypes(AddBankEvent event, Emitter emit) async {
    if (banks.isNotEmpty) {
      banks.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
      emit(state.copyWith(
          listBanks: banks, request: AddBankType.GET_BANK_LOCAL));
      return;
    }

    try {
      if (event is LoadDataBankEvent) {
        if (event.isLoading) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankTypeDTO> list = await bankCardRepository.getBankTypes();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
        }
        banks = list;
        emit(
          state.copyWith(
              listBanks: list,
              status: event.isLoading ? BlocStatus.UNLOADING : BlocStatus.NONE,
              request: AddBankType.LOAD_BANK),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _searchBankName(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventSearchName) {
        emit(
            state.copyWith(status: BlocStatus.NONE, request: AddBankType.NONE));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              informationDTO: dto,
              request: AddBankType.SEARCH_BANK));
        } else {
          emit(
            state.copyWith(
              msg: 'Tài khoản ngân hàng không tồn tại.',
              request: AddBankType.ERROR,
              status: BlocStatus.NONE,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Tài khoản ngân hàng không tồn tại.',
        request: AddBankType.ERROR,
        status: BlocStatus.NONE,
      ));
    }
  }

  void _checkExistedBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardCheckExistedEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
        final ResponseMessageDTO result =
            await bankCardRepository.checkExistedBank(
                event.bankAccount, event.bankTypeId, event.type, userId);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: AddBankType.EXIST_BANK, status: BlocStatus.UNLOADING));
        } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
          String title = 'Không thể liên kết';
          String msg =
              'Tài khoản đã được liên kết trước đó. Quý khách chỉ được lưu tài khoản này.';
          if (event.type == ExitsType.ADD.name) {
            title = 'Không thể thêm TK';
            msg = 'TK đã tồn tại trong danh sách TK ngân hàng của bạn';
          }
          emit(
            state.copyWith(
              request: AddBankType.ERROR_EXIST,
              status: BlocStatus.UNLOADING,
              msg: msg,
              titleMsg: title,
            ),
          );
        } else {
          emit(state.copyWith(
              request: AddBankType.ERROR_EXIST,
              status: BlocStatus.UNLOADING,
              titleMsg: null));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: AddBankType.ERROR));
    }
  }

  void _insertBankCardUnauthenticated(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventInsertUnauthenticated) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
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
            state.copyWith(
              bankId: bankId,
              qr: qr,
              request: AddBankType.INSERT_BANK,
              status: BlocStatus.UNLOADING,
            ),
          );
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.UNLOADING,
              request: AddBankType.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
        msg: ErrorUtils.instance.getErrorMessage(dto.message),
        status: BlocStatus.UNLOADING,
        request: AddBankType.ERROR,
      ));
    }
  }

  void _requestOTP(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRequestOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.requestOTP(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(
            state.copyWith(
              dto: event.dto,
              requestId: responseMessageDTO.message,
              status: BlocStatus.UNLOADING,
              request: AddBankType.REQUEST_BANK,
            ),
          );
        } else {
          if (responseMessageDTO.message == 'E05') {
            emit(state.copyWith(
              msg:
                  'Vui lòng kiểm tra thông tin đã khớp với thông tin khai báo MB Bank',
              request: AddBankType.ERROR_SYSTEM,
              status: BlocStatus.UNLOADING,
            ));
          } else {
            emit(
              state.copyWith(
                msg: ErrorUtils.instance
                    .getErrorMessage(responseMessageDTO.message),
                request: AddBankType.ERROR_SYSTEM,
                status: BlocStatus.UNLOADING,
              ),
            );
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg:
            'Vui lòng kiểm tra thông tin đã khớp với thông tin khai báo MB Bank',
        request: AddBankType.ERROR_SYSTEM,
        status: BlocStatus.UNLOADING,
      ));
    }
  }

  void _confirmOTP(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventConfirmOTP) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.confirmOTP(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(
            state.copyWith(
                status: BlocStatus.UNLOADING,
                request: AddBankType.OTP_BANK,
                ewalletToken: responseMessageDTO.ewalletToken),
          );
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: AddBankType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: AddBankType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _insertBankCard(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventInsert) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
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
          emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: AddBankType.INSERT_BANK,
            bankId: bankId,
            qr: qr,
          ));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: AddBankType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(
        state.copyWith(
          msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
          request: AddBankType.ERROR,
          status: BlocStatus.UNLOADING,
        ),
      );
    }
  }

  void _registerLinkBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRegisterLinkBank) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: AddBankType.NONE));
        final ResponseMessageDTO responseMessageDTO = await bankCardRepository
            .updateRegisterAuthenticationBank(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: AddBankType.INSERT_BANK,
          ));
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message),
              request: AddBankType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getDataScan(AddBankEvent event, Emitter emit) {
    if (event is ScanQrEventGetBankType) {
      emit(state.copyWith(
          request: AddBankType.NONE, status: BlocStatus.LOADING));
      NationalScannerDTO nationalScannerDTO =
          homeRepository.getNationalInformation(event.code);
      if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
        emit(
          state.copyWith(
            barCode: nationalScannerDTO.nationalId,
            request: AddBankType.SCAN_QR,
            status: BlocStatus.UNLOADING,
          ),
        );
      } else if (event.code.isNotEmpty) {
        emit(state.copyWith(
          barCode: event.code,
          request: AddBankType.SCAN_QR,
          status: BlocStatus.UNLOADING,
        ));
      } else {
        emit(state.copyWith(
          request: AddBankType.SCAN_NOT_FOUND,
          status: BlocStatus.UNLOADING,
        ));
      }
    }
  }

  void _updateEvent(AddBankEvent event, Emitter emit) {
    emit(state.copyWith(status: BlocStatus.NONE, request: AddBankType.NONE));
  }

  void _requestRegisterBankAccount(AddBankEvent event, Emitter emit) async {
    if (event is RequestRegisterBankAccount) {
      emit(state.copyWith(
          request: AddBankType.REQUEST_REGISTER, status: BlocStatus.LOADING));
      ResponseMessageDTO messageDTO =
          await bankCardRepository.requestRegisterBankAccount(event.dto);

      if (messageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: AddBankType.REQUEST_REGISTER,
        ));
      } else {
        emit(
          state.copyWith(
            msg: ErrorUtils.instance.getErrorMessage(messageDTO.message),
            request: AddBankType.REQUEST_REGISTER,
            status: BlocStatus.ERROR,
          ),
        );
      }
    }
  }
}
