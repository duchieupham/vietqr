import 'package:flutter/material.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];
  List<ContactDTO> listSearch = [];

  final List<DataModel> listCategories = [
    DataModel(
      title: 'Tất cả',
      url: 'assets/images/ic-contact-bank-blue.png',
      type: 9,
    ),
    DataModel(
      title: 'Ngân hàng',
      url: 'assets/images/ic-tb-card-selected.png',
      type: 2,
    ),
    DataModel(
      title: 'VietQR ID',
      url: 'assets/images/ic-contact-vietqr-id-blue.png',
      type: 1,
    ),
    DataModel(
      title: 'Khác',
      url: 'assets/images/qr-contact-other-blue.png',
      type: 3,
    ),
    DataModel(
      title: 'Gợi ý',
      url: 'assets/images/ic-contact-suggest-blue.png',
      type: 0,
    ),
  ];

  DataModel? category;

  String phoneNo = '';

  void updateCategory({DataModel? value, bool isFirst = false}) {
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
}

class DataModel {
  final String title;
  final String url;
  final int type;

  DataModel({
    required this.title,
    required this.url,
    required this.type,
  });
}
