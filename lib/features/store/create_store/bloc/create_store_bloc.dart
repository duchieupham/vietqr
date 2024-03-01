import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/store/create_store/events/create_store_event.dart';
import 'package:vierqr/features/store/create_store/responsitory/create_store_responsitory.dart';
import 'package:vierqr/features/store/create_store/states/create_store_state.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/response_message_dto.dart';

class CreateStoreBloc extends Bloc<CreateStoreEvent, CreateStoreState>
    with BaseManager {
  final BuildContext context;

  CreateStoreBloc(this.context) : super(CreateStoreState(banks: [])) {
    on<RandomCodeStoreEvent>(_getRandomCode);
    on<UpdateCodeStoreEvent>(_updateRandomCode);
    on<UpdateAddressStoreEvent>(_updateAddress);
    on<GetListBankAccountLink>(_getBankAccountTerminal);
    on<CreateNewStoreEvent>(_createNewGroup);
  }

  CreateStoreRepository repository = CreateStoreRepository();

  void _getRandomCode(CreateStoreEvent event, Emitter emit) async {
    try {
      if (event is RandomCodeStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: StoreType.NONE));

        final result = await repository.getRandomCode();

        emit(state.copyWith(
            status: BlocStatus.NONE,
            codeStore: result,
            request: StoreType.RANDOM_CODE,
            isLoading: false));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));
    }
  }

  void _updateRandomCode(CreateStoreEvent event, Emitter emit) async {
    try {
      if (event is UpdateCodeStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: StoreType.NONE));

        emit(state.copyWith(
            status: BlocStatus.NONE,
            codeStore: event.codeStore,
            request: StoreType.UPDATE_CODE,
            isLoading: false));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));
    }
  }

  void _updateAddress(CreateStoreEvent event, Emitter emit) async {
    try {
      if (event is UpdateAddressStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: StoreType.NONE));

        emit(state.copyWith(
            status: BlocStatus.NONE,
            addressStore: event.addressStore,
            request: StoreType.UPDATE_ADDRESS,
            isLoading: false));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: StoreType.NONE));
    }
  }

  void _getBankAccountTerminal(CreateStoreEvent event, Emitter emit) async {
    try {
      if (event is GetListBankAccountLink) {
        emit(state.copyWith(status: BlocStatus.LOADING_PAGE));

        List<BankAccountTerminal> list = await repository
            .getListBankAccountTerminal(userId, event.terminalId);

        emit(state.copyWith(
            request: StoreType.GET_BANK,
            banks: list,
            status: BlocStatus.NONE,
            isEmpty: list.isEmpty));
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

  void _createNewGroup(CreateStoreEvent event, Emitter emit) async {
    ResponseMessageDTO responseMessageDTO =
        ResponseMessageDTO(status: '', message: '');
    try {
      if (event is CreateNewStoreEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: StoreType.NONE));
        responseMessageDTO = await repository.createStore(event.param);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              request: StoreType.CREATE_SUCCESS, status: BlocStatus.UNLOADING));
        } else {
          emit(
            state.copyWith(
              status: BlocStatus.ERROR,
              msg: responseMessageDTO.message,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.ERROR, msg: responseMessageDTO.message),
      );
    }
  }
}
