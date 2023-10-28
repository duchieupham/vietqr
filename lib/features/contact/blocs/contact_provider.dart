import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/user_repository.dart';

class ContactProvider extends ChangeNotifier {
  UserRepository get userRes => UserRepository.instance;

  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];

  List<ContactDTO> listSearch = [];

  List<List<ContactDTO>> listAll = [];
  List<List<ContactDTO>> listAllSearch = [];

  List<VCardModel> listInsert = [];

  String colorType = '0';

  // Màu thẻ QR:
  // 0 = xanh default
  // 1 = xanh lá
  // 2 = tím
  // 3 = cam
  // 4 = hồng

  ContactDataModel? category;

  int offset = 0;

  String phoneNo = '';

  File? file;

  ContactDataModel model = ContactDataModel(
      title: 'Cá nhân', type: 0, url: 'assets/images/personal-relation.png');

  bool isIntro = false;

  void initData() {
    category = listCategories.first;
    isIntro = userRes.getIntroContact();
    notifyListeners();
  }

  void addDataInsert(value) {
    if (listInsert.length == 50) {
      updateListInsert();
    }
    listInsert.add(value);
    notifyListeners();
  }

  void updateListInsert() {
    listInsert.clear();
    notifyListeners();
  }

  void updateIntro(bool value) {
    userRes.updateIntroContact(value);
    isIntro = userRes.isIntroContact;
    notifyListeners();
  }

  void updateQRT(value) {
    if (model != value) {
      model = value;
    }
    notifyListeners();
  }

  void updateFile(value) {
    file = value;
    notifyListeners();
  }

  void updateOffset(value) {
    offset = value;
    notifyListeners();
  }

  void updateColorType(value) {
    colorType = value;
    notifyListeners();
  }

  void updateCategory({ContactDataModel? value}) {
    if (value == category) return;
    category = value;

    notifyListeners();
  }

  void updatePhoneNo(String value) {
    phoneNo = value;
    notifyListeners();
  }

  void updateTab(value) {
    tab = value;
    notifyListeners();
  }

  void updateListAll(List<List<ContactDTO>> value, List<ContactDTO> list) {
    listAll = value;
    listAllSearch = value;

    listContactDTO = list;
    notifyListeners();
  }

  void updateList(value) {
    listContactDTO = value;
    listSearch = value;
    notifyListeners();
  }

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      isEnableBTSave = true;
    } else {
      isEnableBTSave = false;
    }
    notifyListeners();
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

  void onSearchAll(String value) async {
    if (value.isNotEmpty) {
      List<ContactDTO> data = listContactDTO
          .where((element) => element.nickname
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();

      List<List<ContactDTO>> list = await _compareList(data);

      listAllSearch = list;
    } else {
      listAllSearch = listAll;
    }
    notifyListeners();
  }

  final List<String> listColor = [
    'assets/images/color-type-0.png',
    'assets/images/color-type-1.png',
    'assets/images/color-type-2.png',
    'assets/images/color-type-3.png',
    'assets/images/color-type-4.png',
  ];

  final List<ContactDataModel> listCategories = [
    ContactDataModel(
      title: 'VCard',
      url: 'assets/images/ic-contact-bank-blue.png',
      type: CategoryType.vcard.value,
    ),
    ContactDataModel(
      title: 'Cộng đồng',
      url: 'assets/images/gl-white.png',
      type: CategoryType.community.value,
    ),
    ContactDataModel(
      title: 'Cá nhân',
      url: 'assets/images/ic-personal-white.png',
      type: CategoryType.personal.value,
    ),
    ContactDataModel(
      title: 'Ngân hàng',
      url: 'assets/images/ic-tb-card-selected.png',
      type: CategoryType.bank.value,
    ),
    ContactDataModel(
      title: 'VietQR ID',
      url: 'assets/images/ic-contact-vietqr-id-blue.png',
      type: CategoryType.viet_id.value,
    ),
    ContactDataModel(
      title: 'Khác',
      url: 'assets/images/qr-contact-other-blue.png',
      type: CategoryType.other.value,
    ),
    ContactDataModel(
      title: 'Gợi ý',
      url: 'assets/images/ic-contact-suggest-blue.png',
      type: CategoryType.suggest.value,
    ),
  ];
}
