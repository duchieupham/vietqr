import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/features/verify_email/repositories/verify_email_repositories.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/bank_overview_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/nearest_transaction_dto.dart';
import 'package:vierqr/models/platform_dto.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';
import 'package:vierqr/services/providers/invoice_overview_dto.dart';

import '../../../services/providers/invoice_provider.dart';

class BankBloc extends Bloc<BankEvent, BankState> with BaseManager {
  @override
  final BuildContext context;

  BankBloc(this.context)
      : super(const BankState(
            listBanner: [0, 1],
            listTrans: [],
            listBanks: [],
            // colors: [],
            listBankTypeDTO: [],
            listBankAccountTerminal: [])) {
    on<BankCardEventGetList>(_getBankAccounts);
    on<UpdateEvent>(_updateEvent);
    on<LoadDataBankEvent>(_getListBankTypes);
    on<UpdateListBank>(_updateListBank);
    on<GetListBankAccountTerminal>(_getBankAccountTerminal);
    on<GetVerifyEmail>(_verifyEmail);
    on<SelectBankAccount>(_selectBank);
    on<SelectTimeEvent>(_selectTime);
    on<GetOverviewBankEvent>(_getOverview);
    on<GetKeyFreeEvent>(_getKeyFree);
    on<GetInvoiceOverview>(_getInvoiceOverview);
    on<GetTransEvent>(_getTrans);
    on<ArrangeBankListEvent>(_arrange);
    on<CloseInvoiceOverviewEvent>(_isCloseInvoiceOverview);
    on<CloseBannerEvent>(_isCloseBanner);
    on<GetAllPlatformsEvent>(_getAllPlatforms);
  }

