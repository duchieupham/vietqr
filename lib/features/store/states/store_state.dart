import 'package:equatable/equatable.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/models/store/store_dto.dart';
import 'package:vierqr/models/store/total_store_dto.dart';

enum StoreType {
  NONE,
  GET_STORES,
  GET_MERCHANTS,
  UPDATE_MERCHANTS,
  GET_TOTAL,
}

class StoreState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final StoreType request;
  final bool isLoadMore;
  final bool isEmpty;
  final TotalStoreDTO? totalStoreDTO;
  final List<StoreDTO> stores;
  final List<MerchantDTO> merchants;
  final int offset;

  const StoreState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = StoreType.NONE,
    this.isLoadMore = true,
    this.isEmpty = false,
    this.totalStoreDTO,
    this.offset = 0,
    required this.stores,
    required this.merchants,
  });

  StoreState copyWith({
    BlocStatus? status,
    StoreType? request,
    String? msg,
    bool? isLoadMore,
    bool? isEmpty,
    TotalStoreDTO? totalStoreDTO,
    List<StoreDTO>? stores,
    List<MerchantDTO>? merchants,
    int? offset,
  }) {
    return StoreState(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      isEmpty: isEmpty ?? this.isEmpty,
      totalStoreDTO: totalStoreDTO ?? this.totalStoreDTO,
      stores: stores ?? this.stores,
      merchants: merchants ?? this.merchants,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        offset,
        request,
        isEmpty,
        totalStoreDTO,
        isLoadMore,
        stores,
        merchants
      ];
}
