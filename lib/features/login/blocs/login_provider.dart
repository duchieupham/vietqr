import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class LoginProvider with ChangeNotifier {
  bool isEnableButton = false;
  bool isButtonLogin = false;
  String phone = '';
  String? errorPhone;

  InfoUserDTO? infoUserDTO;
  List<InfoUserDTO> listInfoUsers = [];

  AppInfoDTO appInfoDTO = AppInfoDTO();

  //0: trang login ban đầu
  // 1: trang login gần nhất
  //2 : quickLogin
  int isQuickLogin = 0;

  init() async {
    listInfoUsers = UserHelper.instance.getLoginAccount();
    if (listInfoUsers.isNotEmpty) {
      isQuickLogin = 1;
    }
    notifyListeners();
  }

  void updateAppInfo(value) {
    appInfoDTO = value;
    notifyListeners();
  }

  void updateListInfoUser() async {
    listInfoUsers = UserHelper.instance.getLoginAccount();
    notifyListeners();
  }

  Future updateInfoUser(value) async {
    infoUserDTO = value;
    notifyListeners();
  }

  void updateQuickLogin(value) {
    isQuickLogin = value;
    notifyListeners();
  }

  void updateIsEnableBT(value) {
    isEnableButton = value;
    notifyListeners();
  }

  void updateBTLogin(value) {
    isButtonLogin = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value.replaceAll(" ", "");

    if (phone.length == 9) {
      if (phone[0] != '0') {
        phone = '0$phone';
      }
    }
    errorPhone = StringUtils.instance.validatePhone(phone);
    if (errorPhone != null || value.isEmpty) {
      isEnableButton = false;
    } else {
      isEnableButton = true;
    }

    notifyListeners();
  }
}
