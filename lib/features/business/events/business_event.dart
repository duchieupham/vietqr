import 'package:equatable/equatable.dart';

class BusinessEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BusinessInitEvent extends BusinessEvent {
  final bool isLoading;

  BusinessInitEvent({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class BusinessLoadingEvent extends BusinessEvent {}

class BusinessSuccessEvent extends BusinessEvent {}

class BusinessFailedEvent extends BusinessEvent {
  final String? msg;

  BusinessFailedEvent({this.msg});

  @override
  List<Object?> get props => [msg];
}

class BusinessRemoveBusinessEvent extends BusinessEvent {
  final String businessId;

  BusinessRemoveBusinessEvent({this.businessId = ''});

  @override
  List<Object?> get props => [businessId];
}
