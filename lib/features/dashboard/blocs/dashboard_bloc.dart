import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/repostiroties/dashboard_repository.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState>
    with BaseManager {
  @override
  final BuildContext context;

  DashBoardBloc(this.context) : super(const DashBoardState()) {
    on<PermissionEventGetStatus>(_getPermissionStatus);
    on<PermissionEventRequest>(_requestPermissions);
    on<ScanQrEventGetBankType>(_getBankType);
  }

  void _getPermissionStatus(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventGetStatus) {
        Map<String, PermissionStatus> permissions =
            await dashBoardRepository.checkPermissions();
        // if (!permissions['sms']!.isGranted) {
        //   emit(PermissionSmsDeniedState());
        // } else {
        //   emit(PermissionSMSAllowedState());
        // }
        if (!permissions['camera']!.isGranted) {
          emit(state.copyWith(type: DashBoardTypePermission.CameraDenied));
        } else {
          emit(state.copyWith(type: DashBoardTypePermission.CameraAllow));
        }
        // if (permissions['sms']!.isGranted && permissions['camera']!.isGranted) {
        //   emit(PermissionAllowedState());
        //}
      }
    } catch (e) {
      LOG.error('Error at _getPermissionStatus - PermissionBloc: $e');
      emit(state.copyWith(type: DashBoardTypePermission.Error));
    }
  }

  void _requestPermissions(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventRequest) {
        bool check = await dashBoardRepository.requestPermissions();
        if (check) {
          emit(state.copyWith(type: DashBoardTypePermission.Allow));
        } else {
          emit(state.copyWith(type: DashBoardTypePermission.Request));
        }
      }
    } catch (e) {
      print('Error at _requestPermissions - PermissionBloc: $e');
      emit(state.copyWith(type: DashBoardTypePermission.Error));
    }
  }

  void _getBankType(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        state.copyWith(typeQR: TypeQR.NONE, request: DashBoardType.NONE);
        VietQRScannedDTO vietQRScannedDTO =
            QRScannerUtils.instance.getBankAccountFromQR(event.code);
        if (vietQRScannedDTO.caiValue.isNotEmpty &&
            vietQRScannedDTO.bankAccount.isNotEmpty) {
          BankTypeDTO dto = await dashBoardRepository
              .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
          if (dto.id.isNotEmpty) {
            emit(
              state.copyWith(
                  bankTypeDTO: dto,
                  bankAccount: vietQRScannedDTO.bankAccount,
                  typeQR: TypeQR.QR_BANK,
                  request: DashBoardType.SCAN),
            );
          } else {
            emit(state.copyWith(request: DashBoardType.SCAN_ERROR));
          }
        } else {
          NationalScannerDTO nationalScannerDTO =
              dashBoardRepository.getNationalInformation(event.code);
          if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
            emit(state.copyWith(
              nationalScannerDTO: nationalScannerDTO,
              request: DashBoardType.SCAN,
              typeQR: TypeQR.QR_CMT,
            ));
          } else if (event.code.isNotEmpty) {
            emit(state.copyWith(
              barCode: event.code,
              request: DashBoardType.SCAN,
              typeQR: TypeQR.QR_BARCODE,
            ));
          } else {
            emit(state.copyWith(request: DashBoardType.SCAN_NOT_FOUND));
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: DashBoardType.SCAN_NOT_FOUND));
    }
  }
}

DashboardRepository dashBoardRepository = const DashboardRepository();
