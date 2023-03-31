import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/repositories/scan_qr_repository.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  ScanQrBloc() : super(ScanQrInitialState()) {
    on<ScanQrEventGetBankType>(_getBankType);
  }
}

const ScanQrRepository scanQrRepository = ScanQrRepository();

void _getBankType(ScanQrEvent event, Emitter emit) async {
  try {
    if (event is ScanQrEventGetBankType) {
      emit(ScanQrLoadingState());
      VietQRScannedDTO vietQRScannedDTO =
          QRScannerUtils.instance.getBankAccountFromQR(event.code);
      if (vietQRScannedDTO.caiValue.isNotEmpty &&
          vietQRScannedDTO.bankAccount.isNotEmpty) {
        BankTypeDTO dto = await scanQrRepository
            .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
        if (dto.id.isNotEmpty) {
          emit(
            ScanQrGetBankTypeSuccessState(
              dto: dto,
              bankAccount: vietQRScannedDTO.bankAccount,
            ),
          );
        } else {
          emit(ScanQrGetBankTypeFailedState());
        }
      } else {
        emit(ScanQrNotFoundInformation());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(ScanQrGetBankTypeFailedState());
  }
}
