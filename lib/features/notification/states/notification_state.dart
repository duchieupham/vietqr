import 'package:equatable/equatable.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationLoadingEvent extends NotificationState {}

class NotificationInitialState extends NotificationState {}

class NotificationCountingState extends NotificationState {}

class NotificationCountSuccessState extends NotificationState {
  final int count;

  const NotificationCountSuccessState({
    required this.count,
  });

  @override
  List<Object?> get props => [count];
}

class NotificationCountFailedState extends NotificationState {}

class NotificationGetListSuccessState extends NotificationState {
  final List<NotificationDTO> list;

  const NotificationGetListSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class NotificationFetchSuccessState extends NotificationState {
  final List<NotificationDTO> list;

  const NotificationFetchSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class NotificationFetchFailedState extends NotificationState {}

class NotificationGetListFailedState extends NotificationState {}

class NotificationUpdateStatusSuccessState extends NotificationState {}

class NotificationUpdateFailedState extends NotificationState {}
