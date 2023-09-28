import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vcard_maintained/vcard_maintained.dart';
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
          listCompareContact: const [],
          listContactDTO: const [],
          listContactDTOSuggest: const [],
          contactDetailDTO: ContactDetailDTO(),
          qrCode: qrCode,
          typeQR: typeQR,
          dto: dto,
        )) {
    on<InitDataEvent>(_getNickNameWalletId);
    on<ContactEventGetList>(_getListContact);
    on<ContactEventGetListRecharge>(_getListContactRecharge);
    on<ContactEventGetListPending>(_getListContactPending);
    on<ContactEventGetDetail>(_getDetailContact);
    on<RemoveContactEvent>(_removeContact);
    on<UpdateContactEvent>(_updateContact);
    on<UpdateContactRelationEvent>(_updateRelation);
    on<SaveContactEvent>(_saveContact);
    on<ScanQrContactEvent>(_scanQrGetType);
    on<UpdateStatusContactEvent>(_updateStatusContact);
    on<GetNickNameContactEvent>(_getNickNameWalletId);
    on<UpdateEventContact>(_updateState);
    on<SearchUser>(_searchUser);
  }

  final repository = ContactRepository();

  var vCard = VCard();

  void _getListContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetList) {
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        emit(state.copyWith(
            status: BlocStatus.NONE,
            isLoading: event.isLoading,
            type: ContactType.NONE));
        int type = event.type ?? 8;
        int offset = event.offset ?? 0;

        List<ContactDTO> result =
            await repository.getListSaveContact(userId, type, offset * 20);
        result.sort((a, b) {
          return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
        });

        List<List<ContactDTO>> listAll = [];
        List<String> listString = [];

        if (result.isNotEmpty) {
          for (int i = 0; i < result.length; i++) {
            if (result[i].nickname.isNotEmpty) {
              String keyName = result[i].nickname[0].toUpperCase();
              listString.add(keyName);
            } else {
              listString.add('');
            }
          }

          listString = listString.toSet().toList();

          for (int i = 0; i < listString.length; i++) {
            List<ContactDTO> listCompare = [];
            listCompare = result.where((element) {
              if (element.nickname.isNotEmpty) {
                return element.nickname[0].toUpperCase() == listString[i];
              } else {
                return element.nickname.toUpperCase() == listString[i];
              }
            }).toList();

            listAll.add(listCompare);
          }
        }

        for (ContactDTO dto in result) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              dto.setColor(paletteGenerator.dominantColor!.color);
            } else {
              if (!mounted) return;
              dto.setColor(Theme.of(context).cardColor);
            }
          }
        }

        emit(
          state.copyWith(
            listCompareContact: listAll,
            listContactDTO: result,
            type: ContactType.GET_LIST,
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
        emit(state.copyWith(
            status: BlocStatus.NONE, isLoading: true, type: ContactType.NONE));
        final result = await repository.getListContactPending(userId);
        if (result.isNotEmpty) {
          emit(
            state.copyWith(
              listContactDTOSuggest: result,
              status: BlocStatus.NONE,
              type: ContactType.GET_LIST_PEN,
              isLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(
            listContactDTOSuggest: [],
            status: BlocStatus.NONE,
            type: ContactType.NONE,
            isLoading: false,
          ));
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
            state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE));

        ContactDetailDTO result = ContactDetailDTO();

        if (event.type != 4) {
          result = await repository.getContactDetail(event.id);
        } else {
          final data = await FlutterContacts.getContact(event.id);
          if (data != null) {
            String phone =
                data.phones.isNotEmpty ? data.phones.first.number : '';
            String email =
                data.emails.isNotEmpty ? data.emails.first.address : '';
            String nickName = data.displayName;

            String lastName = data.name.last;
            String firstName = data.name.first;

            String base64Image = '';
            if (data.photo != null) {
              base64Image = base64Encode(data.photo!);
            }

            int random = Random().nextInt(5);

            vCard.middleName = data.name.middle;
            vCard.firstName = firstName;
            vCard.lastName = lastName;
            vCard.cellPhone = phone;
            vCard.email = email;
            vCard.url = base64Image;

            result = ContactDetailDTO(
              id: data.id,
              userId: userId,
              additionalData:
                  data.notes.isNotEmpty ? data.notes.first.note : '-',
              nickName: nickName,
              email: email.isNotEmpty ? email : '-',
              type: 4,
              status: 0,
              value: vCard.getFormattedString(),
              bankShortName: '',
              bankName: '',
              imgId: base64Image,
              bankAccount: phone,
              colorType: random,
              relation: 0,
            );
          }
        }

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

  void _updateRelation(ContactEvent event, Emitter emit) async {
    try {
      if (event is UpdateContactRelationEvent) {
        emit(
          state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE),
        );
        ResponseMessageDTO result =
            await repository.updateRelation(event.query);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: ContactType.UPDATE_RELATION));
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
