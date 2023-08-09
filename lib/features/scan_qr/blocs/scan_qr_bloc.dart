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
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  ScanQrBloc(this.isScanAll) : super(ScanQrState(isScanAll: isScanAll)) {
    on<ScanQrEventGetBankType>(_getBankType);
    on<ScanQrEventSearchName>(_searchBankName);
  }

  final bool isScanAll;

  final _repository = const ScanQrRepository();

  void _getBankType(ScanQrEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        state.copyWith(request: ScanType.NONE, status: BlocStatus.NONE);
        TypeQR typeQR = await QRScannerUtils.instance.checkScan(event.code);
        if (!state.isScanAll) {
          if (typeQR == TypeQR.QR_BANK) {
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
          } else {
            emit(state.copyWith(
              request: ScanType.SCAN_NOT_FOUND,
            ));
          }
        } else {
          if (typeQR == TypeQR.QR_BANK) {
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
          } else if (typeQR == TypeQR.QR_CMT) {
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
          } else if (typeQR == TypeQR.QR_ID) {
            emit(state.copyWith(
                codeQR: event.code,
                request: ScanType.SCAN,
                typeQR: TypeQR.QR_ID,
                typeContact: TypeContact.VietQR_ID));
          } else if (typeQR == TypeQR.QR_BARCODE) {
            if (event.code.isNotEmpty) {
              emit(state.copyWith(
                  codeQR: event.code,
                  typeQR: TypeQR.QR_BARCODE,
                  request: ScanType.SCAN,
                  typeContact: TypeContact.Other));
            }
          } else if (typeQR == TypeQR.QR_LINK) {
            emit(state.copyWith(
                codeQR: event.code,
                typeQR: TypeQR.QR_LINK,
                request: ScanType.SCAN,
                typeContact: TypeContact.Other));
          } else {
            emit(state.copyWith(
                codeQR: event.code,
                typeQR: TypeQR.OTHER,
                request: ScanType.SCAN,
                typeContact: TypeContact.Other));
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

// void _getBankType(ScanQrEvent event, Emitter emit) async {
//   try {
//     if (event is ScanQrEventGetBankType) {
//       emit(ScanQrLoadingState());
//       VietQRScannedDTO vietQRScannedDTO =
//           QRScannerUtils.instance.getBankAccountFromQR(event.code);
//       if (vietQRScannedDTO.caiValue.isNotEmpty &&
//           vietQRScannedDTO.bankAccount.isNotEmpty) {
//         BankTypeDTO dto = await scanQrRepository
//             .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
//         if (dto.id.isNotEmpty) {
//           emit(
//             ScanQrGetBankTypeSuccessState(
//               dto: dto,
//               bankAccount: vietQRScannedDTO.bankAccount,
//             ),
//           );
//         } else {
//           emit(ScanQrGetBankTypeFailedState());
//         }
//       } else {
//         NationalScannerDTO nationalScannerDTO =
//             scanQrRepository.getNationalInformation(event.code);
//         if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
//           emit(QRScanGetNationalInformationSuccessState(
//               dto: nationalScannerDTO));
//         } else {
//           emit(ScanQrNotFoundInformation());
//         }
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(ScanQrGetBankTypeFailedState());
//   }
// }
