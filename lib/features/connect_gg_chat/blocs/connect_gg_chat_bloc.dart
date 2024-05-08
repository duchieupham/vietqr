import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../commons/mixin/base_manager.dart';
import '../../../commons/utils/log.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../events/connect_gg_chat_evens.dart';
import '../repositories/connect_gg_chat_repositories.dart';
import '../states/connect_gg_chat_states.dart';

class ConnectGgChatBloc extends Bloc<ConnectGgChatEvent, ConnectGgChatStates>
    with BaseManager {
  @override
  final BuildContext context;

  ConnectGgChatBloc(this.context) : super(ConnectGgChatStates()) {
    on<GetInfoEvent>(_getInfo);
    on<CheckWebhookUrlEvent>(_checkValidUrl);
    on<DeleteWebhookEvent>(_deleteWebhook);
    on<MakeGgChatConnectionEvent>(_makeConnection);
  }

  ConnectGgChatRepository _repository = ConnectGgChatRepository();

  void _getInfo(ConnectGgChatEvent event, Emitter emit) async {
    try {
      if (event is GetInfoEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectGgChat.NONE));
        InfoGgChatDTO? result = await _repository.getInfoGgChat();
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: ConnectGgChat.GET_INFO,
              dto: result,
              hasInfo: true));
        } else {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: ConnectGgChat.GET_INFO,
              dto: null,
              hasInfo: false));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
          state.copyWith(status: BlocStatus.NONE, request: ConnectGgChat.NONE));
    }
  }

  void _makeConnection(ConnectGgChatEvent event, Emitter emit) async {
    try {
      if (event is MakeGgChatConnectionEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectGgChat.NONE));
        bool? result =
            await _repository.connectWebhook(event.listBankId, event.webhook);
        emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: ConnectGgChat.MAKE_CONNECTION,
            isConnectSuccess: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
          state.copyWith(status: BlocStatus.NONE, request: ConnectGgChat.NONE));
    }
  }

  void _deleteWebhook(ConnectGgChatEvent event, Emitter emit) async {
    try {
      if (event is DeleteWebhookEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectGgChat.NONE));
        bool? result = await _repository.deleteWebhook(event.id);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectGgChat.DELETE_URL,
            hasInfo: !result!));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
          state.copyWith(status: BlocStatus.NONE, request: ConnectGgChat.NONE));
    }
  }

  void _checkValidUrl(ConnectGgChatEvent event, Emitter emit) async {
    try {
      if (event is CheckWebhookUrlEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectGgChat.NONE));
        bool? result = await _repository.checkWebhookUrl(event.url);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectGgChat.CHECK_URL,
            isValidUrl: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
          state.copyWith(status: BlocStatus.NONE, request: ConnectGgChat.NONE));
    }
  }
}
