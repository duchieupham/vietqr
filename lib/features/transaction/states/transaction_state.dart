// import 'package:equatable/equatable.dart';
// import 'package:vierqr/models/business_detail_dto.dart';
// import 'package:vierqr/models/related_transaction_receive_dto.dart';
// import 'package:vierqr/models/transaction_receive_dto.dart';
//
// class TransactionState extends Equatable {
//   const TransactionState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class TransactionInitialState extends TransactionState {}
//
// class TransactionLoadingState extends TransactionState {}
//
// class TransactionGetListBranchSuccessState extends TransactionState {
//   final List<BusinessTransactionDTO> list;
//
//   const TransactionGetListBranchSuccessState({
//     required this.list,
//   });
//
//   @override
//   List<Object?> get props => [list];
// }
//
// class TransactionGetListBranchFailedState extends TransactionState {}
//
// class TransactionLoadingFetchState extends TransactionState {}
//
// class TransactionFetchBranchSuccessState extends TransactionState {
//   final List<BusinessTransactionDTO> list;
//
//   const TransactionFetchBranchSuccessState({
//     required this.list,
//   });
//
//   @override
//   List<Object?> get props => [list];
// }
//
// class TransactionGetListSuccessState extends TransactionState {
//   final List<RelatedTransactionReceiveDTO> list;
//
//   const TransactionGetListSuccessState({
//     required this.list,
//   });
//
//   @override
//   List<Object?> get props => [list];
// }
//
// class TransactionGetListFailedState extends TransactionState {}
//
// class TransactionFetchSuccessState extends TransactionState {
//   final List<RelatedTransactionReceiveDTO> list;
//
//   const TransactionFetchSuccessState({
//     required this.list,
//   });
//
//   @override
//   List<Object?> get props => [list];
// }
//
// class TransactionFetchFailedState extends TransactionState {}
//
// class TransactionDetailLoadingState extends TransactionState {}
//
// class TransactionDetailSuccessState extends TransactionState {
//   final TransactionReceiveDTO dto;
//
//   const TransactionDetailSuccessState({
//     required this.dto,
//   });
//
//   @override
//   List<Object?> get props => [dto];
// }
//
// class TransactionDetailFailedState extends TransactionState {}
import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

enum TransactionType {
  NONE,
  LOAD_DATA,
}

class TransactionState extends Equatable {
  final BlocStatus status;
  final TransactionType type;
  final String? msg;
  final TransactionReceiveDTO? dto;

  final List<BusinessTransactionDTO> list;

  // final List<BusinessTransactionDTO> list;
  // final List<RelatedTransactionReceiveDTO> list;

  const TransactionState({
    this.status = BlocStatus.NONE,
    this.type = TransactionType.NONE,
    this.msg,
    this.dto,
    required this.list,
  });

  TransactionState copyWith({
    BlocStatus? status,
    TransactionType? type,
    String? msg,
    TransactionReceiveDTO? transactionReceiveDTO,
    List<BusinessTransactionDTO>? list,
  }) {
    return TransactionState(
      status: status ?? this.status,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      dto: transactionReceiveDTO ?? this.dto,
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [status, type];
}
