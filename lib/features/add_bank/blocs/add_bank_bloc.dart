import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_type/repositories/bank_type_repository.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class AddBankBloc extends Bloc<AddBankEvent, AddBankState> with BaseManager {
  @override
  final BuildContext context;

  AddBankBloc(this.context) : super(AddBankState(listBanks: [])) {
    on<LoadDataBankEvent>(_getBankTypes);
    on<BankCardEventSearchName>(_searchBankName);
    on<BankCardCheckExistedEvent>(_checkExistedBank);
    on<BankCardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
    on<UpdateAddBankEvent>(_updateEvent);
  }

  final bankCardRepository = const BankCardRepository();
  final bankTypeRepository = const BankTypeRepository();

  void _getBankTypes(AddBankEvent event, Emitter emit) async {
    if (banks.isEmpty) {
      try {
        if (event is LoadDataBankEvent) {
          emit(state.copyWith(status: BlocStatus.LOADING));
          List<BankTypeDTO> list = await bankTypeRepository.getBankTypes();
          banks = list;
          emit(
            state.copyWith(
                listBanks: list,
                status: BlocStatus.UNLOADING,
                request: BlocRequest.SUCCESS),
          );
        }
      } catch (e) {
        LOG.error(e.toString());
        emit(state.copyWith(request: BlocRequest.ERROR));
      }
    } else {
      emit(
        state.copyWith(listBanks: banks, request: BlocRequest.SUCCESS),
      );
    }
  }

  void _searchBankName(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventSearchName) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              informationDTO: dto,
              request: BlocRequest.SEARCH));
        } else {
          emit(
            state.copyWith(
              msg: 'Tài khoản ngân hàng không tồn tại.',
              request: BlocRequest.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Tài khoản ngân hàng không tồn tại.',
        request: BlocRequest.ERROR,
        status: BlocStatus.UNLOADING,
      ));
    }
  }

  void _checkExistedBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardCheckExistedEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO result = await bankCardRepository
            .checkExistedBank(event.bankAccount, event.bankTypeId);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: BlocRequest.INSERT, status: BlocStatus.UNLOADING));
        } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
          emit(state.copyWith(
              request: BlocRequest.ERROR,
              status: BlocStatus.UNLOADING,
              msg: CheckUtils.instance.getCheckMessage(result.message)));
        } else {
          emit(state.copyWith(
            request: BlocRequest.ERROR,
            status: BlocStatus.UNLOADING,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: BlocRequest.ERROR,
      ));
    }
  }

  void _insertBankCardUnauthenticated(AddBankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventInsertUnauthenticated) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BlocRequest.NONE));
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
              request: BlocRequest.DONE,
              status: BlocStatus.UNLOADING,
            ),
          );
        } else {
          emit(state.copyWith(
            msg: ErrorUtils.instance.getErrorMessage(result.message),
            status: BlocStatus.UNLOADING,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
        msg: ErrorUtils.instance.getErrorMessage(dto.message),
        status: BlocStatus.UNLOADING,
      ));
    }
  }

  void _updateEvent(AddBankEvent event, Emitter emit) {
    emit(state.copyWith(status: BlocStatus.NONE, request: BlocRequest.NONE));
  }
}
