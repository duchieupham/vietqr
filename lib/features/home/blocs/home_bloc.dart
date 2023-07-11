import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/home/events/home_event.dart';
import 'package:vierqr/features/home/repostiroties/home_repository.dart';
import 'package:vierqr/features/home/states/home_state.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with BaseManager {
  @override
  final BuildContext context;

  HomeBloc(this.context) : super(const HomeState()) {
    on<PermissionEventGetStatus>(_getPermissionStatus);
    on<PermissionEventRequest>(_requestPermissions);
    on<ScanQrEventGetBankType>(_getBankType);
  }

  void _getPermissionStatus(HomeEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventGetStatus) {
        Map<String, PermissionStatus> permissions =
            await homeRepository.checkPermissions();
        // if (!permissions['sms']!.isGranted) {
        //   emit(PermissionSmsDeniedState());
        // } else {
        //   emit(PermissionSMSAllowedState());
        // }
        if (!permissions['camera']!.isGranted) {
          emit(state.copyWith(type: TypePermission.CameraDenied));
        } else {
          emit(state.copyWith(type: TypePermission.CameraAllow));
        }
        // if (permissions['sms']!.isGranted && permissions['camera']!.isGranted) {
        //   emit(PermissionAllowedState());
        //}
      }
    } catch (e) {
      LOG.error('Error at _getPermissionStatus - PermissionBloc: $e');
      emit(state.copyWith(type: TypePermission.Error));
    }
  }

  void _requestPermissions(HomeEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventRequest) {
        bool check = await homeRepository.requestPermissions();
        if (check) {
          emit(state.copyWith(type: TypePermission.Allow));
        } else {
          emit(state.copyWith(type: TypePermission.Request));
        }
      }
    } catch (e) {
      print('Error at _requestPermissions - PermissionBloc: $e');
      emit(state.copyWith(type: TypePermission.Error));
    }
  }

  void _getBankType(HomeEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        VietQRScannedDTO vietQRScannedDTO =
            QRScannerUtils.instance.getBankAccountFromQR(event.code);
        if (vietQRScannedDTO.caiValue.isNotEmpty &&
            vietQRScannedDTO.bankAccount.isNotEmpty) {
          BankTypeDTO dto = await homeRepository
              .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
          if (dto.id.isNotEmpty) {
            emit(
              state.copyWith(
                bankTypeDTO: dto,
                bankAccount: vietQRScannedDTO.bankAccount,
                type: TypePermission.ScanSuccess,
              ),
            );
          } else {
            emit(state.copyWith(type: TypePermission.ScanError));
          }
        } else {
          NationalScannerDTO nationalScannerDTO =
              homeRepository.getNationalInformation(event.code);
          if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
            emit(state.copyWith(nationalScannerDTO: nationalScannerDTO));
          } else {
            emit(state.copyWith(type: TypePermission.ScanNotFound));
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: TypePermission.ScanError));
    }
  }
}

HomeRepository homeRepository = const HomeRepository();
