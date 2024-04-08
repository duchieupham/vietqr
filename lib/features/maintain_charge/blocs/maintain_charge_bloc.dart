import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/maintain_charge/events/maintain_charge_events.dart';
import 'package:vierqr/features/maintain_charge/repositories/maintain_charge_repositories.dart';
import 'package:vierqr/features/maintain_charge/views/active_success_screen.dart';
import 'package:vierqr/models/maintain_charge_dto.dart';

import '../../../commons/constants/configurations/route.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/log.dart';
import '../../../services/providers/maintain_charge_provider.dart';
import '../../../services/providers/pin_provider.dart';
import '../states/maintain_charge_state.dart';
import '../views/confirm_active_key_screen.dart';

class MaintainChargeBloc extends Bloc<MaintainChargeEvents, MaintainChargeState>
    with BaseManager {
  @override
  final BuildContext context;

  MaintainChargeBloc(this.context) : super(MaintainChargeState()) {
    on<MaintainChargeEvent>(_chargeMaintain);
    on<ConfirmMaintainChargeEvent>(_confirmMaintainCharge);
  }

  final maintainChareRepositories = const MaintainChargeRepositories();

  void _chargeMaintain(MaintainChargeEvents event, Emitter emit) async {
    try {
      if (event is MaintainChargeEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final MaintainChargeStatus? status =
            await maintainChareRepositories.chargeMaintainace(event.dto);
        if (status?.code == "SUCCESS") {
          emit(state.copyWith(
              dto: status?.dto,
              createDto: event.dto,
              request: MainChargeType.CREATE_MAINTAIN,
              status: BlocStatus.SUCCESS));
          Map<String, dynamic> param = {};
          param['dto'] = state.dto;
          Navigator.of(context).pop();
          Provider.of<MaintainChargeProvider>(context, listen: false)
              .setIsError(false);
          Provider.of<PinProvider>(context, listen: false).reset();
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (_) => ConfirmActiveKeyScreen(
          //           dto: state.dto!,
          //           createDto: event.dto,
          //         )));
          Navigator.pushNamed(context, Routes.CONFIRM_ACTIVE_KEY_SCREEN,
              arguments: {'dto': state.dto, 'createDto': event.dto});
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: MainChargeType.CREATE_MAINTAIN,
            msg: status?.message,
            dto: null,
          ));
          if (state.status == BlocStatus.ERROR && state.msg != 'E55') {
            Provider.of<PinProvider>(context, listen: false).reset();
            Navigator.of(context).pop();
          } else if (state.msg == 'E55') {
            Provider.of<MaintainChargeProvider>(context, listen: false)
                .setIsError(true);
            Provider.of<PinProvider>(context, listen: false).reset();
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _confirmMaintainCharge(MaintainChargeEvents event, Emitter emit) async {
    try {
      if (event is ConfirmMaintainChargeEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final bool? isSuccess =
            await maintainChareRepositories.confirmMaintainCharge(event.dto);
        if (isSuccess == true) {
          emit(state.copyWith(
              request: MainChargeType.CONFIRM_SUCCESS,
              status: BlocStatus.SUCCESS));
          // Navigator.pushNamed(context, Routes.ACTIVE_SUCCESS_SCREEN);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ActiveSuccessScreen(),
              ));
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: MainChargeType.CONFIRM_SUCCESS,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }
}
