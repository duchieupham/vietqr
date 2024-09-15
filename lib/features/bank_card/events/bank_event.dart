import 'package:equatable/equatable.dart';
import 'package:vierqr/features/bank_detail_new/widgets/filter_time_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_arrange_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';

enum UpdateBankType {
  DELETE,
  UPDATE,
  CALL_API,
}

class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

class CloseBannerEvent extends BankEvent {
  final List<int> listBanner;

  const CloseBannerEvent({required this.listBanner});

  @override
  List<Object?> get props => [listBanner];
}

class CloseInvoiceOverviewEvent extends BankEvent {
  final bool isClose;

  const CloseInvoiceOverviewEvent({required this.isClose});

  @override
  List<Object?> get props => [isClose];
}

class GetOverviewEvent extends BankEvent {
  final String bankId;
  final String? fromDate;
  final String? toDate;

  const GetOverviewEvent({
    required this.bankId,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [
        bankId,
        fromDate,
        toDate,
      ];
}

class GetOverviewBankEvent extends BankEvent {
  final String bankId;
  final int type;
  final String? fromDate;
  final String? toDate;

  const GetOverviewBankEvent({
    required this.bankId,
    required this.type,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [
        bankId,
        type,
        fromDate,
        toDate,
      ];
}

class SelectBankAccount extends BankEvent {
  final BankAccountDTO bank;

  const SelectBankAccount({required this.bank});
  @override
  List<Object?> get props => [bank];
}

class SelectTimeEvent extends BankEvent {
  final FilterTrans timeSelect;

  const SelectTimeEvent({required this.timeSelect});
  @override
  List<Object?> get props => [timeSelect];
}

class BankCardEventGetList extends BankEvent {
  final bool isGetOverview;
  final bool isLoadInvoice;

  const BankCardEventGetList(
      {this.isGetOverview = false, required this.isLoadInvoice});

  @override
  List<Object?> get props => [isGetOverview, isLoadInvoice];
}

class GetKeyFreeEvent extends BankEvent {
  final Map<String, dynamic> param;

  const GetKeyFreeEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class GetVerifyEmail extends BankEvent {}

class GetListBankAccountTerminal extends BankEvent {
  final String userId;
  final String terminalId;

  const GetListBankAccountTerminal(
      {required this.userId, required this.terminalId});

  @override
  List<Object?> get props => [userId, terminalId];
}

class ArrangeBankListEvent extends BankEvent {
  final List<BankArrangeDTO> list;

  const ArrangeBankListEvent({required this.list});

  @override
  List<Object?> get props => [list];
}

class QREventGenerateList extends BankEvent {
  final List<QRCreateDTO> list;

  const QREventGenerateList({required this.list});

  @override
  List<Object?> get props => [list];
}

class UpdateEvent extends BankEvent {}

class UpdateListBank extends BankEvent {
  final BankAccountDTO dto;
  final UpdateBankType type; // 0: edit; 1: delete

  const UpdateListBank(this.dto, this.type);

  @override
  List<Object?> get props => [dto];
}

class LoadDataBankEvent extends BankEvent {}

class GetInvoiceOverview extends BankEvent {}

class GetTransEvent extends BankEvent {
  final String bankId;

  const GetTransEvent({required this.bankId});

  @override
  List<Object?> get props => [bankId];
}

class GetAllPlatformsEvent extends BankEvent {
  final int page;
  final int size;
  final String bankId;

  const GetAllPlatformsEvent(
      {required this.page, required this.size, required this.bankId});

  @override
  List<Object?> get props => [page, size, bankId];
}
