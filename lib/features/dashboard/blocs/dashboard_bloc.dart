import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/dashboard/repostiroties/dashboard_repository.dart';
import 'package:vierqr/features/dashboard/states/dashboard_state.dart';
import 'package:vierqr/models/bank_name_information_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState>
    with BaseManager {
  @override
  final BuildContext context;

  DashBoardBloc(this.context) : super(const DashBoardState()) {
    on<PermissionEventGetStatus>(_getPermissionStatus);
    on<PermissionEventRequest>(_requestPermissions);
    on<ScanQrEventGetBankType>(_getBankType);
    on<DashBoardEventSearchName>(_searchBankName);
    on<DashBoardEventAddContact>(_addContact);
    on<DashBoardCheckExistedEvent>(_checkExistedBank);
    on<DashBoardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
    on<UpdateEvent>(_updateEvent);
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
          emit(state.copyWith(
              typePermission: DashBoardTypePermission.CameraDenied));
        } else {
          emit(state.copyWith(
              typePermission: DashBoardTypePermission.CameraAllow));
        }
        // if (permissions['sms']!.isGranted && permissions['camera']!.isGranted) {
        //   emit(PermissionAllowedState());
        //}
      }
    } catch (e) {
      LOG.error('Error at _getPermissionStatus - PermissionBloc: $e');
      emit(state.copyWith(typePermission: DashBoardTypePermission.Error));
    }
  }

  void _requestPermissions(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventRequest) {
        bool check = await dashBoardRepository.requestPermissions();
        if (check) {
          emit(state.copyWith(typePermission: DashBoardTypePermission.Allow));
        } else {
          emit(state.copyWith(typePermission: DashBoardTypePermission.Request));
        }
      }
    } catch (e) {
      LOG.error('Error at _requestPermissions - PermissionBloc: $e');
      emit(state.copyWith(typePermission: DashBoardTypePermission.Error));
    }
  }

  void _getBankType(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is ScanQrEventGetBankType) {
        state.copyWith(
            typeQR: TypeQR.NONE,
            request: DashBoardType.NONE,
            status: BlocStatus.NONE);
        TypeQR typeQR = await QRScannerUtils.instance.checkScan(event.code);
        if (typeQR == TypeQR.QR_BANK) {
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
                    request: DashBoardType.SCAN,
                    codeQR: event.code,
                    typeContact: TypeContact.Bank),
              );
            } else {
              emit(state.copyWith(request: DashBoardType.SCAN_ERROR));
            }
          }
        } else if (typeQR == TypeQR.QR_CMT) {
          NationalScannerDTO nationalScannerDTO =
              dashBoardRepository.getNationalInformation(event.code);
          if (nationalScannerDTO.nationalId.trim().isNotEmpty) {
            emit(
              state.copyWith(
                  nationalScannerDTO: nationalScannerDTO,
                  request: DashBoardType.SCAN,
                  typeQR: TypeQR.QR_CMT,
                  codeQR: event.code,
                  typeContact: TypeContact.Other),
            );
          } else {
            emit(state.copyWith(request: DashBoardType.SCAN_NOT_FOUND));
          }
        } else if (typeQR == TypeQR.QR_ID) {
          emit(
            state.copyWith(
                codeQR: event.code,
                request: DashBoardType.SCAN,
                typeQR: TypeQR.QR_ID,
                typeContact: TypeContact.VietQR_ID),
          );
        } else if (typeQR == TypeQR.QR_BARCODE) {
          if (event.code.isNotEmpty) {
            emit(
              state.copyWith(
                  barCode: event.code,
                  request: DashBoardType.SCAN,
                  typeQR: TypeQR.QR_BARCODE,
                  typeContact: TypeContact.Other),
            );
          }
        } else if (typeQR == TypeQR.QR_LINK) {
          emit(
            state.copyWith(
                codeQR: event.code,
                request: DashBoardType.SCAN,
                typeQR: TypeQR.QR_LINK,
                typeContact: TypeContact.Other),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: DashBoardType.SCAN_NOT_FOUND));
    }
  }

  void _searchBankName(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardEventSearchName) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        BankNameInformationDTO dto =
            await bankCardRepository.searchBankName(event.dto);
        if (dto.accountName.trim().isNotEmpty) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              informationDTO: dto,
              request: DashBoardType.SEARCH_BANK_NAME));
        } else {
          emit(
            state.copyWith(
              request: DashBoardType.SCAN_NOT_FOUND,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: DashBoardType.SCAN_NOT_FOUND, status: BlocStatus.NONE));
    }
  }

  void _addContact(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardEventAddContact) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        ResponseMessageDTO result =
            await bankCardRepository.addContact(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING,
              request: DashBoardType.ADD_BOOK_CONTACT));
        } else {
          emit(
            state.copyWith(
              request: DashBoardType.ADD_BOOK_CONTACT_EXIST,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: DashBoardType.ERROR));
    }
  }

  void _checkExistedBank(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardCheckExistedEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        final ResponseMessageDTO result = await bankCardRepository
            .checkExistedBank(event.bankAccount, event.bankTypeId);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(request: DashBoardType.EXIST_BANK));
        } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
          emit(state.copyWith(
              request: DashBoardType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: CheckUtils.instance.getCheckMessage(result.message)));
        } else {
          emit(state.copyWith(
              request: DashBoardType.ERROR, status: BlocStatus.UNLOADING));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(request: DashBoardType.ERROR));
    }
  }

  void _insertBankCardUnauthenticated(
      DashBoardEvent event, Emitter emit) async {
    try {
      if (event is DashBoardEventInsertUnauthenticated) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: DashBoardType.NONE));
        final ResponseMessageDTO result =
            await bankCardRepository.insertBankCardUnauthenticated(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(
            state.copyWith(
                request: DashBoardType.INSERT_BANK,
                status: BlocStatus.UNLOADING),
          );
        } else {
          emit(
            state.copyWith(
              msg: ErrorUtils.instance.getErrorMessage(result.message),
              status: BlocStatus.UNLOADING,
              request: DashBoardType.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
        msg: ErrorUtils.instance.getErrorMessage(dto.message),
        status: BlocStatus.UNLOADING,
        request: DashBoardType.ERROR,
      ));
    }
  }

  void _updateEvent(DashBoardEvent event, Emitter emit) {
    emit(state.copyWith(
      status: BlocStatus.NONE,
      request: DashBoardType.NONE,
      typePermission: DashBoardTypePermission.None,
      typeQR: TypeQR.NONE,
    ));
  }
}

DashboardRepository dashBoardRepository = const DashboardRepository();
