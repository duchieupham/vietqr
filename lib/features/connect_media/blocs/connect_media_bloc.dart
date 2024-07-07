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
    on<UpdateSharingEvent>(_updateSharing);
    on<UpdateUrlEvent>(_updateUrl);
  }

  ConnectGgChatRepository _repository = ConnectGgChatRepository();

  void _updateUrl(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is UpdateUrlEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectMedia.UPDATE_URL));

        final result = await _repository.updateUrl(
            url: event.url, type: event.type, id: event.id);
        if (result!) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectMedia.UPDATE_URL,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: ConnectMedia.UPDATE_URL,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.UPDATE_URL));
    }
  }

  void _updateSharing(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is UpdateSharingEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE,
            request: ConnectMedia.UPDATE_SHARING));

        final result = await _repository.updateSharingInfo(
            type: event.type,
            notificationTypes: event.notificationTypes,
            notificationContents: event.notificationContents,
            id: event.id);
        if (result!) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: ConnectMedia.UPDATE_SHARING,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: ConnectMedia.UPDATE_SHARING,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.UPDATE_SHARING));
    }
  }

  void _getInfo(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetInfoEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING_PAGE, request: ConnectMedia.NONE));

        InfoMediaDTO? result = await _repository.getInfoMedia(event.type);
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
        bool? result = await _repository.addBankMedia(
            event.webhookId, event.listBankId!, event.type);

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
        bool? result = await _repository.removeBank(
            event.webhookId, event.bankId!, event.type);
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
            type: event.type,
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
        bool? result = await _repository.deleteWebhook(event.id, event.type);
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
        bool? result = await _repository.checkWebhookUrl(event.url, event.type);
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
