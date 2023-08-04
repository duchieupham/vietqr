import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/mobile_recharge/events/mobile_recharge_event.dart';
import 'package:vierqr/features/mobile_recharge/states/mobile_recharge_state.dart';
import 'package:vierqr/models/network_providers_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import '../repositories/mobile_recharge_repository.dart';

class MobileRechargeBloc
    extends Bloc<MobileRechargeEvent, MobileRechargeState> {
  MobileRechargeBloc() : super(MobileRechargeInitialState()) {
    on<MobileRechargeGetListType>(_getListType);
    on<MobileRechargeMobileMoney>(_getMobileMoney);
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

void _getMobileMoney(MobileRechargeEvent event, Emitter emit) async {
  ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
  try {
    if (event is MobileRechargeMobileMoney) {
      emit(MobileRechargeMobileMoneyLoadingState());

      result = await mobileRechargeRepository.mobileMoney(event.data);
      if (result.status == 'SUCCESS') {
        emit(MobileRechargeMobileMoneySuccessState(dto: result));
      } else {
        emit(MobileRechargeMobileMoneyFailedState(dto: result));
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(MobileRechargeMobileMoneyFailedState(dto: result));
  }
}
