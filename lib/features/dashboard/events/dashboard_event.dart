import 'package:equatable/equatable.dart';

class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitEvent extends DashboardEvent {
  final bool isLoading;

  DashboardInitEvent({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class DashboardLoadingEvent extends DashboardEvent {}

class DashboardSuccessEvent extends DashboardEvent {}

class DashboardFailedEvent extends DashboardEvent {
  final String? msg;

  DashboardFailedEvent({this.msg});

  @override
  List<Object?> get props => [msg];
}

class DashboardRemoveBusinessEvent extends DashboardEvent {
  final String businessId;

  DashboardRemoveBusinessEvent({this.businessId = ''});

  @override
  List<Object?> get props => [businessId];
}
