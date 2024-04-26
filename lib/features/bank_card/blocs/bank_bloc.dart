import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/bank_type_dto.dart';

import '../../../services/providers/invoice_provider.dart';

class BankBloc extends Bloc<BankEvent, BankState> with BaseManager {
  @override
  final BuildContext context;

  BankBloc(this.context)
      : super(const BankState(
            listBanks: [],
            colors: [],
            listBankTypeDTO: [],
            listBankAccountTerminal: [])) {
    on<BankCardEventGetList>(_getBankAccounts);
    on<UpdateEvent>(_updateEvent);
    on<LoadDataBankEvent>(_getListBankTypes);
    on<UpdateListBank>(_updateListBank);
    on<GetListBankAccountTerminal>(_getBankAccountTerminal);
  }

  final bankCardRepository = const BankCardRepository();

  void _updateListBank(BankEvent event, Emitter emit) {
    if (event is UpdateListBank) {
      List<BankAccountDTO> list = [...state.listBanks];
      final index = list.indexWhere((element) => element.id == event.dto.id);
      if (index != -1) {
        if (event.type == UpdateBankType.UPDATE) {
          list[index] = event.dto;
        } else if (event.type == UpdateBankType.DELETE) {
          list.removeAt(index);
        }
      }
      emit(state.copyWith(listBanks: list));
    }
  }

  Future _getListBankTypes(BankEvent event, Emitter emit) async {
    if (banks.isNotEmpty) {
      emit(state.copyWith(
          listBankTypeDTO: banks, request: BankType.GET_BANK_LOCAL));
      return;
    }
    try {
      if (event is LoadDataBankEvent) {
        List<BankTypeDTO> list = await bankCardRepository.getBankTypes();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
        }
        banks = list;
        emit(state.copyWith(listBankTypeDTO: list, request: BankType.GET_BANK));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getBankAccounts(BankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventGetList) {
        bool isEmpty = false;

        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankAccountDTO> list =
            await bankCardRepository.getListBankAccount(userId);

        if (list.isEmpty) {
          isEmpty = true;
        }

        final List<Color> colors = [];
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        if (list.isNotEmpty) {
          List<BankAccountDTO> listLinked =
              list.where((e) => e.isAuthenticated).toList();
          List<BankAccountDTO> listNotLinked =
              list.where((e) => !e.isAuthenticated).toList();

          list = [...listLinked, ...listNotLinked];
          Provider.of<InvoiceProvider>(context, listen: false)
              .setListBank(listLinked);
          for (BankAccountDTO dto in list) {
            int index = list.indexOf(dto);
            dto.position = index * 100;
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              dto.setColor(paletteGenerator.dominantColor!.color);
            } else {
              if (!mounted) return;
              dto.setColor(Theme.of(context).cardColor);
            }
          }
        }

        emit(state.copyWith(
            request: BankType.BANK,
            listBanks: list,
            colors: colors,
            status: BlocStatus.UNLOADING,
            isEmpty: isEmpty));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getBankAccountTerminal(BankEvent event, Emitter emit) async {
    try {
      if (event is GetListBankAccountTerminal) {
        bool isEmpty = false;

        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankAccountTerminal> list = await bankCardRepository
            .getListBankAccountTerminal(userId, event.terminalId);

        if (list.isEmpty) {
          isEmpty = true;
        }

        emit(state.copyWith(
            request: BankType.BANK,
            listBankTerminal: list,
            status: BlocStatus.UNLOADING,
            isEmpty: isEmpty));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _updateEvent(BankEvent event, Emitter emit) {
    emit(state.copyWith(status: BlocStatus.DONE));
  }
}
