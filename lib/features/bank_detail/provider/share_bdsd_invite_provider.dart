import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/member_search_dto.dart';

class ShareBDSDInviteProvider with ChangeNotifier {
  List<BankAccountDTO> _bankAccounts = [];

  List<BankAccountDTO> get bankAccounts => _bankAccounts;

  List<MemberSearchDto> _member = [];

  List<MemberSearchDto> get member => _member;

  List<String> bankIDs = [];
  List<String> userIDS = [];

  String _nameGroup = '';
  String _codeRandom = '';
  String get nameGroup => _nameGroup;
  String get codeRandom => _codeRandom;

  bool validateFormIV = false;

  void updateNamGroup(String value) {
    _nameGroup = value;
    validateForm();
  }

  void updateRandomCode(String value) {
    _codeRandom = value;
    validateForm();
  }

  void addListBankAccount(BankAccountDTO value) {
    _bankAccounts.add(value);
    bankIDs.add(value.id);
    validateForm();
  }

  void removeByBankID(String bankID) {
    _bankAccounts.removeWhere((bankDto) => bankDto.id == bankID);
    bankIDs.removeWhere((id) => id == bankID);
    validateForm();
  }

  void addListMember(MemberSearchDto value) {
    _member.add(value);
    userIDS.add(value.id ?? '');
    validateForm();
  }

  void removeByUserId(String userId) {
    _member.removeWhere((user) => user.id == userId);
    userIDS.removeWhere((id) => id == userId);
    validateForm();
  }

  validateForm() {
    if (_nameGroup.isNotEmpty &&
        _codeRandom.isNotEmpty &&
        _bankAccounts.isNotEmpty &&
        _member.isNotEmpty) {
      validateFormIV = true;
      notifyListeners();
    } else {
      validateFormIV = false;
      notifyListeners();
    }
  }
}
