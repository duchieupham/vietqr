import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/detail_store/events/detail_store_event.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/repositories/qr_feed_repository.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';

class QrFeedBloc extends Bloc<QrFeedEvent, QrFeedState> {
  QrFeedBloc() : super(const QrFeedState()) {
    on<GetQrFeedEvent>(_getQrFeed);
    on<GetQrFeedFolderEvent>(_getQrFeedFolder);
    on<GetMoreQrFeedFolderEvent>(_getMoreQrFeedFolder);

    on<GetQrFeedPrivateEvent>(_getQrFeedPrivate);
    on<GetMoreQrPrivateEvent>(_getMoreQrPrivate);

    on<GetMoreQrFeedEvent>(_getMoreQrFeed);
    on<CreateQrFeedLink>(_createQr);
    on<LoadBanksEvent>(_getBankTypes);
    on<SearchBankEvent>(_searchBankName);
    on<InteractWithQrEvent>(_interactWithQr);
    on<GetQrFeedDetailEvent>(_getDetailQrFeed);
    on<LoadConmmentEvent>(_loadCmt);
    on<AddCommendEvent>(_addCmt);
    on<GetQrFeedPopupDetailEvent>(_getQrFeedPopupDetail);
    on<DeleteQrCodesEvent>(_deleteQrCodes);
  }

  final QrFeedRepository _qrFeedRepository = QrFeedRepository();

