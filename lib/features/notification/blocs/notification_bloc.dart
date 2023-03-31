import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/repositories/notification_repository.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationInitialState()) {
    on<NotificationOnMessageEvent>(_onMessageReceive);
    on<NotificationInitialEvent>(_initial);
    on<NotificationTransactionSuccessEvent>(_onTransactionSuccess);
  }
}

NotificationRepository notificationRepository = NotificationRepository();

void _onMessageReceive(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationOnMessageEvent) {
      emit(NotificationOnMessageState(message: event.message));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationFailedState());
  }
}

void _onTransactionSuccess(NotificationEvent event, Emitter emit) async {
  try {
    if (event is NotificationTransactionSuccessEvent) {
      NotificationTransactionSuccessDTO dto =
          NotificationTransactionSuccessDTO.fromJson(event.data);
      emit(NotificationTransactionSuccessState(dto: dto));
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(NotificationFailedState());
  }
}

void _initial(NotificationEvent event, Emitter emit) async {
  emit(const NotificationInitialState());
}
