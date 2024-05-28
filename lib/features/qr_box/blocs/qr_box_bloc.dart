import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/qr_box/events/qr_box_event.dart';
import 'package:vierqr/features/qr_box/repositories/qr_box_repository.dart';
import 'package:vierqr/features/qr_box/states/qr_box_state.dart';

import '../../../commons/utils/log.dart';

class QRBoxBloc extends Bloc<QRBoxEvent, QRBoxState> with BaseManager {
  final BuildContext context;

  QRBoxBloc(this.context) : super(QRBoxState()) {
    on<GetTerminalsEvent>(_getTermials);
    on<GetMerchantEvent>(_getMerchants);
    on<ActiveQRBoxEvent>(_active);
  }

  QRBoxRepository _repository = QRBoxRepository();

  void _active(QRBoxEvent event, Emitter emit) async {
    try {
      if (event is ActiveQRBoxEvent) {
        emit(
            state.copyWith(status: BlocStatus.LOADING, request: QR_Box.ACTIVE));
        final result = await _repository.activeQRBox(
          cert: event.cert,
          terminalId: event.terminalId,
          bankId: event.bankId,
        );
        if (result != null) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: QR_Box.ACTIVE,
              active: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR, request: QR_Box.ACTIVE, active: null));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, request: QR_Box.ACTIVE));
    }
  }

  void _getMerchants(QRBoxEvent event, Emitter emit) async {
    try {
      if (event is GetMerchantEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QR_Box.GET_MERCHANTS));
        final result = await _repository.getListMerchant(event.bankId);
        if (result.isNotEmpty) {
          Future.delayed(Duration(milliseconds: 500));
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: QR_Box.GET_MERCHANTS,
              listMerchant: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: QR_Box.GET_MERCHANTS,
              listMerchant: []));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
        status: BlocStatus.ERROR,
        request: QR_Box.GET_MERCHANTS,
      ));
    }
  }

  void _getTermials(QRBoxEvent event, Emitter emit) async {
    try {
      if (event is GetTerminalsEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: QR_Box.GET_TERMINALS));
        final result = await _repository.getTerminals(
            bankId: event.bankId, merchantId: event.merchantId);
        if (result.isNotEmpty) {
          Future.delayed(Duration(milliseconds: 500));
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              request: QR_Box.GET_TERMINALS,
              listTerminal: result));
        } else {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: QR_Box.GET_TERMINALS,
              listTerminal: []));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR, request: QR_Box.GET_TERMINALS));
    }
  }
}
