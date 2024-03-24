import 'package:equatable/equatable.dart';

class CreateStoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RandomCodeStoreEvent extends CreateStoreEvent {}

class UpdateCodeStoreEvent extends CreateStoreEvent {
  final String codeStore;

  UpdateCodeStoreEvent(this.codeStore);

  @override
  List<Object?> get props => [codeStore];
}

class UpdateAddressStoreEvent extends CreateStoreEvent {
  final String addressStore;

  UpdateAddressStoreEvent(this.addressStore);

  @override
  List<Object?> get props => [addressStore];
}

class GetListBankAccountLink extends CreateStoreEvent {
  final String terminalId;

  GetListBankAccountLink(this.terminalId);

  @override
  List<Object?> get props => [terminalId];
}

class GetListMerchantEvent extends CreateStoreEvent {
  final int offset;
  final bool loadMore;

  GetListMerchantEvent({this.offset = 0, this.loadMore = false});

  @override
  List<Object?> get props => [offset, loadMore];
}

class CreateNewStoreEvent extends CreateStoreEvent {
  final Map<String, dynamic> param;

  CreateNewStoreEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class CreateMerchantEvent extends CreateStoreEvent {
  final Map<String, dynamic> param;

  CreateMerchantEvent(this.param);

  @override
  List<Object?> get props => [param];
}
