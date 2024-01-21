import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/repositories/scan_qr_repository.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  ScanQrBloc(this.isScanAll) : super(ScanQrState(isScanAll: isScanAll)) {
    on<ScanQrEventGetBankType>(_getBankType);
    on<ScanQrEventSearchName>(_searchBankName);
    on<ScanQrEventGetNickName>(_getNickNameWalletId);
    on<ScanQrEventGetDetailVCard>(_getNickNameWalletId);
  }

  final bool isScanAll;

  final _repository = const ScanQrRepository();

  void _getNickNameWalletId(ScanQrEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetNickName) {
        emit(
            state.copyWith(status: BlocStatus.LOADING, request: ScanType.NONE));
        final VietQRDTO dto = await _repository.getNickname(event.code);

        final random = Random();

        int data = random.nextInt(5);

        dto.setColorType(data);
        dto.setCode(event.code);

        emit(
          state.copyWith(
            status: BlocStatus.UNLOADING,
            request: ScanType.NICK_NAME,
            vietQRDTO: dto,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _getBankType(ScanQrEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        state.copyWith(request: ScanType.NONE, status: BlocStatus.NONE);
        TypeQR typeQR = await QRScannerUtils.instance.checkScan(event.code);
        if (!state.isScanAll) {
          switch (typeQR) {
            case TypeQR.QR_BANK:
              VietQRScannedDTO qrScannedDTO =
                  QRScannerUtils.instance.getBankAccountFromQR(event.code);
              if (qrScannedDTO.caiValue.isNotEmpty &&
                  qrScannedDTO.bankAccount.isNotEmpty) {
                BankTypeDTO dto = await _repository
                    .getBankTypeByCaiValue(qrScannedDTO.caiValue);
                if (dto.id.isNotEmpty) {
                  emit(state.copyWith(
                      bankTypeDTO: dto,
                      bankAccount: qrScannedDTO.bankAccount,
                      request: ScanType.SCAN,
                      typeContact: TypeContact.Bank,
                      typeQR: TypeQR.QR_BANK,
                      codeQR: event.code));
                } else {
                  emit(state.copyWith(
                    request: ScanType.SCAN_ERROR,
                  ));
                }
              }
              break;
            default:
              emit(state.copyWith(request: ScanType.SCAN_NOT_FOUND));
          }
        } else {
          switch (typeQR) {
            case TypeQR.QR_BANK:
              VietQRScannedDTO qrScannedDTO =
                  QRScannerUtils.instance.getBankAccountFromQR(event.code);
              if (qrScannedDTO.caiValue.isNotEmpty &&
                  qrScannedDTO.bankAccount.isNotEmpty) {
                BankTypeDTO dto = await _repository
                    .getBankTypeByCaiValue(qrScannedDTO.caiValue);
                if (dto.id.isNotEmpty) {
                  emit(state.copyWith(
                      bankTypeDTO: dto,
                      bankAccount: qrScannedDTO.bankAccount,
                      request: ScanType.SCAN,
                      typeContact: TypeContact.Bank,
                      typeQR: TypeQR.QR_BANK,
                      codeQR: event.code));
                } else {
                  emit(state.copyWith(request: ScanType.SCAN_ERROR));
                }
              }
              break;
            case TypeQR.QR_CMT:
              NationalScannerDTO nationalScannerDTO =
                  _repository.getNationalInformation(event.code);
              if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
                emit(state.copyWith(
                    nationalScannerDTO: nationalScannerDTO,
                    request: ScanType.SCAN,
                    typeQR: TypeQR.QR_CMT,
                    codeQR: event.code,
                    typeContact: TypeContact.Other));
              } else {
                emit(state.copyWith(request: ScanType.SCAN_NOT_FOUND));
              }
              break;
            case TypeQR.QR_ID:
              emit(
                state.copyWith(
                  codeQR: event.code,
                  request: ScanType.SCAN,
                  typeQR: TypeQR.QR_ID,
                  typeContact: TypeContact.VietQR_ID,
                ),
              );
              break;
            case TypeQR.QR_BARCODE:
              if (event.code.isNotEmpty) {
                emit(state.copyWith(
                    codeQR: event.code,
                    typeQR: TypeQR.QR_BARCODE,
                    request: ScanType.SCAN,
                    typeContact: TypeContact.Other));
              }
              break;
            case TypeQR.QR_LINK:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.QR_LINK,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.Other));
              break;
            case TypeQR.QR_VCARD:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.QR_VCARD,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.VCard));
              break;
            case TypeQR.LOGIN_WEB:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.LOGIN_WEB,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.Login_Web));
              break;
            case TypeQR.OTHER:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.OTHER,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.Other));
              break;
            case TypeQR.QR_SALE:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.QR_SALE,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.Sale));
              break;
            case TypeQR.TOKEN_PLUGIN:
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.TOKEN_PLUGIN,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.token_plugin));
              break;
            default:
              emit(state.copyWith(request: ScanType.SCAN_ERROR));
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: ScanType.SCAN_NOT_FOUND));
    }
  }

  void _searchBankName(ScanQrEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventSearchName) {
        emit(
            state.copyWith(status: BlocStatus.LOADING, request: ScanType.NONE));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              informationDTO: dto,
              request: ScanType.SEARCH_NAME));
        } else {
          BankNameInformationDTO dto = const BankNameInformationDTO(
              accountName: 'Tên chủ tài khoản không xác định',
              customerName: 'Tên chủ tài khoản không xác định',
              customerShortName: 'Tên chủ tài khoản không xác định',
              isNaviAddBank: true);
          if (event.dto.accountNumber.isNotEmpty) {
            emit(state.copyWith(
                status: BlocStatus.UNLOADING,
                informationDTO: dto,
                request: ScanType.SEARCH_NAME));
          } else {
            emit(
              state.copyWith(
                request: ScanType.SCAN_NOT_FOUND,
                status: BlocStatus.UNLOADING,
              ),
            );
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: ScanType.SCAN_NOT_FOUND, status: BlocStatus.NONE));
    }
  }
}
