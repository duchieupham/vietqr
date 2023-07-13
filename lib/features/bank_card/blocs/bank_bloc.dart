import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/home/blocs/home_bloc.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class BankBloc extends Bloc<BankEvent, BankState> with BaseManager {
  @override
  final BuildContext context;

  BankBloc(this.context)
      : super(const BankState(listBanks: [], colors: [], listGeneratedQR: [])) {
    on<BankCardEventGetList>(_getBankAccounts);
    on<UpdateEvent>(_updateEvent);
    on<QREventGenerateList>(_generateQRList);
    on<ScanQrEventGetBankType>(_getBankTypeQR);
  }

  final bankCardRepository = const BankCardRepository();

  void _generateQRList(BankEvent event, Emitter emit) async {
    try {
      if (event is QREventGenerateList) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final List<QRGeneratedDTO> list =
            await bankCardRepository.generateQRList(event.list);
        emit(state.copyWith(listGeneratedQR: list, request: BankType.QR));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getBankTypeQR(BankEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        VietQRScannedDTO vietQRScannedDTO =
            QRScannerUtils.instance.getBankAccountFromQR(event.code);

        if (vietQRScannedDTO.caiValue.isNotEmpty &&
            vietQRScannedDTO.bankAccount.isNotEmpty) {
          BankTypeDTO dto = await homeRepository
              .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
          if (dto.id.isNotEmpty) {
            emit(
              state.copyWith(
                request: BankType.SCAN,
                bankTypeDTO: dto,
                bankAccount: vietQRScannedDTO.bankAccount,
              ),
            );
          } else {
            emit(state.copyWith(request: BankType.NONE));
          }
        } else {
          NationalScannerDTO nationalScannerDTO =
              homeRepository.getNationalInformation(event.code);
          if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
            emit(state.copyWith(nationalScannerDTO: nationalScannerDTO));
          } else {
            emit(state.copyWith(request: BankType.NONE));
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getBankAccounts(BankEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventGetList) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankAccountDTO> list =
            await bankCardRepository.getListBankAccount(userId);
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
        emit(state.copyWith(
            status: BlocStatus.SUCCESS, listBanks: list, colors: colors));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _updateEvent(BankEvent event, Emitter emit) {
    emit(state.copyWith(type: TypePermission.None, status: BlocStatus.DONE));
  }
}
