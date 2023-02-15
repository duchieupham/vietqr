import 'package:equatable/equatable.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/models/transaction_dto.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState();

  @override
  List<Object?> get props => [];
}

//for insert t-n event
class NotificationSuccesfulInsertState extends NotificationState {
  const NotificationSuccesfulInsertState();

  @override
  List<Object?> get props => [];
}

class NotificationFailedInsertState extends NotificationState {
  const NotificationFailedInsertState();

  @override
  List<Object?> get props => [];
}

//for listen t-n event
class NotificationListenFailedState extends NotificationState {
  const NotificationListenFailedState();

  @override
  List<Object?> get props => [];
}

//for received t-n event
class NotificationReceivedSuccessState extends NotificationState {
  final TransactionDTO transactionDTO;
  final String notificationId;

  const NotificationReceivedSuccessState({
    required this.transactionDTO,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [transactionDTO, notificationId];
}

class NotificationReceivedFailedState extends NotificationState {
  const NotificationReceivedFailedState();

  @override
  List<Object?> get props => [];
}

//for update status t-n event
class NotificationUpdateSuccessState extends NotificationState {
  const NotificationUpdateSuccessState();

  @override
  List<Object?> get props => [];
}

class NotificationUpdateFailedState extends NotificationState {
  const NotificationUpdateFailedState();

  @override
  List<Object?> get props => [];
}

//for update all status t-n event
class NotificationsUpdateSuccessState extends NotificationState {
  const NotificationsUpdateSuccessState();

  @override
  List<Object?> get props => [];
}

class NotificationsUpdateFailedState extends NotificationState {
  const NotificationsUpdateFailedState();

  @override
  List<Object?> get props => [];
}

//for event get list
class NotificationListSuccessfulState extends NotificationState {
  final List<NotificationDTO> list;

  const NotificationListSuccessfulState({required this.list});

  @override
  List<Object?> get props => [list];
}

class NotificationListFailedState extends NotificationState {
  const NotificationListFailedState();

  @override
  List<Object?> get props => [];
}
