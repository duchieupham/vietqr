import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:flutter/material.dart';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bottom_nav_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/theme_dto_local.dart';

class AuthProvider with ChangeNotifier {
  String _themeSystem = ThemeHelper.instance.getTheme();

  UserRepository get userRes => UserRepository.instance;

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

  PackageInfo? packageInfo;

  AppInfoDTO? appInfoDTO;

  IntroduceDTO? introduceDTO;

  bool isUpdateVersion = false;

  bool _showActionShare = false;

  bool get showActionShare => _showActionShare;

  bool isRenderUI = false;

  int _indexSelected = 0;
  int _notificationCount = 0;

  get indexSelected => _indexSelected;

  get notificationCount => _notificationCount;

  List<NavigationDTO> get listItem => _listBottomNavigation;

  TypeMoveEvent _moveEvent = TypeMoveEvent.NONE;

  List<BankAccountDTO> listBanks = [];

  get moveEvent => _moveEvent;

  TypeInternet type = TypeInternet.NONE;
  bool isInternet = false;

  List<ContactDTO> listSync = [];
  bool isSync = false;

  NfcTag? tag;

  SettingAccountDTO settingDTO = SettingAccountDTO();
  ThemeDTOLocal themeDTO = ThemeDTOLocal();
  List<ThemeDTO> themes = [];

  File file = File('');
  File fileLogo = File('');
  File fileThemeLogin = File('');

  bool isEventTheme = false;

  int themeVer = 0;

  void setContext(BuildContext ctx) async {
    if (context != null) {
      return;
    }
    context = ctx;
    PackageInfo data = await PackageInfo.fromPlatform();
    packageInfo = data;
    versionApp = packageInfo?.version ?? '';
    initFileTheme();
    if (!isRenderUI) isRenderUI = true;
    notifyListeners();
  }

  void updateRenderUI() {
    if (isRenderUI) return;
    isRenderUI = true;
    notifyListeners();
  }

  void updateEventTheme(value) {
    if (value == null) {
      isEventTheme = ThemeHelper.instance.getEventTheme();
    } else {
      isEventTheme = value;
    }
    notifyListeners();
  }

  void updateFileLogo(String file) async {
    if (file.isNotEmpty) {
      fileLogo = await getImageFile(file);
    } else {
      String url = ThemeHelper.instance.getLogoTheme();
      fileLogo = await getImageFile(url);
    }
    notifyListeners();
  }

  void updateFileThemeLogin(String url) async {
    if (url.isNotEmpty) {
      fileThemeLogin = await getImageFile(url);
    } else {
      String _url = ThemeHelper.instance.getThemeLogin();
      fileThemeLogin = await getImageFile(_url);
    }
    notifyListeners();
  }

  void updateThemeVer(value) {
    themeVer = value;
    ThemeHelper.instance.updateThemeKey(themeVer);
    notifyListeners();
  }

  void updateThemeDTO(value) async {
    if (value == null) return;
    themeDTO = value;
    file = await getImageFile(themeDTO.file);
    await userRes.updateThemeDTO(themeDTO);
    notifyListeners();
  }

  void updateListTheme(List<ThemeDTO> value, {bool saveLocal = false}) async {
    int themeKey = ThemeHelper.instance.getThemeKey();
    List<ThemeDTO> listLocal = await userRes.getTheme();

    if (themes.isEmpty) {
      themes = listLocal;
      if (themes.isEmpty) {
        themes = value;
      }
      themes.sort((a, b) => a.type.compareTo(b.type));
      notifyListeners();
      return;
    }

    if (themeKey != themeVer || listLocal.isEmpty) {
      for (int i = 0; i < value.length; i++) {
        await userRes.updateTheme(value[i]);
      }
      themes = value;
    }

    themes.sort((a, b) => a.type.compareTo(b.type));
    notifyListeners();
  }

  void initFileTheme() async {
    if ((await userRes.getThemeDTO()) != null) {
      themeDTO = (await userRes.getThemeDTO())!;
      file = await getImageFile(themeDTO.file);
      notifyListeners();
    }
  }

