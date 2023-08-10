import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/connect_lark/repositories/connect_lark_repository.dart';

import '../../../models/info_tele_dto.dart';
import '../../../models/response_message_dto.dart';
import '../events/connect_lark_event.dart';
import '../states/conect_lark_state.dart';

class ConnectLarkBloc extends Bloc<ConnectLarkEvent, ConnectLarkState> {
  ConnectLarkBloc() : super(ConnectLarkInitialState()) {
    on<InsertLark>(_insertTele);
    on<SendFirstMessage>(_sendFirstMessage);
    on<GetInformationLarkConnect>(_getInfoLarkConnected);
    on<RemoveLarkConnect>(_removeLark);
  }
}

const ConnectLarkRepository repository = ConnectLarkRepository();

void _insertTele(ConnectLarkEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is InsertLark) {
      emit(ConnectLarkLoadingState());

      result = await repository.insertLark(event.data);
      if (result.status == 'SUCCESS') {
        emit(InsertLarkSuccessState(dto: result));
      } else {
        emit(InsertLarkFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(InsertLarkFailedState(dto: result));
  }
}

void _sendFirstMessage(ConnectLarkEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is SendFirstMessage) {
      result = await repository.sendFirstMessage(event.webhook);
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(InsertLarkFailedState(dto: result));
  }
}

void _getInfoLarkConnected(ConnectLarkEvent event, Emitter emit) async {
  List<InfoLarkDTO> result = [];
  try {
    emit(GetInfoLoadingState());
    if (event is GetInformationLarkConnect) {
      result = await repository.getInformation(event.userId);
    }
    emit(GetInfoLarkConnectedSuccessState(list: result));
  } catch (e) {
    LOG.error(e.toString());
    emit(GetInfoLarkConnectedSuccessState(list: result));
  }
}

void _removeLark(ConnectLarkEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveLarkConnect) {
      emit(RemoveLarkConnectLoadingState());

      result = await repository.remove(event.larkConnectId);
      if (result.status == 'SUCCESS') {
        emit(RemoveLarkSuccessState(dto: result));
      } else {
        emit(RemoveLarkFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveLarkFailedState(dto: result));
  }
}
