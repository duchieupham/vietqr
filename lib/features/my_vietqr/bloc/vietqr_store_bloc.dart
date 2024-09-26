import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/my_vietqr/event/vietqr_store_event.dart';
import 'package:vierqr/features/my_vietqr/repository/vietqr_store_repository.dart';
import 'package:vierqr/features/my_vietqr/state/vietqr_store_state.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';

class VietQRStoreBloc extends Bloc<VietqrStoreEvent, VietQRStoreState> {
  VietQRStoreBloc()
      : super(const VietQRStoreState(
          listStore: [],
        )) {
    on<GetListStore>(_getList);
    on<SetTerminalEvent>(_setTerminal);
  }

  final VietqQRStoreRepository _repository = VietqQRStoreRepository();

  void _setTerminal(VietqrStoreEvent event, Emitter emit) async {
    if (event is SetTerminalEvent) {
      emit(state.copyWith(terminal: event.dto));
    }
  }

  void _getList(VietqrStoreEvent event, Emitter emit) async {
    try {
      if (event is GetListStore) {
        emit(state.copyWith(
            status:
                event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.LOADING,
            request: VietQrStore.GET_LIST));
        final result = await _repository.getListStore(
            bankId: event.bankId, page: event.page ?? 1, size: event.size ?? 5);
        if (!event.isLoadMore) {
          TerminalDTO terminalDTO = TerminalDTO(
              terminalId: '',
              terminalName: '',
              terminalCode: '',
              rawTerminalCode: '',
              terminalAddress: '',
              qrCode: '');
          if (result.isNotEmpty) {
            final listTer = result.first.terminals;
            if (listTer.isNotEmpty) {
              terminalDTO = listTer.first;
            }
          }
          await Future.delayed(const Duration(milliseconds: 500));
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: VietQrStore.GET_LIST,
            listStore: result,
            storeSelect: result.isNotEmpty ? result.first : null,
            // terminal: state.terminal == null
            //     ? terminalDTO
            //     : state.terminal!.terminalId.isNotEmpty
            //         ? state.terminal
            //         : terminalDTO,
            terminal: terminalDTO,
            metadata: _repository.metaDataDTO,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: VietQrStore.LOADMORE,
            listStore: result,
            metadata: _repository.metaDataDTO,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: VietQrStore.GET_LIST));
    }
  }
}
