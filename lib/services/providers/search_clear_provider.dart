import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/business_member_dto.dart';

class SearchClearProvider extends ValueNotifier {
  SearchClearProvider(super.value);

  void updateClearSearch(bool check) {
    value = check;
  }
}

class SearchProvider with ChangeNotifier {
  TypeAddMember _typeMember = TypeAddMember.MORE;

  TypeAddMember get typeMember => _typeMember;

  BusinessMemberDTO _dto = BusinessMemberDTO(
    userId: '',
    status: '',
    existed: 0,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  final msgController = TextEditingController();

  BusinessMemberDTO get dto => _dto;

  bool isIcon = false;

  void updateIcon(value) {
    isIcon = value;
    notifyListeners();
  }

  void updateDTO(value) {
    _dto = value;
    notifyListeners();
  }

  void updateExisted(value) {
    _typeMember = value;
    notifyListeners();
  }

  void updateMsg(value) {
    msgController.value = msgController.value.copyWith(text: value.toString());
    notifyListeners();
  }

  void clearMsgController() {
    msgController.clear();
    notifyListeners();
  }

  void reset() {
    msgController.clear();
    isIcon = false;
    notifyListeners();
  }
}
