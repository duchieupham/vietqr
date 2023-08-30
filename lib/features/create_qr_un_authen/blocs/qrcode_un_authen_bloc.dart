import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/create_qr_un_authen/events/qrcode_un_authen_event.dart';
import 'package:vierqr/features/create_qr_un_authen/repositories/qrcode_un_authen_respository.dart';
import 'package:vierqr/features/create_qr_un_authen/states/qrcode_un_authen_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

import '../../bank_type/repositories/bank_type_repository.dart';

class QRCodeUnUTBloc extends Bloc<QRCodeUnUTEvent, QRCodeUnUTState> {
  QRCodeUnUTBloc() : super(CreateInitialState()) {
    on<QRCodeUnUTCreateQR>(_createQR);
    on<LoadDataBankTypeEvent>(_getBankTypes);
  }
}

final bankTypeRepository = const BankTypeRepository();
const QRCodeUnUTRepository _repository = QRCodeUnUTRepository();

void _createQR(QRCodeUnUTEvent event, Emitter emit) async {
  try {
    if (event is QRCodeUnUTCreateQR) {
      emit(CreateQRLoadingState());
      final QRGeneratedDTO result = await _repository.generateQR(event.data);
      emit(CreateSuccessfulState(dto: result));
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(CreateFailedState());
  }
}

void _getBankTypes(QRCodeUnUTEvent event, Emitter emit) async {
  try {
    if (event is LoadDataBankTypeEvent) {
      emit(GetBankTYpeLoadingState());
      List<BankTypeDTO> list = await bankTypeRepository.getBankTypesAuthen();

      emit(GetBankTYpeSuccessState(list: list));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(GetBankTYpeErrorState());
  }
}
