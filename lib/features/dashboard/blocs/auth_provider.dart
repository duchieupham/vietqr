import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:flutter/material.dart';

import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';

class AuthProvider with ChangeNotifier {
  UserRepository get userRes => UserRepository.instance;

  BuildContext? context;

  String get userId => userRes.userId;

  List<BankAccountDTO> listBank = [];

  String versionApp = '';

  // = 1: Có bản cập nhật
  // = 0: không có bản cập nhật
  int isShowToastUpdate = -1;

  PackageInfo packageInfo =
      PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');

  AppInfoDTO appInfoDTO = AppInfoDTO();

  IntroduceDTO? introduceDTO;

  bool isUpdateVersion = false;

  bool _showActionShare = false;

  bool get showActionShare => _showActionShare;

  bool isRenderUI = false;

  int _indexSelected = 0;

  int get pageSelected => _indexSelected;

  TypeMoveEvent _moveEvent = TypeMoveEvent.NONE;

  get moveEvent => _moveEvent;

  List<ContactDTO> listSync = [];
  bool isSync = false;

  SettingAccountDTO settingDTO = SettingAccountDTO();

  /// Theme
  final themesController = StreamController<List<File>>.broadcast();
  late Stream<List<File>> themesStream;
  ThemeDTO themeNotEvent = ThemeDTO();
  List<ThemeDTO> themes = [];

  /// Dùng khi không set Event cho
  File bannerApp = File('');

  /// Dùng cho màn chưa Login
  File logoApp = File('');

  bool isEventTheme = false;

  File avatarUser = File('');

  bool isError = false;

  void checkStateLogin(bool check) {
    isError = check;
    notifyListeners();
  }

  void setImage(File? file) {
    if (file == null) return;
    avatarUser = file;
    notifyListeners();
  }

  Future<void> loadThemes() async {
    List<File> listFile = [];

    for (var element in themes) {
      File file = await element.photoPath.getImageFile;
      listFile.add(file);
    }
    themesController.add(listFile);
  }

  void setContext(BuildContext ctx) async {
    if (context != null) {
      return;
    }
    context = ctx;
    PackageInfo data = await PackageInfo.fromPlatform();
    packageInfo = data;
    versionApp = packageInfo.version;
    _loadThemeSystem();
    themesStream = themesController.stream;
    themes = userRes.themes;
    updateThemes(themes);
    notifyListeners();
  }

  _loadThemeSystem() {
    updateEventTheme(null);
    updateLogoApp('');
    initThemeDTO();
  }

  void updateRenderUI({bool isLogout = false}) {
    if (isLogout) {
      isRenderUI = false;
      notifyListeners();
      return;
    }
    if (!isRenderUI) isRenderUI = true;
    notifyListeners();
  }

  void updateEventTheme(value) {
    if (value == null) {
      isEventTheme = SharePrefUtils.getBannerEvent();
    } else {
      isEventTheme = value;
    }
    notifyListeners();
  }

  void updateLogoApp(String file) async {
    if (file.isNotEmpty) {
      logoApp = await file.getImageFile;
    } else {
      String url = SharePrefUtils.getLogoApp();
      logoApp = await url.getImageFile;
    }
    notifyListeners();
  }

  void updateBannerApp(String file) async {
    if (file.isNotEmpty) {
      bannerApp = await file.getImageFile;
    } else {
      String url = SharePrefUtils.getBannerApp();
      bannerApp = await url.getImageFile;
    }
    notifyListeners();
  }

  void updateThemeDTO(value) async {
    if (value == null) return;
    themeNotEvent = value;
    bannerApp = await themeNotEvent.photoPath.getImageFile;
    await userRes.saveSingleTheme(themeNotEvent);
    notifyListeners();
  }

  void updateThemes(List<ThemeDTO> value) async {
    themes = value;
    themes.sort((a, b) => a.type.compareTo(b.type));
    loadThemes();
    notifyListeners();
  }

  void initThemeDTO() async {
    ThemeDTO? theme = await userRes.getSingleTheme();
    if (theme == null) return;
    themeNotEvent = theme;
    bannerApp = await themeNotEvent.photoPath.getImageFile;
    notifyListeners();
  }

