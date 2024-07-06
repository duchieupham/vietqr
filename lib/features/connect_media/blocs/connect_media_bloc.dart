import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../commons/mixin/base_manager.dart';
import '../../../commons/utils/log.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../events/connect_media_evens.dart';
import '../repositories/connect_media_repositories.dart';
import '../states/connect_media_states.dart';

class ConnectMediaBloc extends Bloc<ConnectMediaEvent, ConnectMediaStates> {
  ConnectMediaBloc() : super(ConnectMediaStates()) {
    on<GetInfoEvent>(_getInfo);
    on<CheckWebhookUrlEvent>(_checkValidUrl);
    on<DeleteWebhookEvent>(_deleteWebhook);
    on<MakeMediaConnectionEvent>(_makeConnection);
    on<AddBankMediaEvent>(_addBanks);
    on<RemoveMediaEvent>(_removeBank);
  }

  ConnectGgChatRepository _repository = ConnectGgChatRepository();

  void _getInfo(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetInfoEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectMedia.NONE));

        InfoMediaDTO? result = await _repository.getInfoGgChat();
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: ConnectMedia.GET_INFO,
              dto: result,
              hasInfo: true));
        } else {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: ConnectMedia.GET_INFO,
              dto: null,
              hasInfo: false));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }

  void _addBanks(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is AddBankMediaEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectMedia.NONE));
        bool? result =
            await _repository.addBankGgChat(event.webhookId, event.listBankId!);

        emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          request: ConnectMedia.ADD_BANKS,
          isAddSuccess: result,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }

  void _removeBank(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is RemoveMediaEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectMedia.NONE));
        bool? result =
            await _repository.removeBank(event.webhookId, event.bankId!);
        emit(state.copyWith(
          status: BlocStatus.UNLOADING,
          request: ConnectMedia.REMOVE_BANK,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }

  void _makeConnection(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is MakeMediaConnectionEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectMedia.NONE));
        bool? result = await _repository.connectWebhook(event.webhook,
            list: event.listBankId,
            notificationTypes: event.notificationTypes,
            notificationContents: event.notificationContents);
        emit(state.copyWith(
            status: BlocStatus.UNLOADING,
            request: ConnectMedia.MAKE_CONNECTION,
            isConnectSuccess: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }

  void _deleteWebhook(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is DeleteWebhookEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectMedia.NONE));
        bool? result = await _repository.deleteWebhook(event.id);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectMedia.DELETE_URL,
            hasInfo: !result!));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }

  void _checkValidUrl(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is CheckWebhookUrlEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: ConnectMedia.NONE));
        bool? result = await _repository.checkWebhookUrl(event.url);
        emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectMedia.CHECK_URL,
            isValidUrl: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.NONE, request: ConnectMedia.NONE));
    }
  }
}
