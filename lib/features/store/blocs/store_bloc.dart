import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/store/store.dart';
import 'package:vierqr/models/store/store_dto.dart';
import 'package:vierqr/models/store/total_store_dto.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> with BaseManager {
  final BuildContext context;

  StoreBloc(this.context) : super(StoreState(stores: [], merchants: [])) {
    on<GetTotalStoreByDayEvent>(_getTotalStoreByDay);
    on<GetListStoreEvent>(_getListStore);
    on<GetMerchantsEvent>(_getListMerchant);
    on<UpdateListStoreEvent>(_updateListStore);
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

  void _getListMerchant(StoreEvent event, Emitter emit) async {
    try {
      if (event is GetMerchantsEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));

        final result = await repository.getListMerchant();

        emit(
          state.copyWith(
            request: StoreType.GET_MERCHANTS,
            status: BlocStatus.NONE,
            merchants: result,
            isEmpty: result.isEmpty,
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

  void _updateListStore(StoreEvent event, Emitter emit) async {
    try {
      if (event is UpdateListStoreEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));

        List<StoreDTO> list = [...state.stores];
        TotalStoreDTO dto = state.totalStoreDTO ?? TotalStoreDTO();
        int totalTerminal = dto.totalTerminal ?? 0;

        int index =
            list.indexWhere((element) => element.terminalId == event.id);

        if (index != -1) {
          list.removeAt(index);
          if (totalTerminal > 0) {
            dto.totalTerminal = totalTerminal - 1;
          }
        }

        emit(
          state.copyWith(
              request: StoreType.UPDATE_MERCHANTS,
              status: BlocStatus.NONE,
              stores: list,
              totalStoreDTO: dto),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.ERROR,
            msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối'),
      );
    }
  }
}
