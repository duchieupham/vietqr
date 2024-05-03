import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/detail_store/events/detail_store_event.dart';
import 'package:vierqr/features/detail_store/repositories/detail_store_repository.dart';
import 'package:vierqr/features/detail_store/states/detail_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';
import 'package:vierqr/models/store/trans_store_dto.dart';
import 'package:vierqr/models/trans_dto.dart';

class DetailStoreBloc extends Bloc<DetailStoreEvent, DetailStoreState>
    with BaseManager {
  final BuildContext context;
  final String terminalId;
  final String terminalCode;

  DetailStoreBloc(this.context, {this.terminalId = '', this.terminalCode = ''})
      : super(DetailStoreState(
            members: [],
            transDTO: TransStoreDTO(),
            terminals: [],
            detailStore: DetailStoreDTO())) {
    on<GetTransStoreEvent>(_getTransStore);
    on<FetchTransStoreEvent>(_fetchTransStore);
    on<GetDetailStoreEvent>(_getDetailStore);
    on<GetDetailQREvent>(_getDetailQR);
    on<GetMembersStoreEvent>(_getMembersStore);
    on<GetTerminalStoreEvent>(_getTerminalStore);
    on<AddMemberGroup>(_addMember);

    on<RemoveMemberEvent>(_removeMember);
  }

  DetailStoreRepository repository = DetailStoreRepository();

  void _getTransStore(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is GetTransStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: DetailStoreType.NONE));
        bool loadMore = true;
        int _page = 1;

        final result = await repository.getTransStore(
          terminalCode,
          event.subTerminalCode,
          event.value,
          event.fromDate,
          event.toDate,
          event.type,
          _page,
        );

        if (_page >= result.totalPage) {
          loadMore = false;
        } else {
          _page = _page + 1;
        }

        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DetailStoreType.GET_TRANS,
          transDTO: result,
          isLoadMore: loadMore,
          isEmpty: result.totalElement <= 0,
          page: _page,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _fetchTransStore(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is FetchTransStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DetailStoreType.NONE));
        bool loadMore = state.isLoadMore;
        if (!loadMore) return;

        int _page = state.page;
        List<TransDTO> list = [...state.transDTO.items];

        final result = await repository.getTransStore(
          terminalCode,
          event.subTerminalCode,
          event.value,
          event.fromDate,
          event.toDate,
          event.type,
          _page,
        );

        list = [...list, ...result.items];
        result.items = [...list];

        if (_page >= result.totalPage || result.items.length < 20) {
          loadMore = false;
        } else {
          _page = _page + 1;
        }

        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DetailStoreType.GET_TRANS,
          transDTO: result,
          isLoadMore: loadMore,
          isEmpty: result.totalElement <= 0,
          page: _page,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _getDetailStore(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is GetDetailStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DetailStoreType.NONE));

        final result = await repository.getDetailStore(
            terminalId, event.fromDate, event.toDate);

        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DetailStoreType.GET_DETAIL,
          detailStore: result,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _getDetailQR(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is GetDetailQREvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DetailStoreType.NONE));

        final result = await repository.getDetailQR(terminalId);

        emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DetailStoreType.GET_QR,
          detailStore: result,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _getMembersStore(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is GetMembersStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DetailStoreType.NONE));

        final result = await repository.getMembersStore(terminalId);

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DetailStoreType.GET_MEMBER,
            members: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _getTerminalStore(DetailStoreEvent event, Emitter emit) async {
    try {
      if (event is GetTerminalStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DetailStoreType.NONE));

        final result = await repository.getTerminalStore(terminalId);

        if (result.isNotEmpty) {
          result.insert(0, SubTerminal(subTerminalName: 'Tất cả'));
        }

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DetailStoreType.GET_TERMINAL,
            terminals: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DetailStoreType.NONE));
    }
  }

  void _addMember(DetailStoreEvent event, Emitter emit) async {
    ResponseMessageDTO responseMessageDTO =
        ResponseMessageDTO(status: '', message: '');
    try {
      if (event is AddMemberGroup) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DetailStoreType.NONE));
        Map<String, dynamic> param = {};
        param['userId'] = event.userId;
        param['terminalId'] = event.terminalId;
        param['merchantId'] = event.merchantId;

        responseMessageDTO = await repository.addMemberGroup(param);

        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: DetailStoreType.ADD_MEMBER));
        } else {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: DetailStoreType.ERROR,
              msg: responseMessageDTO.message));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          request: DetailStoreType.ERROR,
          msg: responseMessageDTO.message));
    }
  }

  void _removeMember(DetailStoreEvent event, Emitter emit) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      if (event is RemoveMemberEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: DetailStoreType.NONE));

        Map<String, dynamic> param = {};
        param['userId'] = event.userId;
        param['terminalId'] = terminalId;
        result = await repository.removeMember(param);

        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: DetailStoreType.REMOVE_MEMBER));
        } else {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: DetailStoreType.ERROR,
              msg: result.message));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          request: DetailStoreType.ERROR,
          msg: result.message));
    }
  }
}
