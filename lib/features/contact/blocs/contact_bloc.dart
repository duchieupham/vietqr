import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/check_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/contact/events/contact_event.dart';
import 'package:vierqr/features/contact/repostiroties/contact_repository.dart';
import 'package:vierqr/features/contact/states/contact_state.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/viet_qr_scanned_dto.dart';
import 'package:vierqr/models/vietqr_dto.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> with BaseManager {
  @override
  BuildContext context;

  final String qrCode;
  final TypeContact typeQR;
  final dynamic dto;

  ContactBloc(this.context,
      {this.qrCode = '', this.typeQR = TypeContact.NONE, this.dto})
      : super(ContactState(
          listContactDTO: const [],
          listContactDTOSuggest: const [],
          contactDetailDTO: ContactDetailDTO(),
          qrCode: qrCode,
          typeQR: typeQR,
          dto: dto,
          colors: const [],
        )) {
    on<InitDataEvent>(_getNickNameWalletId);
    on<ContactEventGetList>(_getListContact);
    on<ContactEventGetListRecharge>(_getListContactRecharge);
    on<ContactEventGetListPending>(_getListContactPending);
    on<ContactEventGetDetail>(_getDetailContact);
    on<RemoveContactEvent>(_removeContact);
    on<UpdateContactEvent>(_updateContact);
    on<SaveContactEvent>(_saveContact);
    on<ScanQrContactEvent>(_scanQrGetType);
    on<UpdateStatusContactEvent>(_updateStatusContact);
    on<GetNickNameContactEvent>(_getNickNameWalletId);
    on<UpdateEventContact>(_updateState);
    on<SearchUser>(_searchUser);
  }

  final repository = ContactRepository();

  void _getListContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetList) {
        List<Color> colors = [];
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        emit(state.copyWith(
            status: BlocStatus.NONE, isLoading: true, type: ContactType.NONE));
        int type = event.type ?? 9;
        int offset = event.offset ?? 0;

        List<ContactDTO> result =
            await repository.getListSaveContact(userId, type, offset * 20);
        result.sort((a, b) => a.nickname.compareTo(b.nickname));
        for (ContactDTO dto in result) {
          if (dto.type == 1) {
            colors.add(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            colors.add(AppColor.GREY_TEXT);
          } else {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              colors.add(paletteGenerator.dominantColor!.color);
            } else {
              if (!mounted) return;
              colors.add(Theme.of(context).cardColor);
            }
          }
        }

        emit(
          state.copyWith(
            listContactDTO: result,
            type: ContactType.GET_LIST,
            colors: colors,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getListContactRecharge(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetListRecharge) {
        List<ContactDTO> result =
            await repository.getListContactRecharge(userId);
        result.sort((a, b) => a.nickname.compareTo(b.nickname));
        if (result.isNotEmpty) {
          emit(
            state.copyWith(
              listContactDTO: result,
              type: ContactType.GET_LIST_RECHARGE,
            ),
          );
        } else {
          emit(state.copyWith(type: ContactType.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getListContactPending(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetListPending) {
        final result = await repository.getListContactPending(userId);
        if (result.isNotEmpty) {
          emit(
            state.copyWith(
              listContactDTOSuggest: result,
              status: BlocStatus.NONE,
              type: ContactType.GET_LIST,
            ),
          );
        } else {
          emit(state.copyWith(
              listContactDTOSuggest: [],
              status: BlocStatus.NONE,
              type: ContactType.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getDetailContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetDetail) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            type: ContactType.GET_DETAIL,
          ),
        );
        final result = await repository.getContactDetail(event.id);
        if (result.id!.isNotEmpty) {
          emit(
            state.copyWith(
              contactDetailDTO: result,
              status: BlocStatus.UNLOADING,
              type: ContactType.GET_DETAIL,
            ),
          );
        } else {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _removeContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is RemoveContactEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            type: ContactType.NONE,
          ),
        );
        ResponseMessageDTO result = await repository.removeContact(event.id);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.REMOVE));
        } else {
          emit(
            state.copyWith(
              type: ContactType.ERROR,
              status: BlocStatus.UNLOADING,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _updateContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is UpdateContactEvent) {
        emit(
          state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE),
        );
        ResponseMessageDTO result =
            await repository.updateContact(event.query, event.image);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.UPDATE));
        } else {
          emit(
            state.copyWith(
                type: ContactType.ERROR, status: BlocStatus.UNLOADING),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.ERROR));
    }
  }

  void _saveContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is SaveContactEvent) {
        emit(
            state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE));
        ResponseMessageDTO result = await bankCardRepository
            .addContact(event.dto, file: event.dto.image);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.SAVE));
        } else {
          emit(state.copyWith(
              type: ContactType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: 'Thẻ QR này đã được thêm trước đó'));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          type: ContactType.ERROR, msg: 'Thẻ QR này đã được thêm trước đó'));
    }
  }

  void _updateStatusContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is UpdateStatusContactEvent) {
        emit(
            state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE));
        ResponseMessageDTO result =
            await repository.updateStatusContact(event.query);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.SUGGEST));
        } else {
          emit(state.copyWith(
              type: ContactType.ERROR,
              status: BlocStatus.UNLOADING,
              msg: CheckUtils.instance.getCheckMessage(result.message)));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.ERROR));
    }
  }

  void _getNickNameWalletId(ContactEvent event, Emitter emit) async {
    try {
      if (event is GetNickNameContactEvent) {
        if (typeQR == TypeContact.VietQR_ID) {
          emit(state.copyWith(status: BlocStatus.NONE, type: ContactType.NONE));
          if (dto is VietQRDTO) {
            VietQRDTO data = dto;

            emit(
              state.copyWith(
                type: ContactType.NICK_NAME,
                nickName: data.nickName,
                imgId: data.imgId,
              ),
            );
          }
        } else if (typeQR == TypeContact.Bank) {
          VietQRScannedDTO vietQRScannedDTO =
              QRScannerUtils.instance.getBankAccountFromQR(qrCode);
          if (vietQRScannedDTO.caiValue.isNotEmpty &&
              vietQRScannedDTO.bankAccount.isNotEmpty) {
            BankTypeDTO dto = await dashBoardRepository
                .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
            if (dto.id.isNotEmpty) {
              emit(state.copyWith(
                bankTypeDTO: dto,
                bankAccount: vietQRScannedDTO.bankAccount,
                type: ContactType.SCAN,
                qrCode: qrCode,
                typeQR: TypeContact.Bank,
              ));
            } else {
              emit(state.copyWith(type: ContactType.SCAN_ERROR));
            }
          }
        } else {
          emit(
            state.copyWith(
              type: ContactType.OTHER,
              typeQR: TypeContact.Other,
              qrCode: qrCode,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.ERROR));
    }
  }

  void _scanQrGetType(ContactEvent event, Emitter emit) async {
    try {
      if (event is ScanQrContactEvent) {
        state.copyWith(type: ContactType.NONE, status: BlocStatus.NONE);
        TypeQR typeQR = await QRScannerUtils.instance.checkScan(event.code);
        if (typeQR == TypeQR.QR_BANK) {
          VietQRScannedDTO vietQRScannedDTO =
              QRScannerUtils.instance.getBankAccountFromQR(event.code);
          if (vietQRScannedDTO.caiValue.isNotEmpty &&
              vietQRScannedDTO.bankAccount.isNotEmpty) {
            BankTypeDTO dto = await dashBoardRepository
                .getBankTypeByCaiValue(vietQRScannedDTO.caiValue);
            if (dto.id.isNotEmpty) {
              emit(state.copyWith(
                bankTypeDTO: dto,
                bankAccount: vietQRScannedDTO.bankAccount,
                type: ContactType.SCAN,
                qrCode: event.code,
                typeQR: TypeContact.Bank,
              ));
            } else {
              emit(state.copyWith(type: ContactType.SCAN_ERROR));
            }
          }
        } else if (typeQR == TypeQR.QR_ID) {
          emit(
            state.copyWith(
              qrCode: event.code,
              type: ContactType.SCAN,
              typeQR: TypeContact.VietQR_ID,
            ),
          );
        } else if (typeQR == TypeQR.QR_LINK) {
          emit(
            state.copyWith(
              qrCode: event.code,
              type: ContactType.SCAN,
              typeQR: TypeContact.Other,
            ),
          );
        } else {}
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.SCAN_ERROR));
    }
  }

  void _updateState(ContactEvent event, Emitter emit) async {
    try {
      if (event is UpdateEventContact) {
        emit(
          state.copyWith(
            type: ContactType.NONE,
            status: BlocStatus.NONE,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  void _searchUser(ContactEvent event, Emitter emit) async {
    try {
      List<ContactDTO> result = [];
      if (event is SearchUser) {
        result = await repository.searchUser(event.phoneNo);
        result.sort((a, b) => a.nickname.compareTo(b.nickname));
        emit(
          state.copyWith(
            listContactDTO: result,
            type: ContactType.SEARCH_USER,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.ERROR));
    }
  }
}
