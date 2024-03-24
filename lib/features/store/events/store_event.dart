import 'package:equatable/equatable.dart';

class StoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetListStoreEvent extends StoreEvent {
  final String merchantId;
  final String fromDate;
  final String toDate;
  final bool isLoadMore;
  final bool refresh;

  GetListStoreEvent({
    this.merchantId = '',
    this.fromDate = '',
    this.toDate = '',
    this.isLoadMore = false,
    this.refresh = false,
  });

  @override
  List<Object?> get props =>
      [merchantId, isLoadMore, fromDate, toDate, refresh];
}

class GetTotalStoreByDayEvent extends StoreEvent {
  final String merchantId;
  final String fromDate;
  final String toDate;

  GetTotalStoreByDayEvent({
    this.merchantId = '',
    this.fromDate = '',
    this.toDate = '',
  });

  @override
  List<Object?> get props => [merchantId, fromDate, toDate];
}

class GetMerchantsEvent extends StoreEvent {}

class UpdateListStoreEvent extends StoreEvent {
  final String id;

  UpdateListStoreEvent(this.id);

  @override
  List<Object?> get props => [id];
}