  void updateSettingDTO(SettingAccountDTO value) async {
    settingDTO = value;
    ThemeDTO? _local = await userRes.getSingleTheme();

    if (_local == null || settingDTO.themeType != _local.type) {
      await onSaveThemToLocal();
    } else {
      bannerApp = await themeNotEvent.photoPath.getImageFile;
    }
    notifyListeners();
  }

  Future onSaveThemToLocal() async {
    String path = settingDTO.themeImgUrl.split('/').last;
    if (path.contains('.png')) {
      path.replaceAll('.png', '');
    }

    String localPath = await downloadAndSaveImage(settingDTO.themeImgUrl, path);
    if (localPath.isNotEmpty) {
      themeNotEvent.setFile(localPath);
      themeNotEvent.setType(settingDTO.themeType);

      userRes.saveSingleTheme(themeNotEvent);
      bannerApp = await themeNotEvent.photoPath.getImageFile;
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

  updateMoveEvent(value) {
    if (_moveEvent == value) {
      return;
    }
    _moveEvent = value;
    notifyListeners();
  }

  void updateIndex(int index, {bool isHome = false}) {
    if (isHome) {
      return;
    }
    _indexSelected = index;
    notifyListeners();
  }

  void updateKeepBright(bool keepValue) {
    settingDTO.keepScreenOn = keepValue;
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

  void updateAppInfoDTO(value) {
    appInfoDTO = value;
    updateVersion();
    updateIsCheckApp(appInfoDTO.isCheckApp);
    notifyListeners();
  }

  void updateIsCheckApp(value) {
    appInfoDTO.isCheckApp = value;
    notifyListeners();
  }

  void updateVersion() {
    int packageVer = int.parse(packageInfo.version.replaceAll('.', ''));
    int packageBuild = int.parse(packageInfo.buildNumber);
    if (PlatformUtils.instance.isIOsApp()) {
      if (packageVer == appInfoDTO.iosVer) {
        if (packageBuild < appInfoDTO.buildIos) {
          isUpdateVersion = true;
        }
        if (appInfoDTO.isCheckApp) {
          isShowToastUpdate = 0;
          appInfoDTO.isCheckApp = false;
          Fluttertoast.showToast(
            msg: 'Không có bản cập nhật nào',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColor.GREY_BG,
            textColor: AppColor.BLACK_TEXT,
            fontSize: 15,
          );
        }
      } else if (packageVer < appInfoDTO.iosVer) {
        isUpdateVersion = true;
        if (appInfoDTO.isCheckApp) {
          versionApp = appInfoDTO.iosVersion.split('+').first;
          isShowToastUpdate = 1;
        }
      } else {
        isUpdateVersion = false;
        appInfoDTO.isCheckApp = false;
        isShowToastUpdate = 0;
      }
    } else if (PlatformUtils.instance.isAndroidApp()) {
      if (packageVer == appInfoDTO.adrVer) {
        if (packageBuild < appInfoDTO.buildAdr) {
          isUpdateVersion = true;
        }
        if (appInfoDTO.isCheckApp) {
          isShowToastUpdate = 0;
          appInfoDTO.isCheckApp = false;
          Fluttertoast.showToast(
            msg: 'Không có bản cập nhật nào',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColor.GREY_BG,
            textColor: AppColor.BLACK_TEXT,
            fontSize: 15,
          );
        }
      } else if (packageVer < appInfoDTO.adrVer) {
        isUpdateVersion = true;
        if (appInfoDTO.isCheckApp) {
          versionApp = appInfoDTO.androidVersion.split('+').first;
          isShowToastUpdate = 1;
        }
      } else {
        isUpdateVersion = false;
        appInfoDTO.isCheckApp = false;
        isShowToastUpdate = 0;
      }
    }
    notifyListeners();
  }

  void onClose() {
    isUpdateVersion = false;
    notifyListeners();
  }

  void reset() {
    _indexSelected = 0;
    introduceDTO = null;
    isUpdateVersion = false;
    _showActionShare = false;
    versionApp = '';
    isShowToastUpdate = -1;
    avatarUser = File('');
    notifyListeners();
  }

  void updateBanks(List<BankAccountDTO> values) {
    listBank = [...values];
    notifyListeners();
  }

  @override
  void dispose() {
    if (themesController.hasListener) {
      themesController.close();
    }
    super.dispose();
  }
}
