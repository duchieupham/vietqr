import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/repositories/bank_card_repository.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/repositories/qr_feed_repository.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class QrFeedBloc extends Bloc<QrFeedEvent, QrFeedState> {
  QrFeedBloc() : super(const QrFeedState()) {
    on<GetQrFeedEvent>(_getQrFeed);
    on<GetMoreQrFeedEvent>(_getMoreQrFeed);
    on<CreateQrFeedLink>(_createQr);
    on<LoadBanksEvent>(_getBankTypes);
    on<SearchBankEvent>(_searchBankName);
    on<InteractWithQrEvent>(_interactWithQr);
  }

  final QrFeedRepository _qrFeedRepository = QrFeedRepository();

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

        final result =
            await _qrFeedRepository.getQrFeed(type: event.type, size: 10);
        Future.delayed(const Duration(milliseconds: 500));
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

  void _getMoreQrFeed(QrFeedEvent event, Emitter emit) async {
    try {
      if (event is GetMoreQrFeedEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOAD_MORE, request: QrFeed.GET_MORE));

        final result = await _qrFeedRepository.getQrFeed(
            type: event.type,
            size: 10,
            page: _qrFeedRepository.metaDataDTO.page! + 1);
        Future.delayed(const Duration(milliseconds: 500));

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
}
