import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/add_bank/events/add_bank_event.dart';
import 'package:vierqr/features/add_bank/states/add_bank_state.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_type/repositories/bank_type_repository.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class AddBankBloc extends Bloc<AddBankEvent, AddBankState> with BaseManager {
  @override
  final BuildContext context;

  AddBankBloc(this.context) : super(AddBankState(listBanks: [])) {
    on<LoadDataBankEvent>(_getBankTypes);
    on<ChooseBankEvent>(_chooseBank);
    on<ChangeAccountBankEvent>(_changeAccountBank);
    on<ChangeNameEvent>(_changeNameBank);
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
          emit(state.copyWith(listBanks: list, status: BlocStatus.SUCCESS));
        }
      } catch (e) {
        LOG.error(e.toString());
        emit(state.copyWith(status: BlocStatus.ERROR));
      }
    } else {
      emit(state.copyWith(listBanks: banks, status: BlocStatus.SUCCESS));
    }
  }

  void _chooseBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is ChooseBankEvent) {
        emit(
          state.copyWith(
              bankSelected: state.listBanks![event.index],
              status: BlocStatus.SUCCESS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _changeAccountBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is ChangeAccountBankEvent) {
        emit(
          state.copyWith(status: BlocStatus.SUCCESS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _changeNameBank(AddBankEvent event, Emitter emit) async {
    try {
      if (event is ChangeNameEvent) {
        emit(
          state.copyWith(status: BlocStatus.SUCCESS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}
