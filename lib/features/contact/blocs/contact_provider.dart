import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/features/contact/models/data_model.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];
  List<ContactDTO> listSearch = [];

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
      title: 'Tất cả',
      url: 'assets/images/ic-contact-bank-blue.png',
      type: 9,
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
