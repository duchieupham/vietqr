import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_type/events/bank_type_event.dart';
import 'package:vierqr/features/bank_type/repositories/bank_type_repository.dart';
import 'package:vierqr/features/bank_type/states/bank_type_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class BankTypeBloc extends Bloc<BankTypeEvent, BankTypeState> {
  BankTypeBloc() : super(BankTypeInitialState()) {
    on<BankTypeEventGetList>(_getBankTypes);
    on<BankTypeEventSearch>(_searchBankTypes);
  }
}

const BankTypeRepository bankTypeRepository = BankTypeRepository();

void _getBankTypes(BankTypeEvent event, Emitter emit) async {
  try {
    if (event is BankTypeEventGetList) {
      emit(BankTypeLoadingState());
      List<BankTypeDTO> list = await bankTypeRepository.getBankTypes();
      emit(BankTypeGetListSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankTypeGetListFailedState());
  }
}

void _searchBankTypes(BankTypeEvent event, Emitter emit) {
  try {
    if (event is BankTypeEventSearch) {
      // emit(BankTypeLoadingState());
      List<BankTypeDTO> result = [];
      if (event.textSearch.trim().isNotEmpty) {
        result.addAll(event.list
            .where((dto) =>
                dto.bankCode
                    .toUpperCase()
                    .contains(event.textSearch.toUpperCase()) ||
                dto.bankName
                    .toUpperCase()
                    .contains(event.textSearch.toUpperCase()))
            .toList());
      } else {
        result = event.list;
      }
      emit(BankTypeSearchState(list: result));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(BankTypeGetListFailedState());
  }
}
