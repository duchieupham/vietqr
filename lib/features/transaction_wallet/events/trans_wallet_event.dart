import 'package:equatable/equatable.dart';

class TransWalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionWalletEventGetList extends TransWalletEvent {
  final int status;

  TransactionWalletEventGetList(this.status);

  @override
  List<Object?> get props => [status];
}

class TransactionWalletEventFetch extends TransWalletEvent {
  final int status;

  TransactionWalletEventFetch(this.status);

  @override
  List<Object?> get props => [status];
}
