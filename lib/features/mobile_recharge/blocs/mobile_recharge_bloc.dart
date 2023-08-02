import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/mobile_recharge/events/mobile_recharge_event.dart';
import 'package:vierqr/features/mobile_recharge/states/mobile_recharge_state.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/repositories/scan_qr_repository.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/features/top_up/events/scan_qr_event.dart';
import 'package:vierqr/features/top_up/repositories/top_up_repository.dart';
import 'package:vierqr/features/top_up/states/top_up_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/network_providers_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

import '../repositories/mobile_recharge_repository.dart';

class MobileRechargeBloc
    extends Bloc<MobileRechargeEvent, MobileRechargeState> {
  MobileRechargeBloc() : super(MobileRechargeInitialState()) {
    on<MobileRechargeGetListType>(_getListType);
  }
}

const MobileRechargeRepository mobileRechargeRepository =
    MobileRechargeRepository();

void _getListType(MobileRechargeEvent event, Emitter emit) async {
  try {
    if (event is MobileRechargeGetListType) {
      emit(MobileRechargeLoadingState());
      List<NetworkProviders> results = [];
      results = await mobileRechargeRepository.getListNetworkProviders();
      if (results.isNotEmpty) {
        emit(MobileRechargeGetListTypeSuccessState(list: results));
      } else {
        emit(MobileRechargeGetListTypeFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MobileRechargeGetListTypeFailedState());
  }
}
