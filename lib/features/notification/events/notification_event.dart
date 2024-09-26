import 'package:equatable/equatable.dart';
import 'package:vierqr/models/notification_input_dto.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}


class NotificationGetListEvent extends NotificationEvent {
  final NotificationInputDTO dto;

  const NotificationGetListEvent({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class NotificationFetchEvent extends NotificationEvent {
  final NotificationInputDTO dto;

  const NotificationFetchEvent({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class NotificationUpdateStatusEvent extends NotificationEvent {}

class NotificationGetCounterEvent extends NotificationEvent {}
