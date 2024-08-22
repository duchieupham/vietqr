import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/maintain_charge/events/maintain_charge_events.dart';
import 'package:vierqr/features/maintain_charge/repositories/maintain_charge_repositories.dart';
import 'package:vierqr/features/maintain_charge/views/active_success_screen.dart';
import 'package:vierqr/models/annual_fee_dto.dart';
import 'package:vierqr/models/maintain_charge_dto.dart';

import '../../../commons/constants/configurations/route.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/log.dart';
import '../../../services/providers/maintain_charge_provider.dart';
import '../../../services/providers/pin_provider.dart';
import '../states/maintain_charge_state.dart';
import '../views/annual_fee_screen.dart';

class MaintainChargeBloc extends Bloc<MaintainChargeEvents, MaintainChargeState>
    with BaseManager {
  @override
  final BuildContext context;

  MaintainChargeBloc(this.context) : super(const MaintainChargeState()) {
    on<MaintainChargeEvent>(_chargeMaintain);
    on<ConfirmMaintainChargeEvent>(_confirmMaintainCharge);
    on<GetAnnualFeeListEvent>(_getAnnualFeeList);
    on<RequestActiveAnnualFeeEvent>(_requestActiveAnnualFee);
  }

  final _maintainChareRepositories = const MaintainChargeRepositories();

  void _requestActiveAnnualFee(MaintainChargeEvents event, Emitter emit) async {
    try {
      if (event is RequestActiveAnnualFeeEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final ActiveAnnualStatus? statusResquest =
            await _maintainChareRepositories.activeAnnual(
                type: event.type,
                feeId: event.feeId,
                bankId: event.bankId,
                userId: event.userId,
                password: event.password);
        if (statusResquest?.code == "SUCCESS") {
          emit(state.copyWith(
              request: MainChargeType.REQUEST_ACTIVE_ANNUAL_FEE,
              status: BlocStatus.SUCCESS));
          final ActiveAnnualStatus? statusConfirm =
              await _maintainChareRepositories.confirmActiveAnnual(
                  otp: statusResquest?.res?.otp,
                  bankId: event.bankId,
                  userId: event.userId,
                  password: event.password,
                  request: statusResquest?.res?.request,
                  otpPayment: statusResquest?.res?.otpPayment,
                  feeId: event.feeId);
          if (statusConfirm?.code == "SUCCESS") {
            emit(state.copyWith(
                request: MainChargeType.CONFIRM_ACTIVE_ANNUAL_FEE,
                status: BlocStatus.SUCCESS));
            Provider.of<AuthenProvider>(context, listen: false)
                .checkStateLogin(false);
            Provider.of<PinProvider>(context, listen: false).reset();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QrAnnualFeeScreen(
                    bankCode: event.bankCode,
                    bankName: event.bankName,
                    bankAccount: event.bankAccount,
                    userBankName: event.userBankName,
                    billNumber: statusConfirm?.confirm?.billNumber,
                    qr: statusConfirm?.confirm?.qr,
                    duration: statusResquest?.res?.duration,
                    amount: statusConfirm?.confirm?.amount,
                    validFrom: statusResquest?.res?.validFrom,
                    validTo: statusResquest?.res?.validTo,
                  ),
                ));
          } else {
            emit(state.copyWith(
              status: BlocStatus.ERROR,
              request: MainChargeType.REQUEST_ACTIVE_ANNUAL_FEE,
              msg: statusResquest?.message,
            ));

            if (state.status == BlocStatus.ERROR && state.msg != 'E55') {
              Provider.of<PinProvider>(context, listen: false).reset();
              Navigator.of(context).pop();
            } else if (state.msg == 'E55') {
              Provider.of<AuthenProvider>(context, listen: false)
                  .checkStateLogin(true);
              Provider.of<PinProvider>(context, listen: false).reset();
            }
          }
        } else {
          emit(state.copyWith(
            status: BlocStatus.ERROR,
            request: MainChargeType.REQUEST_ACTIVE_ANNUAL_FEE,
            msg: statusResquest?.message,
          ));

          if (state.status == BlocStatus.ERROR && state.msg != 'E55') {
            Provider.of<PinProvider>(context, listen: false).reset();
            Navigator.of(context).pop();
          } else if (state.msg == 'E55') {
            Provider.of<AuthenProvider>(context, listen: false)
                .checkStateLogin(true);
            Provider.of<PinProvider>(context, listen: false).reset();
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _getAnnualFeeList(MaintainChargeEvents event, Emitter emit) async {
    try {
      if (event is GetAnnualFeeListEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<AnnualFeeDTO>? list =
            await _maintainChareRepositories.getAnnualFeeList(event.bankId);
        if (list!.isNotEmpty) {
          emit(state.copyWith(
              listAnnualFee: list,
              request: MainChargeType.GET_ANNUAL_FEE_LIST,
              status: BlocStatus.SUCCESS));
          Provider.of<MaintainChargeProvider>(context, listen: false)
              .updateList(list);
        } else {
          emit(state.copyWith(
              listAnnualFee: null,
              request: MainChargeType.GET_ANNUAL_FEE_LIST,
              status: BlocStatus.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR, msg: 'Đã có lỗi xảy ra.'));
    }
  }

  void _chargeMaintain(MaintainChargeEvents event, Emitter emit) async {
    try {
      if (event is MaintainChargeEvent) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        final MaintainChargeStatus? status =
            await _maintainChareRepositories.chargeMaintainace(event.dto);
        if (status?.code == "SUCCESS") {
          emit(state.copyWith(
              dto: status?.dto,
              createDto: event.dto,
              request: MainChargeType.CREATE_MAINTAIN,
              status: BlocStatus.SUCCESS));
          Map<String, dynamic> param = {};
          param['dto'] = state.dto;
          Navigator.of(context).pop();
          Provider.of<AuthenProvider>(context, listen: false)
              .checkStateLogin(false);
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
            Provider.of<AuthenProvider>(context, listen: false)
                .checkStateLogin(true);
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
            await _maintainChareRepositories.confirmMaintainCharge(event.dto);
        if (isSuccess == true) {
          emit(state.copyWith(
              request: MainChargeType.CONFIRM_SUCCESS,
              status: BlocStatus.SUCCESS));
          // Navigator.pushNamed(context, Routes.ACTIVE_SUCCESS_SCREEN);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ActiveSuccessScreen(type: 0),
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
