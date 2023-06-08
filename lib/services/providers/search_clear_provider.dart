import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/check_type.dart';
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

  BusinessMemberDTO get dto => _dto;

  void updateDTO(value) {
    _dto = value;
    notifyListeners();
  }

  void updateExisted(value) {
    _typeMember = value;
    notifyListeners();
  }
}
