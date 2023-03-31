import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vierqr/models/notification_transaction_success_dto.dart';

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

class NotificationOnMessageState extends NotificationState {
  final RemoteMessage message;

  const NotificationOnMessageState({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationTransactionSuccessState extends NotificationState {
  final NotificationTransactionSuccessDTO dto;

  const NotificationTransactionSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class NotificationFailedState extends NotificationState {}