  void _addCmt(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is AddCommendEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.ADD_CMT));

        final result = await _qrFeedRepository.addCommend(
            qrWalletId: event.qrWalletId,
            message: event.message,
            page: event.page ?? 1,
            size: event.size ?? 10);
        if (result != null) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.ADD_CMT,
            loadCmt: result,
            detailQr: null,
            detailMetadata: result.comments.metadata,
          ));
        } else {
          emit(
            state.copyWith(
              request: QrFeed.ADD_CMT,
              status: BlocStatus.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: QrFeed.ADD_CMT,
        status: BlocStatus.ERROR,
      ));
    }
  }

  void _loadCmt(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is LoadConmmentEvent) {
        emit(state.copyWith(
            status: event.isLoadMore
                ? BlocStatus.LOADING
                : (event.isLoading ? BlocStatus.LOADING_PAGE : BlocStatus.NONE),
            request: QrFeed.LOAD_CMT));

        final result = await _qrFeedRepository.getDetailQrFeed(
            page: event.isLoadMore ? event.page! + 1 : (event.page ?? 1),
            size: event.size ?? 10,
            qrWalletId: event.id);
        await Future.delayed(const Duration(milliseconds: 500));
        if (result != null) {
          emit(state.copyWith(
            status: event.isLoadMore
                ? BlocStatus.LOAD_MORE
                : (event.isLoading ? BlocStatus.SUCCESS : BlocStatus.UNLOADING),
            request: QrFeed.LOAD_CMT,
            loadCmt: result,
            detailQr: null,
            detailMetadata: result.comments.metadata,
          ));
        } else {
          emit(
            state.copyWith(
              request: QrFeed.LOAD_CMT,
              status: BlocStatus.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: QrFeed.LOAD_CMT,
        status: BlocStatus.ERROR,
      ));
    }
  }

  void _getQrFeedPopupDetail(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetQrFeedPopupDetailEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: QrFeed.GET_QR_FEED_POPUP_DETAIL));

        final result = await _qrFeedRepository.getQrFeedPopupDetail(
            qrWalletId: event.qrWalletId);
        if (result != null) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.GET_QR_FEED_POPUP_DETAIL,
            qrFeedPopupDetail: result,
          ));
        } else {
          emit(
            state.copyWith(
              request: QrFeed.GET_QR_FEED_POPUP_DETAIL,
              status: BlocStatus.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: QrFeed.GET_QR_FEED_POPUP_DETAIL,
        status: BlocStatus.ERROR,
      ));
    }
  }

  void _getDetailQrFeed(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetQrFeedDetailEvent) {
        emit(state.copyWith(
            status: event.isLoading ? BlocStatus.LOADING_PAGE : BlocStatus.NONE,
            request: QrFeed.GET_DETAIL_QR));

        final result = await _qrFeedRepository.getDetailQrFeed(
            page: event.page ?? 1,
            size: event.size ?? 10,
            qrWalletId: event.id);
        if (result != null) {
          emit(state.copyWith(
            status: event.isLoading ? BlocStatus.SUCCESS : BlocStatus.UNLOADING,
            request: QrFeed.GET_DETAIL_QR,
            detailQr: result,
            detailMetadata: result.comments.metadata,
          ));
        } else {
          emit(
            state.copyWith(
              request: QrFeed.GET_DETAIL_QR,
              status: BlocStatus.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        request: QrFeed.GET_DETAIL_QR,
        status: BlocStatus.ERROR,
      ));
    }
  }

  void _searchBankName(QrFeedEvent event, Emitter emit) async {
    BankCardRepository bankCardRepository = const BankCardRepository();

    try {
      if (event is SearchBankEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.SEARCH_BANK));
        final dto = await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              bankDto: dto,
              request: QrFeed.SEARCH_BANK));
        } else {
          emit(
            state.copyWith(
              msg: 'Tài khoản ngân hàng không tồn tại.',
              request: QrFeed.SEARCH_BANK,
              status: BlocStatus.NONE,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        msg: 'Tài khoản ngân hàng không tồn tại.',
        request: QrFeed.SEARCH_BANK,
        status: BlocStatus.ERROR,
      ));
    }
  }

  void _getBankTypes(QrFeedEvent event, Emitter emit) async {
    BankCardRepository bankCardRepository = const BankCardRepository();

    try {
      if (event is LoadBanksEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.GET_BANKS));
        List<BankTypeDTO> list = await bankCardRepository.getBankTypes();
        if (list.isNotEmpty) {
          list.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
        }

        emit(
          state.copyWith(
              listBanks: list,
              status: BlocStatus.UNLOADING,
              request: QrFeed.GET_BANKS),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: QrFeed.GET_BANKS));
    }
  }

  void _interactWithQr(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is InteractWithQrEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: QrFeed.INTERACT_WITH_QR));
        final result = await _qrFeedRepository.interactWithQr(
          qrWalletId: event.qrWalletId,
          interactionType: event.interactionType,
        );
        if (result != null) {
          emit(state.copyWith(
            qrFeed: result,
            status: BlocStatus.SUCCESS,
            request: QrFeed.INTERACT_WITH_QR,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: QrFeed.INTERACT_WITH_QR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: QrFeed.CREATE_QR));
    }
  }

  void _createQr(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is CreateQrFeedLink) {
        emit(
            state.copyWith(status: BlocStatus.NONE, request: QrFeed.CREATE_QR));
        final result = await _qrFeedRepository.createQrLink(
            dto: event.dto, file: event.file);
        Future.delayed(const Duration(milliseconds: 500));
        if (result.status == 'SUCCESS') {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.CREATE_QR,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: QrFeed.CREATE_QR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: QrFeed.CREATE_QR));
    }
  }

  void _getQrFeed(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetQrFeedEvent) {
        emit(state.copyWith(
            status: event.isLoading ? BlocStatus.LOADING_PAGE : BlocStatus.NONE,
            request: QrFeed.GET_QR_FEED_LIST));

        final result = await _qrFeedRepository.getQrFeed(
            type: event.type, size: event.size ?? 10, page: event.page ?? 1);
        await Future.delayed(const Duration(milliseconds: 500));
        if (result.isNotEmpty) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.GET_QR_FEED_LIST,
            listQrFeed: [...result],
            metadata: _qrFeedRepository.metaDataDTO,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.NONE,
            request: QrFeed.GET_QR_FEED_LIST,
            listQrFeed: [],
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.GET_QR_FEED_LIST));
    }
  }

  void _getMoreQrPrivate(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetMoreQrPrivateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.GET_MORE_QR));

        final result = await _qrFeedRepository.getQrFeedPrivate(
            type: event.type,
            value: event.value,
            page: event.page ?? 1,
            size: event.size ?? 20);
        if (result.isNotEmpty) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.GET_MORE_QR,
            privateMetadata: _qrFeedRepository.privateMetadata,
            listQrFeedPrivate: [...result],
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.NONE,
            request: QrFeed.GET_MORE_QR,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.GET_MORE_QR));
    }
  }

  void _getMoreQrFeedFolder(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetMoreQrFeedFolderEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOAD_MORE, request: QrFeed.GET_MORE_FOLDER));

        final result = await _qrFeedRepository.getQrFeedFolder(
            type: event.type,
            value: event.value,
            page: event.page ?? 1,
            size: event.size ?? 20);

        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: QrFeed.GET_MORE_FOLDER,
          folderMetadata: _qrFeedRepository.folderMetadata,
          listQrFeedFolder: [...result],
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.GET_MORE_FOLDER));
    }
  }

  void _getQrFeedFolder(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetQrFeedFolderEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.GET_QR_FEED_FOLDER));

        final result = await _qrFeedRepository.getQrFeedFolder(
            type: event.type,
            value: event.value,
            page: event.page ?? 1,
            size: event.size ?? 20);

        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: QrFeed.GET_QR_FEED_FOLDER,
          folderMetadata: _qrFeedRepository.folderMetadata,
          listQrFeedFolder: [...result],
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.GET_QR_FEED_FOLDER));
    }
  }

  void _getQrFeedPrivate(QrFeedEvent event, Emitter emit) async {
    List<QrFeedPrivateDTO> result1 = [];
    List<QrFeedFolderDTO> result2 = [];
    try {
      if (event is GetQrFeedPrivateEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING,
            request: QrFeed.GET_QR_FEED_PRIVATE,
            isFolderLoading: event.isFolderLoading));

        result1 = await _qrFeedRepository.getQrFeedPrivate(
            type: event.type,
            value: event.value,
            page: event.page ?? 1,
            size: event.size ?? 20);
        if (event.isGetFolder) {
          result2 = await _qrFeedRepository.getQrFeedFolder(
              type: event.type ?? 1,
              value: '',
              page: event.folderPage ?? 1,
              size: event.folderSize ?? 20);
        } else {
          if (state.listQrFeedFolder != null) {
            result2 = [...state.listQrFeedFolder!];
          }
        }
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: QrFeed.GET_QR_FEED_PRIVATE,
          privateMetadata: _qrFeedRepository.privateMetadata,
          listQrFeedPrivate: [...result1],
          listQrFeedFolder: [...result2],
          isFolderLoading:
              event.isFolderLoading ? !event.isFolderLoading : false,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.GET_QR_FEED_PRIVATE));
    }
  }

  void _getMoreQrFeed(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetMoreQrFeedEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOAD_MORE, request: QrFeed.GET_MORE));

        final result = await _qrFeedRepository.getQrFeed(
            type: event.type,
            size: 10,
            page: _qrFeedRepository.metaDataDTO.page! + 1);
        await Future.delayed(const Duration(milliseconds: 500));

        if (result.isNotEmpty) {
          emit(state.copyWith(
            status: BlocStatus.SUCCESS,
            request: QrFeed.GET_MORE,
            listQrFeed: [...result],
            metadata: _qrFeedRepository.metaDataDTO,
          ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.NONE,
            request: QrFeed.GET_MORE,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: QrFeed.GET_MORE));
    }
  }

  void _deleteQrCodes(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is DeleteQrCodesEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QrFeed.DELETE_QR_FEED));
        await _qrFeedRepository.deleteQrCodes(event.qrIds!);
        emit(state.copyWith(
          status: BlocStatus.SUCCESS,
          request: QrFeed.DELETE_QR_FEED,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QrFeed.DELETE_QR_FEED));
    }
  }
}
