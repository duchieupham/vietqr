import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/repositories/scan_qr_repository.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/features/top_up/events/scan_qr_event.dart';
import 'package:vierqr/features/top_up/repositories/top_up_repository.dart';
import 'package:vierqr/features/top_up/states/top_up_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc() : super(TopUpInitialState()) {
    on<TopUpEventCreateQR>(_createQr);
  }
}

const TopUpRepository topUpRepository = TopUpRepository();

void _createQr(TopUpEvent event, Emitter emit) async {
  try {
    if (event is TopUpEventCreateQR) {
      emit(TopUpLoadingState());

      ResponseTopUpDTO dto = await topUpRepository.createQrTopUp(event.data);
      if (dto.qrCode.isNotEmpty) {
        emit(TopUpCreateQrSuccessState(dto: dto));
      } else {
        emit(TopUpCreateQrFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(TopUpCreateQrFailedState());
  }
}
