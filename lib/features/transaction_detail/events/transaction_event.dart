import 'package:equatable/equatable.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';

class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionEventGetListBranch extends TransactionEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventGetListBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventFetchBranch extends TransactionEvent {
  final TransactionBranchInputDTO dto;

  const TransactionEventFetchBranch({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventGetList extends TransactionEvent {
  final TransactionInputDTO dto;

  const TransactionEventGetList({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class TransactionEventGetDetail extends TransactionEvent {
  final bool isLoading;

  const TransactionEventGetDetail({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class TransactionEventGetImage extends TransactionEvent {
  final bool isLoading;

  const TransactionEventGetImage({this.isLoading = true});

  @override
  List<Object?> get props => [isLoading];
}

class TransEventQRRegenerate extends TransactionEvent {
  final QRRecreateDTO dto;

  const TransEventQRRegenerate({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateNoteEvent extends TransactionEvent {
  final Map<String, dynamic> param;

  const UpdateNoteEvent(this.param);

  @override
  List<Object?> get props => [param];
}