  FilterTrans selected = FilterTrans(
      title: 'Ngày',
      type: 1,
      fromDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
      toDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59');

  final bankCardRepository = BankCardRepository();

  void _isCloseBanner(BankEvent event, Emitter emit) async {
    if (event is CloseBannerEvent) {
      emit(state.copyWith(listBanner: event.listBanner));
    }
  }

  void _isCloseInvoiceOverview(BankEvent event, Emitter emit) async {
    if (event is CloseInvoiceOverviewEvent) {
      emit(state.copyWith(isClose: event.isClose));
    }
  }

  void _selectTime(BankEvent event, Emitter emit) async {
    if (event is SelectTimeEvent) {
      selected = event.timeSelect;
    }
  }

  void _arrange(BankEvent event, Emitter emit) async {
    try {
      if (event is ArrangeBankListEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.ARRANGE));
        final result = await bankCardRepository.arrangeBankList(event.list);
        if (result) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS, request: BankType.ARRANGE));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR, request: BankType.ARRANGE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: BankType.ARRANGE));
    }
  }

  void _getTrans(BankEvent event, Emitter emit) async {
    try {
      if (event is GetTransEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.GET_TRANS));
        final result = await bankCardRepository.getListTrans(event.bankId);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: BankType.GET_TRANS,
            listTrans: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.GET_TRANS));
    }
  }

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

  void _getInvoiceOverview(BankEvent event, Emitter emit) async {
    try {
      if (event is GetInvoiceOverview) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: BankType.GET_INVOICE_OVERVIEW));
        final result = await bankCardRepository.getInvoiceOverview();
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            invoiceOverviewDTO: result,
            request: BankType.GET_INVOICE_OVERVIEW));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.GET_INVOICE_OVERVIEW));
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
        emit(state.copyWith(
            listBankTypeDTO: list, request: BankType.GET_BANK_LOCAL));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.GET_BANK_LOCAL));
    }
  }

  Future<BankOverviewDTO?> getCurrentDateTime(
      {required String bankId, String? fromDate, String? toDate}) async {
    return await bankCardRepository.getOverview(
      bankId: bankId,
      fromDate: fromDate ??
          '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
      toDate: toDate ??
          '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59',
    );
  }

  Future<BankOverviewDTO?> getPassedDateTime(
      {required String bankId, required int type}) async {
    String fromDate = '';
    String toDate = '';
    DateTime now = DateTime.now();
    DateTime thisMonth = DateTime(now.year, now.month, 1);

    DateTime calculatedDate = now.subtract(const Duration(days: 30));

    switch (type) {
      case 1:
        if (calculatedDate.isBefore(thisMonth)) {
          calculatedDate = thisMonth;
        }
        fromDate =
            '${DateFormat('yyyy-MM-dd').format(calculatedDate)} 00:00:00';
        toDate = '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59';
        break;
      case 2:
        if (calculatedDate.isBefore(thisMonth)) {
          calculatedDate = thisMonth;
        }
        fromDate =
            '${DateFormat('yyyy-MM-dd').format(calculatedDate)} 00:00:00';
        toDate = '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59';
        break;
      case 3:
        // calculatedDate = now.subtract(const Duration(days: 90));
        if (now.month >= 1 && now.month <= 3) {
          // Quý 1: Từ 01-01 đến 31-03
          fromDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 1, 1))} 00:00:00';
          toDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 3, 31))} 23:59:59';
        } else if (now.month >= 4 && now.month <= 6) {
          // Quý 2: Từ 01-04 đến 30-06
          fromDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 4, 1))} 00:00:00';
          toDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 6, 30))} 23:59:59';
        } else if (now.month >= 7 && now.month <= 9) {
          // Quý 3: Từ 01-07 đến 30-09
          fromDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 7, 1))} 00:00:00';
          toDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 9, 30))} 23:59:59';
        } else {
          // Quý 4: Từ 01-10 đến 31-12
          fromDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 10, 1))} 00:00:00';
          toDate =
              '${DateFormat('yyyy-MM-dd').format(DateTime(now.year, 12, 30))} 23:59:59';
        }

        break;
      default:
        break;
    }

    return await bankCardRepository.getOverview(
      bankId: bankId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<List<NearestTransDTO>> getListNearestTrans(String bankId) async {
    List<NearestTransDTO> list = [];

    list = await bankCardRepository.getListTrans(bankId);
    return list;
  }

  Future<List<PlatformItem>> getListPlatform(String bankId) async {
    List<PlatformItem> list = [];
    list = await bankCardRepository.getPlatformByBankId(
        page: 1, size: 4, bankId: bankId);

    return list;
  }

  void _getOverview(BankEvent event, Emitter emit) async {
    try {
      if (event is GetOverviewBankEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.GET_OVERVIEW));
        final futures = [
          getPassedDateTime(bankId: event.bankId, type: event.type),
          getCurrentDateTime(
              bankId: event.bankId,
              fromDate: event.fromDate,
              toDate: event.toDate),
        ];
        final result = await Future.wait(futures);
        BankOverviewDTO? resultPassed = result[0];
        BankOverviewDTO? resultCurrent = result[1];
        if (resultCurrent != null && resultPassed != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: BankType.GET_OVERVIEW,
              overviewDayDto: resultCurrent,
              overviewMonthDto: resultPassed));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.GET_OVERVIEW));
    }
  }

  void _selectBank(BankEvent event, Emitter emit) async {
    try {
      if (event is SelectBankAccount) {
        emit(state.copyWith(bankSelect: event.bank));
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.SELECT_BANK));

        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: BankType.SELECT_BANK,
          bankSelect: event.bank,
        ));

        //state overview
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.GET_OVERVIEW));

        final futures = [
          getPassedDateTime(bankId: event.bank.id, type: 1),
          getCurrentDateTime(
              bankId: event.bank.id,
              fromDate:
                  '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00',
              toDate:
                  '${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59'),
          getNearestTrans(bankId: event.bank.id),
          getListPlatform(event.bank.id),
        ];
        final resultFuture = await Future.wait(futures);
        BankOverviewDTO? resultPassed = resultFuture[0] as BankOverviewDTO;
        BankOverviewDTO? resultCurrent = resultFuture[1] as BankOverviewDTO;

        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: BankType.GET_OVERVIEW,
          overviewDayDto: resultCurrent,
          overviewMonthDto: resultPassed,
          listTrans: resultFuture[2] as List<NearestTransDTO>,
          listPlaforms: resultFuture[3] as List<PlatformItem>,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.SELECT_BANK));
    }
  }

  void _getKeyFree(BankEvent event, Emitter emit) async {
    const EmailRepository emailRepository = EmailRepository();
    try {
      if (event is GetKeyFreeEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: BankType.GET_KEY_FREE));
        final result = await emailRepository.getKeyFree(event.param);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: BankType.GET_KEY_FREE,
            keyDTO: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: BankType.GET_KEY_FREE));
    }
  }

  Future<BankOverviewDTO?> getBankOverView(
      {required String bankId,
      required String fromDate,
      required String toDate}) async {
    return await bankCardRepository.getOverview(
        bankId: bankId, fromDate: fromDate, toDate: toDate);
  }

  Future<List<NearestTransDTO>> getNearestTrans({
    required String bankId,
  }) async {
    return await bankCardRepository.getListTrans(bankId);
  }

  Future<InvoiceOverviewDTO?> getInvoiceOverIvew() async {
    return await bankCardRepository.getInvoiceOverview();
  }

  void _getBankAccounts(BankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventGetList) {
        bool isEmpty = false;
        // BankOverviewDTO? overviewDTO;
        InvoiceOverviewDTO? invoiceOverviewDTO;
        List<NearestTransDTO> listTrans = [];
        List<PlatformItem> listPlatforms = [
          PlatformItem(
              platformId: '',
              platformName: '',
              connectionDetail: '',
              platform: '')
        ];
        emit(state.copyWith(
          status: BlocStatus.LOADING_PAGE,
          request: BankType.BANK,
        ));
        List<BankAccountDTO> list =
            await bankCardRepository.getListBankAccount(userId);

        if (list.isNotEmpty && event.isGetOverview) {
          final futures = !state.isClose
              ? [
                  getNearestTrans(bankId: list.first.id),
                  getInvoiceOverIvew(),
                ]
              : [
                  getNearestTrans(bankId: list.first.id),
                ];
          final results = await Future.wait(futures);
          // overviewDTO = results[0] as BankOverviewDTO;
          listTrans = results[0] as List<NearestTransDTO>;
          if (event.isLoadInvoice) {
            invoiceOverviewDTO = results[1] as InvoiceOverviewDTO;
          }
          if (!state.isClose) {
            invoiceOverviewDTO = results[1] as InvoiceOverviewDTO;
          }

          final resultListPlatform = await bankCardRepository
              .getPlatformByBankId(page: 1, size: 4, bankId: list.first.id);

          if (resultListPlatform is PlatformDTO) {
            listPlatforms = listPlatforms..addAll(resultListPlatform.items);
          }
        }
        if (list.isEmpty) {
          isEmpty = true;
          invoiceOverviewDTO = InvoiceOverviewDTO(
              countInvoice: 0, amountUnpaid: 0, invoices: []);
        }

        emit(state.copyWith(
            request: BankType.BANK,
            listBanks: list,
            // overviewDto: isEmpty ? null : overviewDTO,
            invoiceOverviewDTO: invoiceOverviewDTO,
            listTrans: listTrans,
            // bankSelect: isEmpty ? null : list.first,
            // colors: colors,
            status: BlocStatus.UNLOADING,
            listPlaforms: listPlatforms,
            isEmpty: isEmpty));
        if (!isEmpty) {
          getIt.get<BankBloc>().add(SelectBankAccount(bank: list.first));
        }

        // final List<Color> colors = [];
        // PaletteGenerator? paletteGenerator;
        // BuildContext context = NavigationService.context!;
        Provider.of<InvoiceProvider>(context, listen: false)
            .setListUnAuth(list);
        Provider.of<ConnectMediaProvider>(context, listen: false)
            .setListBank(list
                .where(
                  (element) => element.isOwner && element.isAuthenticated,
                )
                .toList());
        if (list.isNotEmpty) {
          List<BankAccountDTO> listLinked =
              list.where((e) => e.isAuthenticated).toList();
          List<BankAccountDTO> listNotLinked =
              list.where((e) => !e.isAuthenticated).toList();

          list = [...listLinked, ...listNotLinked];

          Provider.of<InvoiceProvider>(context, listen: false)
              .setListBank(listLinked);
          // for (BankAccountDTO dto in list) {
          //   int index = list.indexOf(dto);
          //   dto.position = index * 100;
          //   NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
          //   paletteGenerator = await PaletteGenerator.fromImageProvider(image);
          //   if (paletteGenerator.dominantColor != null) {
          //     dto.setColor(paletteGenerator.dominantColor!.color);
          //   } else {
          //     if (!mounted) return;
          //     dto.setColor(Theme.of(context).cardColor);
          //   }
          // }
        } else {
          Provider.of<InvoiceProvider>(context, listen: false).setListBank([]);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _verifyEmail(BankEvent event, Emitter emit) async {
    if (event is GetVerifyEmail) {
      emit(state.copyWith(request: BankType.VERIFY));
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

  void _getAllPlatforms(BankEvent event, Emitter emit) async {
    try {
      if (event is GetAllPlatformsEvent) {
        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: BankType.BANK,
        ));
        final result = await bankCardRepository.getPlatformByBankId(
            page: event.page, size: event.size, bankId: event.bankId);
        if (result is PlatformDTO) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: BankType.BANK,
            listPlaforms: result.items,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: BankType.BANK));
    }
  }
}
