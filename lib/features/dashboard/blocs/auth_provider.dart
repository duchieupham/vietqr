import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:flutter/material.dart';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';

class AuthProvider with ChangeNotifier {
  UserRepository get userRes => UserRepository.instance;

  BuildContext? context;

  String get userId => userRes.userId;

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

  NfcTag? tag;

  SettingAccountDTO settingDTO = SettingAccountDTO();
  ThemeDTO themeDTO = ThemeDTO();
  List<ThemeDTO> themes = [];

  File file = File('');
  File fileLogo = File('');
  File fileThemeLogin = File('');

  bool isEventTheme = false;

  int themeVer = 0;

  final themesController = StreamController<List<File>>.broadcast();
  late Stream<List<File>> themesStream;

  File avatarUser = File('');

  void setImage(File? file) {
    if (file == null) return;
    avatarUser = file;
    notifyListeners();
  }

  Future<void> loadThemes() async {
    List<File> listFile = [];

    for (var element in themes) {
      File file = await getImageFile(element.file);
      listFile.add(file);
    }
    themesController.add(listFile);
  }

  @override
  void dispose() {
    if (themesController.hasListener) {
      themesController.close();
    }
    super.dispose();
  }

  void setContext(BuildContext ctx) async {
    if (context != null) {
      return;
    }
    context = ctx;
    PackageInfo data = await PackageInfo.fromPlatform();
    packageInfo = data;
    versionApp = packageInfo.version;
    initThemeDTO();
    themesStream = themesController.stream;
    themes = userRes.themes;
    updateThemes(themes);
    notifyListeners();
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

  void updateThemeVersion(value) {
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

  void updateThemes(List<ThemeDTO> value) async {
    themes = value;
    themes.sort((a, b) => a.type.compareTo(b.type));
    loadThemes();
    notifyListeners();
  }

  void initThemeDTO() async {
    ThemeDTO? theme = await userRes.getThemeDTO();
    if (theme == null) return;
    themeDTO = theme;
    file = await getImageFile(themeDTO.file);
    notifyListeners();
  }

  void updateSettingDTO(value) async {
    if (value != null) {
      settingDTO = value;
      ThemeDTO? _local = await userRes.getThemeDTO();

      if (_local == null || settingDTO.themeType != _local.type) {
        await onSaveThemToLocal();
      } else if (settingDTO.themeType == _local.type) {
        file = await getImageFile(themeDTO.file);
      }
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
      themeDTO.setFile(localPath);
      themeDTO.setType(settingDTO.themeType);

      userRes.updateThemeDTO(themeDTO);
      file = await getImageFile(themeDTO.file);
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
            textColor: AppColor.textBlack,
            fontSize: 15,
          );
        }
      } else if (packageVer < appInfoDTO.iosVer) {
        isUpdateVersion = true;
        if (appInfoDTO.isCheckApp) {
          versionApp = appInfoDTO.iosVersion.split('+').first;
          isShowToastUpdate = 1;
        }
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
            textColor: AppColor.textBlack,
            fontSize: 15,
          );
        }
      } else if (packageVer < appInfoDTO.adrVer) {
        isUpdateVersion = true;
        if (appInfoDTO.isCheckApp) {
          versionApp = appInfoDTO.androidVersion.split('+').first;
          isShowToastUpdate = 1;
        }
      }
    }
    notifyListeners();
  }

  void onClose() {
    isUpdateVersion = false;
    notifyListeners();
  }

  void reset() {
    introduceDTO = null;
    isUpdateVersion = false;
    _showActionShare = false;
    versionApp = '';
    isShowToastUpdate = -1;
    avatarUser = File('');
    notifyListeners();
  }
}
