import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  final streamController = StreamController<List<File>>.broadcast();
  late Stream<List<File>> broadcastStream;

  File avatar = File('');

  void setImage(File? file) {
    if (file == null) return;
    avatar = file;
    notifyListeners();
  }

  Future<void> loadImage() async {
    List<File> listFile = [];
    for (int i = 0; i < themes.length; i++) {
      File file = await getImageFile(themes[i].file);
      listFile.add(file);
    }

    streamController.sink.add(listFile);
  }

  @override
  void dispose() {
    if (streamController.hasListener) {
      streamController.close();
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
    if (!isRenderUI) isRenderUI = true;
    broadcastStream = streamController.stream;
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
    List<ThemeDTO> listLocal = await userRes.getThemes();

    if (themes.isEmpty) {
      themes = listLocal;
      if (themes.isEmpty) {
        themes = value;
      }
      themes.sort((a, b) => a.type.compareTo(b.type));
      notifyListeners();
      return;
    }

    if ((themeKey != themeVer || listLocal.isEmpty)) {
      for (int i = 0; i < value.length; i++) {
        await userRes.updateThemes(value[i]);
        print('hehehheeeeeee $i');
      }
      themes = value;
      themes.sort((a, b) => a.type.compareTo(b.type));
    }
    notifyListeners();
  }

  void initThemeDTO() async {
    if ((await userRes.getThemeDTO()) == null) return;
    themeDTO = (await userRes.getThemeDTO())!;
    file = await getImageFile(themeDTO.file);
    notifyListeners();
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
    notifyListeners();
  }
}
