import 'package:equatable/equatable.dart';
import 'package:vierqr/models/bank_card_insert_unauthenticated.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/theme_dto.dart';

class DashBoardEvent extends Equatable {
  const DashBoardEvent();

  @override
  List<Object?> get props => [];
}

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

class GetListThemeEvent extends DashBoardEvent {}

class UpdateThemeEvent extends DashBoardEvent {
  final int type;
  final List<ThemeDTO> themes;

  const UpdateThemeEvent(this.type, this.themes);

  @override
  List<Object?> get props => [type, themes];
}

class UpdateKeepBrightEvent extends DashBoardEvent {
  final bool keepValue;

  UpdateKeepBrightEvent(this.keepValue);

  @override
  List<Object?> get props => [keepValue];
}

class GetCountNotifyEvent extends DashBoardEvent {}

class NotifyUpdateStatusEvent extends DashBoardEvent {}

class CheckConnectivity extends DashBoardEvent {}
