import 'package:package_info_plus/package_info_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AuthProvider with ChangeNotifier {
  String _themeSystem = ThemeHelper.instance.getTheme();

  get themeSystem => _themeSystem;

  //type = 0 => stack
  //type = 1 => slide
  int _type = BankArrangementHelper.instance.getBankArr();

  int get typeBankArr => _type;

  bool hasConnection = false;

  bool isFirst = false;

  PackageInfo? packageInfo;

  String get userId => UserInformationHelper.instance.getUserId();

  IntroduceDTO? introduceDTO;

  bool isUpdateVersion = false;

  void updateIntroduceDTO(value) {
    introduceDTO = value;
    notifyListeners();
  }

  void getAppInfo() async {
    if (packageInfo != null) {
      return;
    }
    PackageInfo data = await PackageInfo.fromPlatform();
    packageInfo = data;
    notifyListeners();
  }

  void updateHasConnection(value) {
    hasConnection = value;
    notifyListeners();
  }

  void updateFirst(value) {
    isFirst = value;
    notifyListeners();
  }

  Future<void> updateTheme(String mode) async {
    await ThemeHelper.instance.updateTheme(mode);
    _themeSystem = ThemeHelper.instance.getTheme();
    notifyListeners();
  }

  int getThemeIndex() {
    int index = 0;
    if (ThemeHelper.instance.getTheme() == AppColor.THEME_LIGHT) {
      index = 0;
    } else if (ThemeHelper.instance.getTheme() == AppColor.THEME_DARK) {
      index = 1;
    } else if (ThemeHelper.instance.getTheme() == AppColor.THEME_SYSTEM) {
      index = 2;
    }
    return index;
  }

  //update theme by index
  Future<void> updateThemeByIndex(int index) async {
    String mode = '';
    if (index == 0) {
      mode = AppColor.THEME_LIGHT;
    } else if (index == 1) {
      mode = AppColor.THEME_DARK;
    } else {
      mode = AppColor.THEME_SYSTEM;
    }
    await ThemeHelper.instance.updateTheme(mode);
    _themeSystem = ThemeHelper.instance.getTheme();
    notifyListeners();
  }

  Future<void> updateBankArr(int value) async {
    await BankArrangementHelper.instance.updateBankArr(value);
    _type = BankArrangementHelper.instance.getBankArr();
    // eventBus.fire(ChangeThemeEvent());
    notifyListeners();
  }

  void onClose() {
    isUpdateVersion = false;
    notifyListeners();
  }
}
