import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/connect_telegram/events/connect_telegram_event.dart';
import 'package:vierqr/features/connect_telegram/repositories/connect_telegram_repository.dart';
import 'package:vierqr/features/connect_telegram/states/conect_telegram_state.dart';

import '../../../models/info_tele_dto.dart';
import '../../../models/response_message_dto.dart';

class ConnectTelegramBloc
    extends Bloc<ConnectTelegramEvent, ConnectTelegramState> {
  ConnectTelegramBloc() : super(ConnectTelegramInitialState()) {
    on<InsertTelegram>(_insertTele);
    on<SendFirstMessage>(_sendFirstMessage);
    on<GetInformationTeleConnect>(_getInfoTeleConnected);
    on<RemoveTeleConnect>(_removeTele);
    on<RemoveBankTelegramEvent>(_removeBankTele);
    on<AddBankTelegramEvent>(_addBankTele);
  }
}

const ConnectTelegramRepository repository = ConnectTelegramRepository();

void _insertTele(ConnectTelegramEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is InsertTelegram) {
      emit(ConnectTelegramLoadingState());

      result = await repository.insertTele(event.data);
      if (result.status == 'SUCCESS') {
        emit(InsertTeleSuccessState(dto: result));
      } else {
        emit(InsertTeleFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(InsertTeleFailedState(dto: result));
  }
}

void _sendFirstMessage(ConnectTelegramEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is SendFirstMessage) {
      result = await repository.sendFirstMessage(event.chatId);
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(InsertTeleFailedState(dto: result));
  }
}

void _getInfoTeleConnected(ConnectTelegramEvent event, Emitter emit) async {
  List<InfoTeleDTO> result = [];
  try {
    emit(GetInfoLoadingState());
    if (event is GetInformationTeleConnect) {
      result = await repository.getInformation(event.userId);
    }
    emit(GetInfoTeleConnectedSuccessState(list: result));
  } catch (e) {
    LOG.error(e.toString());
    emit(GetInfoTeleConnectedSuccessState(list: result));
  }
}

void _removeTele(ConnectTelegramEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveTeleConnect) {
      emit(RemoveTelegramLoadingState());

      result = await repository.remove(event.teleConnectId);
      if (result.status == 'SUCCESS') {
        emit(RemoveTeleSuccessState(dto: result));
      } else {
        emit(RemoveTeleFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveTeleFailedState(dto: result));
  }
}

void _removeBankTele(ConnectTelegramEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is RemoveBankTelegramEvent) {
      emit(RemoveTelegramLoadingState());

      result = await repository.removeBankTelegram(event.body);
      if (result.status == 'SUCCESS') {
        emit(RemoveBankTeleSuccessState(dto: result));
      } else {
        emit(RemoveTeleFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(RemoveTeleFailedState(dto: result));
  }
}

void _addBankTele(ConnectTelegramEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is AddBankTelegramEvent) {
      emit(RemoveTelegramLoadingState());

      result = await repository.addBankTelegram(event.body);
      if (result.status == 'SUCCESS') {
        emit(AddBankTeleSuccessState(dto: result));
      } else {
        emit(AddBankTeleFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(AddBankTeleFailedState(dto: result));
  }
}