  void updateSettingDTO(value) async {
    if (value != null) {
      settingDTO = value;

      if ((await userRes.getThemeDTO()) != null) {
        themeDTO = (await userRes.getThemeDTO())!;
        if (settingDTO.themeType == themeDTO.type) {
          file = await getImageFile(themeDTO.file);
        } else {
          String path = settingDTO.themeImgUrl.split('/').last;
          if (path.contains('.png')) {
            path.replaceAll('.png', '');
          }

          String localPath =
              await downloadAndSaveImage(settingDTO.themeImgUrl, path);

          themeDTO.setFile(localPath);
          themeDTO.setType(settingDTO.themeType);

          userRes.updateThemeDTO(themeDTO);
          file = await getImageFile(themeDTO.file);
        }
      } else {
        String path = settingDTO.themeImgUrl.split('/').last;
        if (path.contains('.png')) {
          path.replaceAll('.png', '');
        }

        String localPath =
            await downloadAndSaveImage(settingDTO.themeImgUrl, path);

        themeDTO.setFile(localPath);
        themeDTO.setType(settingDTO.themeType);

        userRes.updateThemeDTO(themeDTO);
        file = await getImageFile(themeDTO.file);
      }
    }

    notifyListeners();
  }

  void updateSync(value) {
    isSync = value;
    notifyListeners();
  }

  void updateListSync(List<ContactDTO> value) {
    listSync = value;
    notifyListeners();
  }

  void updateInternet(value, typeInternet) {
    type = typeInternet;
    isInternet = value;
    notifyListeners();
  }

  void updateListBanks(List<BankAccountDTO> value) {
    listBanks = value;
    notifyListeners();
  }

  updateMoveEvent(value) {
    if (_moveEvent == value) {
      return;
    }
    _moveEvent = value;
    notifyListeners();
  }

  final _listBottomNavigation = [
    const NavigationDTO(
      name: 'TK ngân hàng',
      label: 'Tài khoản',
      assetsActive: 'assets/images/ic-tb-card-selected.png',
      assetsUnActive: 'assets/images/ic-tb-card.png',
      index: 0,
    ),
    const NavigationDTO(
      name: 'Trang chủ\n',
      label: 'Trang chủ',
      assetsActive: 'assets/images/ic-tb-dashboard-selected.png',
      assetsUnActive: 'assets/images/ic-tb-dashboard.png',
      index: 1,
    ),
    const NavigationDTO(
      name: '',
      label: 'Quét QR',
      assetsActive: 'assets/images/ic-tb-qr.png',
      assetsUnActive: 'assets/images/ic-tb-qr.png',
      index: -1,
    ),
    const NavigationDTO(
      name: 'Ví QR',
      label: 'Ví QR',
      assetsActive: 'assets/images/ic-qr-wallet-blue.png',
      assetsUnActive: 'assets/images/ic-qr-wallet-grey.png',
      index: 2,
    ),
    const NavigationDTO(
      name: 'Cá nhân',
      label: 'Cá nhân',
      assetsActive: 'assets/images/ic-tb-personal-selected.png',
      assetsUnActive: 'assets/images/ic-tb-personal.png',
      index: 3,
    ),
  ];

  void updateIndex(int index, {bool isHome = false}) {
    if (isHome) {
      return;
    }
    _indexSelected = index;
    notifyListeners();
  }

  void updateNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }

  void updateKeepBright(bool keepValue) {
    settingDTO.keepScreenOn = keepValue;
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
    updateVersion(isCheckApp: isCheckApp);
    updateIsCheckApp(false);
    notifyListeners();
  }

  void updateIsCheckApp(value) {
    isCheckApp = value;
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

  void reset() {
    introduceDTO = null;
    _imageFile = null;
    isUpdateVersion = false;
    _showActionShare = false;
    versionApp = '';
    isCheckApp = false;
    isShowToastUpdate = -1;
    notifyListeners();
  }
}
