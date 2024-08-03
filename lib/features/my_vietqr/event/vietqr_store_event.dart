import 'package:equatable/equatable.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class VietqrStoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetListStore extends VietqrStoreEvent {
  final int? page;
  final int? size;
  final String bankId;
  final bool isLoadMore;

  GetListStore(
      {this.page, this.size, required this.bankId, this.isLoadMore = false});

  @override
  List<Object?> get props => [page, size, bankId, isLoadMore];
}

class SetTerminalEvent extends VietqrStoreEvent {
  final TerminalDTO dto;

  SetTerminalEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
