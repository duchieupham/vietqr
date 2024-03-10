import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/store/store.dart';
import 'package:vierqr/models/store/store_dto.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> with BaseManager {
  final BuildContext context;

  StoreBloc(this.context) : super(StoreState(stores: [])) {
    on<GetTotalStoreByDayEvent>(_getTotalStoreByDay);
    on<GetListStoreEvent>(_getListStore);
  }

  StoreRepository repository = StoreRepository();

  void _getTotalStoreByDay(StoreEvent event, Emitter emit) async {
    try {
      if (event is GetTotalStoreByDayEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: StoreType.NONE));

        final result = await repository.getTotalStoreByDay(
            event.merchantId, event.fromDate, event.toDate);

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: StoreType.GET_TOTAL,
            totalStoreDTO: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));
    }
  }

  int limit = 10;

  void _getListStore(StoreEvent event, Emitter emit) async {
    try {
      if (event is GetListStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: StoreType.NONE));

        if (!state.isLoadMore && event.isLoadMore) {
          return;
        }

        bool loadMore = true;
        int offset = state.offset;
        List<StoreDTO> list = [...state.stores];

        if (event.refresh) {
          offset = 0;
        }

        final result = await repository.getListStore(
            event.merchantId, event.fromDate, event.toDate, offset * limit);

        if (result.isEmpty || result.length < limit) {
          loadMore = false;
        }

        if (event.isLoadMore) {
          list = [...list, ...result];
        } else {
          list = [...result];
        }
        emit(
          state.copyWith(
            request: StoreType.GET_STORES,
            status: BlocStatus.NONE,
            stores: list,
            offset: offset + 1,
            isLoadMore: loadMore,
            isEmpty: list.isEmpty,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.ERROR,
            msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'),
      );
    }
  }
}
