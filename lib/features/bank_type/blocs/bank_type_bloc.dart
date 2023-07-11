import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/features/bank_type/repositories/bank_type_repository.dart';
import 'package:vierqr/features/bank_type/states/bank_type_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class BankTypeBloc extends Bloc<BankTypeEvent, BankTypeState> with BaseManager {
  @override
  final BuildContext context;

  BankTypeBloc(this.context) : super(const BankTypeState(list: [])) {
    on<BankTypeEventGetList>(_getBankTypes);
    on<BankTypeEventSearch>(_searchBankTypes);
  }

  final bankTypeRepository = const BankTypeRepository();

  void _getBankTypes(BankTypeEvent event, Emitter emit) async {
    if (banks.isEmpty) {
      try {
        if (event is BankTypeEventGetList) {
          emit(state.copyWith(status: BlocStatus.LOADING));
          List<BankTypeDTO> list = await bankTypeRepository.getBankTypes();
          banks = list;
          emit(state.copyWith(list: list, status: BlocStatus.SUCCESS));
        }
      } catch (e) {
        LOG.error(e.toString());
        emit(state.copyWith(status: BlocStatus.ERROR));
      }
    } else {
      emit(state.copyWith(list: banks, status: BlocStatus.SUCCESS));
    }
  }

  void _searchBankTypes(BankTypeEvent event, Emitter emit) {
    try {
      if (event is BankTypeEventSearch) {
        List<BankTypeDTO> result = [];
        if (event.textSearch.trim().isNotEmpty) {
          result.addAll(banks
              .where((dto) =>
                  dto.bankCode
                      .toUpperCase()
                      .contains(event.textSearch.toUpperCase()) ||
                  dto.bankName
                      .toUpperCase()
                      .contains(event.textSearch.toUpperCase()) ||
                  dto.bankShortName!
                      .toUpperCase()
                      .contains(event.textSearch.toUpperCase()))
              .toList());
        } else {
          result = banks;
        }
        emit(state.copyWith(list: result, status: BlocStatus.SUCCESS));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}
