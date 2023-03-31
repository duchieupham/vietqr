import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationInitialEvent extends NotificationEvent {}

class NotificationOnMessageEvent extends NotificationEvent {
  final RemoteMessage message;

  const NotificationOnMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationTransactionSuccessEvent extends NotificationEvent {
  final Map<String, dynamic> data;

  const NotificationTransactionSuccessEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
