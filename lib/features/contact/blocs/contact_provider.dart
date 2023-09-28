import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];
  List<ContactDTO> listSync = [];
  List<ContactDTO> listSearch = [];

  List<List<ContactDTO>> listAll = [];
  List<List<ContactDTO>> listAllSearch = [];

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
  bool isSync = false;

  void updateSync(value) {
    isSync = value;
    notifyListeners();
  }

  void updateListSync(List<ContactDTO> value) {
    listSync = value;
    isSync = true;
    notifyListeners();
  }

  void updateIntro() {
    isIntro = AccountHelper.instance.getVCard();
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

  void updateCategory({ContactDataModel? value, bool isFirst = false}) {
    if (isFirst) {
      category = listCategories.first;
    } else {
      if (value == category) return;
      category = value;
    }

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

  void updateListAll(List<List<ContactDTO>> valueAll, List<ContactDTO> value) {
    if (valueAll.isNotEmpty) {
      listAll = valueAll;
      listAllSearch = valueAll;
    } else {
      List<List<ContactDTO>> _list = [];
      List<String> listString = [];

      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          if (value[i].nickname.isNotEmpty) {
            String keyName = value[i].nickname[0].toUpperCase();
            listString.add(keyName);
          } else {
            listString.add('');
          }
        }

        listString = listString.toSet().toList();

        for (int i = 0; i < listString.length; i++) {
          List<ContactDTO> listCompare = [];
          listCompare = value.where((element) {
            if (element.nickname.isNotEmpty) {
              return element.nickname[0].toUpperCase() == listString[i];
            } else {
              return element.nickname.toUpperCase() == listString[i];
            }
          }).toList();

          _list.add(listCompare);
        }
      }

      listAll = _list;
      listAllSearch = _list;
    }

    listContactDTO = value;
    notifyListeners();
  }

  void updateList(value) {
    listContactDTO = value;
    listSearch = value;
    notifyListeners();
  }

  void onChangeSuggest(String value) {}

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      isEnableBTSave = true;
    } else {
      isEnableBTSave = false;
    }
    notifyListeners();
  }

  void onSearch(String value) {
    if (value.isNotEmpty) {
      List<ContactDTO> data = listContactDTO
          .where((element) => element.nickname
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();

      listSearch = data;
    } else {
      listSearch = listContactDTO;
    }
    notifyListeners();
  }

  void onSearchAll(String value) {
    if (value.isNotEmpty) {
      List<ContactDTO> data = listContactDTO
          .where((element) => element.nickname
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();

      List<List<ContactDTO>> _list = [];
      List<String> listString = [];

      for (int i = 0; i < data.length; i++) {
        listString.add(data[i].nickname[0].toUpperCase());
      }
      listString = listString.toSet().toList();

      for (int i = 0; i < listString.length; i++) {
        List<ContactDTO> listCompare = [];
        listCompare = data
            .where(
                (element) => element.nickname[0].toUpperCase() == listString[i])
            .toList();

        _list.add(listCompare);
      }

      listAllSearch = _list;
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
      title: 'Cộng đồng',
      url: 'assets/images/gl-white.png',
      type: 8,
    ),
    ContactDataModel(
      title: 'Cá nhân',
      url: 'assets/images/ic-personal-white.png',
      type: 9,
    ),
    ContactDataModel(
      title: 'Danh bạ',
      url: 'assets/images/ic-contact-bank-blue.png',
      type: 4,
    ),
    ContactDataModel(
      title: 'Ngân hàng',
      url: 'assets/images/ic-tb-card-selected.png',
      type: 2,
    ),
    ContactDataModel(
      title: 'VietQR ID',
      url: 'assets/images/ic-contact-vietqr-id-blue.png',
      type: 1,
    ),
    ContactDataModel(
      title: 'Khác',
      url: 'assets/images/qr-contact-other-blue.png',
      type: 3,
    ),
    ContactDataModel(
      title: 'Gợi ý',
      url: 'assets/images/ic-contact-suggest-blue.png',
      type: 0,
    ),
  ];
}
