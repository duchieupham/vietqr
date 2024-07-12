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
  ConnectMediaBloc() : super(const ConnectMediaStates()) {
    on<GetListGGChatEvent>(_getListChat);
    on<GetListLarkEvent>(_getListLark);
    on<GetListTeleEvent>(_getListTele);
    on<GetListSlackEvent>(_getListSlack);
    on<GetListDiscordEvent>(_getListDiscord);
    on<GetListGGSheetEvent>(_getListGgSheet);

    on<GetInfoEvent>(_getInfo);
    on<CheckWebhookUrlEvent>(_checkValidUrl);
    on<DeleteWebhookEvent>(_deleteWebhook);
    on<MakeMediaConnectionEvent>(_makeConnection);
    on<AddBankMediaEvent>(_addBanks);
    on<RemoveMediaEvent>(_removeBank);
    on<UpdateSharingEvent>(_updateSharing);
    on<UpdateUrlEvent>(_updateUrl);
  }

  final ConnectGgChatRepository _repository = ConnectGgChatRepository();

  void _getListGgSheet(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListGGSheetEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_SHEET));
        final result = await _repository.getGgSheetList(
            page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_SHEET,
          listGgSheet: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_SHEET));
    }
  }

  void _getListDiscord(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListDiscordEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_DISCORD));
        final result = await _repository.getDiscordList(
            page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_DISCORD,
          listDiscord: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_DISCORD));
    }
  }

  void _getListSlack(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListSlackEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_SLACK));
        final result =
            await _repository.getSlackList(page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_SLACK,
          listSlack: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_SLACK));
    }
  }

  void _getListTele(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListTeleEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_TELE));
        final result =
            await _repository.getTeleList(page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_TELE,
          listTele: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_TELE));
    }
  }

  void _getListLark(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListLarkEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_LARK));
        final result =
            await _repository.getLarkList(page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_LARK,
          listLark: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_LARK));
    }
  }

  void _getListChat(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is GetListGGChatEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: event.isLoadMore
                ? ConnectMedia.LOAD_MORE
                : ConnectMedia.GET_LIST_CHAT));
        final result =
            await _repository.getChatList(page: event.page, size: event.size);
        emit(state.copyWith(
          status: event.isLoadMore ? BlocStatus.LOAD_MORE : BlocStatus.SUCCESS,
          request: ConnectMedia.GET_LIST_CHAT,
          listChat: [...result],
          metadata: _repository.metaDataDTO,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: ConnectMedia.GET_LIST_CHAT));
    }
  }

  void _updateUrl(ConnectMediaEvent event, Emitter emit) async {
    try {
      if (event is UpdateUrlEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: ConnectMedia.UPDATE_URL));

        final result = await _repository.updateUrl(
            webhook: event.url, type: event.type, id: event.id);
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
            status: BlocStatus.NONE, request: ConnectMedia.UPDATE_SHARING));

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

        InfoMediaDTO? result =
            await _repository.getInfoMedia(event.type, event.id);
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
