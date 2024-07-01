import 'package:equatable/equatable.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/theme_dto.dart';

class DashBoardEvent extends Equatable {
  const DashBoardEvent();

  @override
  List<Object?> get props => [];
}

class DashBoardLoginEvent extends DashBoardEvent {
  final AccountLoginDTO dto;

  const DashBoardLoginEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CloseMobileNotificationEvent extends DashBoardEvent {}

class DashBoardEventSearchName extends DashBoardEvent {
  final BankNameSearchDTO dto;

  const DashBoardEventSearchName({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class DashBoardEventInsertUnauthenticated extends DashBoardEvent {
  final BankCardInsertUnauthenticatedDTO dto;

  const DashBoardEventInsertUnauthenticated({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateEventDashboard extends DashBoardEvent {}

class GetPointEvent extends DashBoardEvent {}

class GetVersionAppEventDashboard extends DashBoardEvent {
  final bool isCheckVer;
  final bool isExist;

  GetVersionAppEventDashboard({
    this.isCheckVer = false,
    this.isExist = false,
  });

  @override
  List<Object?> get props => [isCheckVer, isExist];
}

class TokenEventCheckValid extends DashBoardEvent {
  const TokenEventCheckValid();

  @override
  List<Object?> get props => [];
}

class TokenFcmUpdateEvent extends DashBoardEvent {
  const TokenFcmUpdateEvent();

  @override
  List<Object?> get props => [];
}

class TokenEventLogout extends DashBoardEvent {}

class GetUserInformation extends DashBoardEvent {}

class GetUserSettingEvent extends DashBoardEvent {}

class GetBanksEvent extends DashBoardEvent {}

class GetCountNotifyEvent extends DashBoardEvent {}

class NotifyUpdateStatusEvent extends DashBoardEvent {}

class CheckConnectivity extends DashBoardEvent {}
