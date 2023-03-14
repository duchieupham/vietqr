import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/models/branch_text_controller_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';

class AddBusinessProvider with ChangeNotifier {
  bool _isInitial = false;
  List<BusinessMemberDTO> _memberList = [];
  List<BranchTextController> _branchTextControllers = [];
  File? _imageFile;
  File? _coverImageFile;

  bool get isInitial => _isInitial;
  List<BusinessMemberDTO> get memberList => _memberList;
  List<BranchTextController> get branchTextControllers =>
      _branchTextControllers;
  File? get imageFile => _imageFile;
  File? get coverImageFile => _coverImageFile;

  void setInitial(bool value) {
    _isInitial = value;
    notifyListeners();
  }

  void setImage(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void setCover(File? file) {
    _coverImageFile = file;
    notifyListeners();
  }

  void addMemberList(BusinessMemberDTO dto) {
    _memberList.add(dto);
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
    _imageFile = null;
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
