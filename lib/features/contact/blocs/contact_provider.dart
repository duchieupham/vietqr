import 'package:flutter/material.dart';
import 'package:vierqr/models/contact_dto.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];
  List<ContactDTO> listSearch = [];

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
