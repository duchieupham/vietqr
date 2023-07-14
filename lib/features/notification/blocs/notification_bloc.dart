import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/notification/events/notification_event.dart';
import 'package:vierqr/features/notification/repositories/notification_repository.dart';
import 'package:vierqr/features/notification/states/notification_state.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>
    with BaseManager {
  @override
  final BuildContext context;

  NotificationBloc(this.context) : super(NotificationInitialState()) {
    on<NotificationGetCounterEvent>(_getCounter);
    on<NotificationGetListEvent>(_getNotifications);
    on<NotificationFetchEvent>(_fetchNotifications);
    on<NotificationUpdateStatusEvent>(_updateNotificationStatus);
  }

  void _getCounter(NotificationEvent event, Emitter emit) async {
    try {
      if (event is NotificationGetCounterEvent) {
        emit(NotificationCountingState());
        int counter = await notificationRepository.getCounter(userId);
        emit(NotificationCountSuccessState(count: counter));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(NotificationCountFailedState());
    }
  }

  void _getNotifications(NotificationEvent event, Emitter emit) async {
    try {
      if (event is NotificationGetListEvent) {
        List<NotificationDTO> list =
            await notificationRepository.getNotificationsByUserId(event.dto);
        emit(NotificationGetListSuccessState(list: list));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(NotificationGetListFailedState());
    }
  }

  void _fetchNotifications(NotificationEvent event, Emitter emit) async {
    try {
      if (event is NotificationFetchEvent) {
        List<NotificationDTO> list =
            await notificationRepository.getNotificationsByUserId(event.dto);
        emit(NotificationFetchSuccessState(list: list));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(NotificationFetchFailedState());
    }
  }

  void _updateNotificationStatus(NotificationEvent event, Emitter emit) async {
    try {
      if (event is NotificationUpdateStatusEvent) {
        bool check =
            await notificationRepository.updateNotificationStatus(userId);
        if (check) {
          emit(NotificationUpdateStatusSuccessState());
        } else {
          emit(NotificationUpdateFailedState());
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(NotificationUpdateFailedState());
    }
  }
}

NotificationRepository notificationRepository = const NotificationRepository();
