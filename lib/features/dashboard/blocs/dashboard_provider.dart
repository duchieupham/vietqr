import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bottom_nav_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/theme_dto_local.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';

class DashBoardProvider with ChangeNotifier {
  UserRepository get userRes => UserRepository.instance;

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

  int themeVer = 0;

  void updateFileLogo(String file) async {
    if (file.isNotEmpty) {
      fileLogo = await getImageFile(file);
    } else {
      String url = ThemeHelper.instance.getLogoTheme();
      fileLogo = await getImageFile(url);
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
}
