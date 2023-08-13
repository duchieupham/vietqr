import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/models/branch_text_controller_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';

class AddBusinessProvider with ChangeNotifier {
  bool _isInitial = false;
  final List<BusinessMemberDTO> _memberList = [];

  List<BusinessMemberDTO> get memberList => _memberList;

  final List<BranchTextController> _branchTextControllers = [];

  File? _coverImageFile;

  bool get isInitial => _isInitial;

  List<BranchTextController> get branchTextControllers =>
      _branchTextControllers;

  File? get coverImageFile => _coverImageFile;

  void setInitial(bool value) {
    _isInitial = value;
    notifyListeners();
  }

  void setCover(File? file) {
    _coverImageFile = file;
    notifyListeners();
  }

  void addMemberList(List<BusinessMemberDTO> dto) {
    _memberList.addAll(dto);
    notifyListeners();
  }

  void addTextController(BranchTextController controller) {
    _branchTextControllers.add(controller);
    notifyListeners();
  }

  void removeMemberList(int index) {
    _memberList.removeAt(index);
    notifyListeners();
  }

  void removeTextController(int index) {
    _branchTextControllers.removeAt(index);
    notifyListeners();
  }

  void reset() {
    _isInitial = false;
    _memberList.clear();
    _branchTextControllers.clear();
    _coverImageFile = null;
  }

  bool isExistedMember(String userId) {
    bool result = false;
    if (_memberList.where((element) => element.userId == userId).isNotEmpty) {
      result = true;
    }
    return result;
  }
}
