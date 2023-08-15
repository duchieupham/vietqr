import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class AuthProvider with ChangeNotifier {
  String _themeSystem = ThemeHelper.instance.getTheme();

  get themeSystem => _themeSystem;

  BuildContext? context;

  File? _imageFile;

  File? get imageFile => _imageFile;

  String versionApp = '';
  bool isCheckApp = false;
  int isShowToastUpdate = -1;

  //type = 0 => stack
  //type = 1 => slide
  int _type = BankArrangementHelper.instance.getBankArr();

  int get typeBankArr => _type;

  bool hasConnection = false;

  bool isFirst = false;

  PackageInfo? packageInfo;

  AppInfoDTO? appInfoDTO;

  String get userId => UserInformationHelper.instance.getUserId();

  IntroduceDTO? introduceDTO;

  bool isUpdateVersion = false;

  bool _showActionShare = false;

  bool get showActionShare => _showActionShare;

  List<BankAccountDTO> _banks = [];

  List<BankAccountDTO> get banks => _banks;

  List<BankAccountDTO> _searchBanks = [];

  List<BankAccountDTO> get searchBanks => _searchBanks;

  List<BusinessMemberDTO> _memberList = [];

  List<BusinessMemberDTO> get memberList => _memberList;

  void setContext(BuildContext ctx) async {
    if (context != null) {
      return;
    }
    context = ctx;
    PackageInfo data = await PackageInfo.fromPlatform();
    packageInfo = data;
    versionApp = packageInfo?.version ?? '';
    notifyListeners();
  }

  void setImage(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void updateAction(bool value) {
    _showActionShare = value;
    notifyListeners();
  }

  void updateIntroduceDTO(value) {
    introduceDTO = value;
    notifyListeners();
  }

  void updateAppInfoDTO(value, {bool isCheckApp = false}) {
    appInfoDTO = value;
    updateVersion(
      isCheckApp: isCheckApp,
    );
    updateIsCheckApp(false);
    notifyListeners();
  }

  void updateIsCheckApp(value) {
    isCheckApp = value;
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

  void updateVersion({bool isCheckApp = false}) {
    if (appInfoDTO != null && packageInfo != null) {
      int packageVer = int.parse(packageInfo!.version.replaceAll('.', ''));
      int packageBuild = int.parse(packageInfo!.buildNumber);
      if (PlatformUtils.instance.isIOsApp()) {
        if (packageVer == appInfoDTO!.iosVer) {
          if (packageBuild < appInfoDTO!.buildIos) {
            isUpdateVersion = true;
          }
          if (isCheckApp) {
            isShowToastUpdate = 0;
            Fluttertoast.showToast(
              msg: 'Không có bản cập nhật nào',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context!).cardColor,
              textColor: Theme.of(context!).hintColor,
              fontSize: 15,
            );
          }
        } else if (packageVer < appInfoDTO!.iosVer) {
          isUpdateVersion = true;
          if (isCheckApp) {
            versionApp = appInfoDTO!.iosVersion!.split('+').first;
            isShowToastUpdate = 1;
          }
        }
      } else if (PlatformUtils.instance.isAndroidApp()) {
        if (packageVer == appInfoDTO!.adrVer) {
          if (packageBuild < appInfoDTO!.buildAdr) {
            isUpdateVersion = true;
          }
          if (isCheckApp) {
            isShowToastUpdate = 0;
            Fluttertoast.showToast(
              msg: 'Không có bản cập nhật nào',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context!).cardColor,
              textColor: Theme.of(context!).hintColor,
              fontSize: 15,
            );
          }
        } else if (packageVer < appInfoDTO!.adrVer) {
          isUpdateVersion = true;
          if (isCheckApp) {
            versionApp = appInfoDTO!.androidVersion!.split('+').first;
            isShowToastUpdate = 1;
          }
        }
      }
      notifyListeners();
    }
  }

  void onClose() {
    isUpdateVersion = false;
    notifyListeners();
  }
}
