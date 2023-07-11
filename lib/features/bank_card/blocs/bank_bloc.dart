import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/error_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/repositories/bank_card_repository.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/home/blocs/home_bloc.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BankBloc extends Bloc<BankCardEvent, BankState> {
  BankBloc() : super(const BankState(listBanks: [], colors: [])) {
    on<BankCardEventInsert>(_insertBankCard);
    on<BankCardEventGetList>(_getBankAccounts);
    on<BankCardEventInsertUnauthenticated>(_insertBankCardUnauthenticated);
    on<BankCardEventRegisterAuthentication>(_registerAuthentication);
    on<BankCardEventRemove>(_removeBankAccount);
    on<BankCardGetDetailEvent>(_getDetail);
    on<ScanQrEventGetBankType>(_getBankType);
    on<UpdateEvent>(_updateEvent);
  }

  String userId = UserInformationHelper.instance.getUserId();
  final bankCardRepository = const BankCardRepository();

  void _registerAuthentication(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRegisterAuthentication) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO result = await bankCardRepository
            .updateRegisterAuthenticationBank(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(status: BlocStatus.SUCCESS));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              msg: ErrorUtils.instance.getErrorMessage(result.message)));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _insertBankCardUnauthenticated(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventInsertUnauthenticated) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO result =
            await bankCardRepository.insertBankCardUnauthenticated(event.dto);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          String bankId = '';
          String qr = '';
          if (result.message.isNotEmpty) {
            if (result.message.contains('*')) {
              bankId = result.message.split('*')[0];
              qr = result.message.split('*')[1];
            }
          }
          emit(state.copyWith(
              status: BlocStatus.INSERT, bankId: bankId, qr: qr));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              msg: ErrorUtils.instance.getErrorMessage(result.message)));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO dto =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: ErrorUtils.instance.getErrorMessage(dto.message)));
    }
  }

  void _insertBankCard(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventInsert) {
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.insertBankCard(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          String bankId = '';
          String qr = '';
          if (responseMessageDTO.message.isNotEmpty) {
            if (responseMessageDTO.message.contains('*')) {
              bankId = responseMessageDTO.message.split('*')[0];
              qr = responseMessageDTO.message.split('*')[1];
            }
          }
          emit(state.copyWith(
              status: BlocStatus.INSERT, bankId: bankId, qr: qr));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: message));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể thêm tài khoản. Vui lòng kiểm tra lại kết nối.'));
    }
  }

  void _getBankAccounts(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventGetList) {
        if (state.status == BlocStatus.NONE) {
          emit(state.copyWith(status: BlocStatus.LOADING));
        }
        List<BankAccountDTO> list =
            await bankCardRepository.getListBankAccount(event.userId);
        final List<Color> colors = [];
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        if (list.isNotEmpty) {
          List<BankAccountDTO> listLinked =
              list.where((e) => e.isAuthenticated).toList();
          List<BankAccountDTO> listNotLinked =
              list.where((e) => !e.isAuthenticated).toList();

          list = [...listLinked, ...listNotLinked];

          for (BankAccountDTO dto in list) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              colors.add(paletteGenerator.dominantColor!.color);
            } else {
              colors.add(Theme.of(context).cardColor);
            }
          }
        }
        emit(state.copyWith(
            status: BlocStatus.SUCCESS, listBanks: list, colors: colors));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _removeBankAccount(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRemove) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.removeBankAccount(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(status: BlocStatus.DELETE));
        } else if (responseMessageDTO.status ==
            Stringify.RESPONSE_STATUS_CHECK) {
          String message =
              CheckUtils.instance.getCheckMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: message));
        } else {
          String message =
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(status: BlocStatus.ERROR, msg: message));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Không thể huỷ liên kết. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _requestOTP(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardEventRequestOTP) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final ResponseMessageDTO responseMessageDTO =
            await bankCardRepository.requestOTP(event.dto);
        if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS,
              dto: event.dto,
              requestId: responseMessageDTO.message));
        } else {
          emit(state.copyWith(
              status: BlocStatus.ERROR,
              msg: ErrorUtils.instance
                  .getErrorMessage(responseMessageDTO.message)));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      ResponseMessageDTO responseMessageDTO =
          const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg:
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message)));
    }
  }

  // void _confirmOTP(BankCardEvent event, Emitter emit) async {
  //   try {
  //     if (event is BankCardEventConfirmOTP) {
  //       emit(BankCardConfirmOTPLoadingState());
  //       final ResponseMessageDTO responseMessageDTO =
  //           await bankCardRepository.confirmOTP(event.dto);
  //       if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
  //         emit(BankCardConfirmOTPSuccessState());
  //       } else {
  //         emit(state.copyWith(
  //             status: BlocStatus.ERROR,
  //             msg: ErrorUtils.instance
  //                 .getErrorMessage(responseMessageDTO.message)));
  //       }
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     ResponseMessageDTO responseMessageDTO =
  //         const ResponseMessageDTO(status: 'FAILED', message: 'E05');
  //     emit(state.copyWith(
  //         status: BlocStatus.ERROR,
  //         msg:
  //             ErrorUtils.instance.getErrorMessage(responseMessageDTO.message)));
  //   }
  // }

  void _getDetail(BankCardEvent event, Emitter emit) async {
    try {
      if (event is BankCardGetDetailEvent) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final AccountBankDetailDTO dto =
            await bankCardRepository.getAccountBankDetail(event.bankId);
        emit(state.copyWith(status: BlocStatus.SUCCESS, bankDetailDTO: dto));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

// void _checkExistedBank(BankCardEvent event, Emitter emit) async {
//   try {
//     if (event is BankCardCheckExistedEvent) {
//       emit(BankCardLoadingState());
//       final ResponseMessageDTO result = await bankCardRepository
//           .checkExistedBank(event.bankAccount, event.bankTypeId);
//       if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
//         emit(BankCardCheckNotExistedState());
//       } else if (result.status == Stringify.RESPONSE_STATUS_CHECK) {
//         emit(BankCardCheckExistedState(
//             msg: CheckUtils.instance.getCheckMessage(result.message)));
//       } else {
//         emit(state.copyWith(status: BlocStatus.ERROR));
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(state.copyWith(status: BlocStatus.ERROR));
//   }
// }

// void _searchBankName(BankCardEvent event, Emitter emit) async {
//   try {
//     if (event is BankCardEventSearchName) {
//       emit(BankCardSearchingNameState());
//       BankNameInformationDTO dto =
//           await bankCardRepository.searchBankName(event.dto);
//       if (dto.accountName.trim().isNotEmpty) {
//         emit(BankCardSearchNameSuccessState(dto: dto));
//       } else {
//         emit(state.copyWith(
//             status: BlocStatus.ERROR,
//             msg: 'Tài khoản ngân hàng không tồn tại.'));
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     emit(state.copyWith(
//         status: BlocStatus.ERROR, msg: 'Tài khoản ngân hàng không tồn tại.'));
//   }
// }

  void _getBankType(BankCardEvent event, Emitter emit) async {
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

  void _updateEvent(BankCardEvent event, Emitter emit) {
    emit(state.copyWith(type: TypePermission.None));
  }
}
