import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/repositories/qr_feed_repository.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';

class QrFeedBloc extends Bloc<QrFeedEvent, QrFeedState> {
  QrFeedBloc() : super(const QrFeedState()) {
    on<GetQrFeedEvent>(_getQrFeed);
    on<GetMoreQrFeedEvent>(_getMoreQrFeed);
  }

  final QrFeedRepository _qrFeedRepository = QrFeedRepository();

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
