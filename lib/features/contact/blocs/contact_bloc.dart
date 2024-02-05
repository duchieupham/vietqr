import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          listContactDetail: const [],
        )) {
    on<InitDataEvent>(_getNickNameWalletId);
    on<ContactEventGetList>(_getListContact);
    on<GetListContactLoadMore>(_fetchListContact);
    on<ContactEventGetListRecharge>(_getListContactRecharge);
    on<ContactEventGetListPending>(_getListContactPending);
    on<ContactEventGetDetail>(_getDetailContact);
    on<ContactEventGetListDetail>(_getListDetailContact);
    on<RemoveContactEvent>(_removeContact);
    on<UpdateContactEvent>(_updateContact);
    on<UpdateContactRelationEvent>(_updateRelation);
    on<SaveContactEvent>(_saveContact);
    on<UpdateStatusContactEvent>(_updateStatusContact);
    on<GetNickNameContactEvent>(_getNickNameWalletId);
    on<UpdateEventContact>(_updateState);
    on<SearchUser>(_searchUser);
    on<InsertVCardEvent>(_insertVCard);
    on<UpdateContactVCardEvent>(_updateContactVCard);
    on<SearchContactEvent>(_searchContact);
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

        for (ContactDTO dto in result) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else if (dto.type != 4) {
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

        result.sort((a, b) {
          return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
        });

        List<List<ContactDTO>> listAll = await _compareList(result);

        emit(
          state.copyWith(
            listCompareContact: listAll,
            listContactDTO: result,
            type: ContactType.GET_LIST,
            isLoading: false,
            isLoadMore: false,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _fetchListContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is GetListContactLoadMore) {
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        emit(state.copyWith(
            status: BlocStatus.NONE,
            isLoading: event.isLoading,
            type: ContactType.NONE));

        bool isLoadMore = false;
        int type = event.type ?? 8;
        int offset = event.offset ?? 0;

        List<ContactDTO> data = state.listContactDTO;
        List<ContactDetailDTO> details = [];
        List<List<ContactDTO>> listAll = [];

        if (event.isCompare) {
          details.addAll(state.listContactDetail);
        }

        List<ContactDTO> result =
            await repository.getListSaveContact(userId, type, offset * 20);

        if (result.isEmpty || result.length < 20) {
          isLoadMore = true;
        }

        data.addAll(result);

        if (event.isCompare) {
          result.forEach((element) {
            details.add(ContactDetailDTO());
          });
        }

        for (ContactDTO dto in data) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else if (dto.type != 4) {
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

        if (!event.isCompare) {
          data.sort((a, b) {
            return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
          });
          listAll = await _compareList(data);
        }

        emit(
          state.copyWith(
            listCompareContact: listAll,
            listContactDTO: data,
            listContactDetail: details,
            type: ContactType.GET_LIST,
            isLoading: false,
            isLoadMore: isLoadMore,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  Future<List<List<ContactDTO>>> _compareList(List<ContactDTO> result) async {
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
    return listAll;
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
          state.copyWith(
            status: BlocStatus.LOADING,
            type: ContactType.NONE,
            listContactDTO:
                event.list.isNotEmpty ? event.list : state.listContactDTO,
          ),
        );
        int index = 0;
        List<ContactDTO> values = [];
        List<ContactDetailDTO> details = [];
        values.addAll(state.listContactDTO);

        values.forEach((element) {
          element.setIsGet(false);
          details.add(ContactDetailDTO());
        });

        if (values.isNotEmpty) {
          index = values.indexWhere((element) => element.id == event.id);
          ContactDTO data = values[index];

          final result = await repository.getContactDetail(data.id);
          if (result.id.isNotEmpty) {
            values[index].setIsGet(true);
            details[index] = result;
          }

          if (index > 0) {
            ContactDTO data1 = values[index - 1];

            final result1 = await repository.getContactDetail(data1.id);
            if (result1.id.isNotEmpty) {
              details.removeAt(index - 1);
              details.insert(index - 1, result1);
            }
          }

          if (values.length > (index + 1)) {
            ContactDTO data1 = values[index + 1];

            final result1 = await repository.getContactDetail(data1.id);
            if (result1.id.isNotEmpty) {
              details.removeAt(index + 1);
              details.insert(index + 1, result1);
            }
          }
        }
        if (details.isNotEmpty) {
          emit(
            state.copyWith(
              listContactDetail: details,
              listContactDTO: values,
              contactDetailDTO: details[index],
              status: BlocStatus.UNLOADING,
              type: ContactType.GET_DETAIL,
              isChange: event.isChange,
              pageIndex: index,
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

  void _getListDetailContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is ContactEventGetListDetail) {
        List<ContactDTO> values = [];
        List<ContactDetailDTO> details = [];
        values.addAll(state.listContactDTO);
        details.addAll(state.listContactDetail);
        if (values.isNotEmpty) {
          if (event.index == 0) {
            ContactDTO data = values[(event.index + 1)];
            final result = await repository.getContactDetail(data.id);
            if (result.id.isNotEmpty) {
              values[event.index].setIsGet(true);
              details.removeAt((event.index + 1));
              details.insert((event.index + 1), result);
            }
          } else if (event.index > 0) {
            ContactDTO data = values[(event.index + 1)];
            final result = await repository.getContactDetail(data.id);
            if (result.id.isNotEmpty) {
              values[event.index].setIsGet(true);
              details.removeAt((event.index + 1));
              details.insert((event.index + 1), result);
            }

            ContactDTO data1 = values[(event.index - 1)];
            final result1 = await repository.getContactDetail(data1.id);
            if (result.id.isNotEmpty) {
              values[(event.index - 1)].setIsGet(true);
              details.removeAt((event.index - 1));
              details.insert((event.index - 1), result1);
            }
          }

          if (details.isNotEmpty) {
            emit(
              state.copyWith(
                  listContactDetail: details,
                  listContactDTO: values,
                  status: BlocStatus.NONE,
                  contactDetailDTO: details[event.index],
                  type: event.isChange
                      ? ContactType.GET_DETAIL
                      : ContactType.NONE,
                  isChange: event.isChange),
            );
          } else {
            emit(state.copyWith(
                status: BlocStatus.NONE, type: ContactType.NONE));
          }
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

  void _updateContactVCard(ContactEvent event, Emitter emit) async {
    try {
      if (event is UpdateContactVCardEvent) {
        emit(
          state.copyWith(status: BlocStatus.LOADING, type: ContactType.NONE),
        );
        ResponseMessageDTO result =
            await repository.updateContactVCard(event.query, event.image);
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
          state.copyWith(status: BlocStatus.NONE, type: ContactType.NONE),
        );
        ResponseMessageDTO result =
            await repository.updateRelation(event.query);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.NONE, type: ContactType.UPDATE_RELATION));
        } else {
          emit(
            state.copyWith(type: ContactType.ERROR, status: BlocStatus.NONE),
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
        } else if (typeQR == TypeContact.VCard) {
          emit(
            state.copyWith(
              type: ContactType.VCARD,
              typeQR: TypeContact.VCard,
              qrCode: qrCode,
              cardModel: getVCard(qrCode),
            ),
          );
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

  void _insertVCard(ContactEvent event, Emitter emit) async {
    try {
      if (event is InsertVCardEvent) {
        emit(state.copyWith(
            status: event.isLoading ? BlocStatus.LOADING : BlocStatus.NONE,
            type: ContactType.NONE));
        ResponseMessageDTO result = await repository.insertVCard(event.list);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: event.isLoading ? BlocStatus.UNLOADING : BlocStatus.NONE,
              type: ContactType.INSERT_VCARD));
        } else {
          emit(state.copyWith(
              type: ContactType.ERROR,
              status: event.isLoading ? BlocStatus.UNLOADING : BlocStatus.NONE,
              msg: CheckUtils.instance.getCheckMessage(result.message)));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(type: ContactType.ERROR));
    }
  }

  void _searchContact(ContactEvent event, Emitter emit) async {
    try {
      if (event is SearchContactEvent) {
        PaletteGenerator? paletteGenerator;
        BuildContext context = NavigationService.navigatorKey.currentContext!;
        emit(state.copyWith(status: BlocStatus.NONE, type: ContactType.NONE));
        int type = event.type ?? 8;
        int offset = event.offset ?? 0;

        List<ContactDTO> result = await repository.searchContact(
            event.nickName, userId, type, offset * 20);

        for (ContactDTO dto in result) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else if (dto.type != 4) {
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

        result.sort((a, b) {
          return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
        });

        List<List<ContactDTO>> listAll = await _compareList(result);

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

  VCardModel getVCard(String data) {
    if (data.isEmpty) {
      return VCardModel();
    }

    List<String> list = data.split("\r\n");

    String name = '';
    String phone = '';
    String email = '';
    String company = '';
    String address = '';
    String website = '';

    list.forEach((element) {
      if (element.contains('FN;CHARSET=UTF-8')) {
        List<String> splits = element.split(':');
        name = splits.last;
      }

      if (element.contains('TEL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          phone = splits.last;
        }
      }
      if (element.contains('EMAIL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          email = splits.last;
        }
      }
      if (element.contains('ORG')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          company = splits.last;
        }
      }
      if (element.contains('LABEL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          address = splits.last;
        }
      }
      if (element.contains('URL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          website = splits.last;
        }
      }
    });

    VCardModel model = VCardModel(
      fullname: name,
      phoneNo: phone,
      email: email,
      companyName: company,
      website: website,
      address: address,
      userId: '',
      additionalData: '',
      code: data,
    );

    return model;
  }
}
