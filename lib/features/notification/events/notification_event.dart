import 'package:equatable/equatable.dart';
import 'package:vierqr/features/notification/blocs/notification_bloc.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationEventInsert extends NotificationEvent {
  final String bankId;
  final String transactionId;
  final dynamic timeInserted;
  final String address;
  final String transaction;

  const NotificationEventInsert({
    required this.bankId,
    required this.transactionId,
    required this.timeInserted,
    required this.address,
    required this.transaction,
  });

  @override
  List<Object?> get props => [
        bankId,
        transactionId,
        timeInserted,
        address,
        transaction,
      ];
}

class NotificationEventListen extends NotificationEvent {
  final String userId;
  final NotificationBloc notificationBloc;

  const NotificationEventListen({
    required this.userId,
    required this.notificationBloc,
  });

  @override
  List<Object?> get props => [userId, notificationBloc];
}

class NotificationEventReceived extends NotificationEvent {
  final NotificationDTO notificationDTO;

  const NotificationEventReceived({required this.notificationDTO});

  @override
  List<Object?> get props => [notificationDTO];
}

class NotificationEventUpdateStatus extends NotificationEvent {
  final String notificationId;

  const NotificationEventUpdateStatus({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class NotificationEventUpdateAllStatus extends NotificationEvent {
  final List<String> notificationIds;

  const NotificationEventUpdateAllStatus({required this.notificationIds});

  @override
  List<Object?> get props => [notificationIds];
}

class NotificationEventGetList extends NotificationEvent {
  final String userId;

  const NotificationEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NotificationInitialEvent extends NotificationEvent {
  const NotificationInitialEvent();

  @override
  List<Object?> get props => [];
}
