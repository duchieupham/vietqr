import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/repositories/qr_repository.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  QRBloc() : super(QRInitialState()) {
    on<QREventGenerate>(_generateQR);
    on<QREventGenerateList>(_generateQRList);
  }
}

const QRRepository qrRepository = QRRepository();

void _generateQRList(QREvent event, Emitter emit) async {
  try {
    if (event is QREventGenerateList) {
      final List<QRGeneratedDTO> list =
          await qrRepository.generateQRList(event.list);
      emit(QRGeneratedListSuccessfulState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(QRGeneratedListFailedState());
  }
}

void _generateQR(QREvent event, Emitter emit) async {
  try {
    if (event is QREventGenerate) {
      emit(QRGenerateLoadingState());
      final QRGeneratedDTO dto = await qrRepository.generateQR(event.dto);
      emit(QRGeneratedSuccessfulState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(QRGeneratedFailedState());
  }
}
