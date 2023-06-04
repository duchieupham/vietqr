import 'package:flutter/material.dart';
import 'package:vierqr/features/bank_card/views/bank_card_select_view.dart';
import 'package:vierqr/features/introduce/views/introduce_screen.dart';
import 'package:vierqr/features/personal/views/user_setting.dart';
import 'package:vierqr/models/bottom_nav_dto.dart';

class PageSelectProvider with ChangeNotifier {
  int _indexSelected = 0;
  int _notificationCount = 0;

  get indexSelected => _indexSelected;

  get notificationCount => _notificationCount;

  List<NavigationDTO> get listItem => _listBottomNavigation;

  final _listBottomNavigation = [
    const NavigationDTO(
      name: 'TK ngân hàng',
      assetsActive: 'assets/images/ic-card-selected.png',
      assetsUnActive: 'assets/images/ic-card-unselect.png',
      page: BankCardSelectView(
        key: PageStorageKey('QR_GENERATOR_PAGE'),
      ),
    ),
    const NavigationDTO(
      name: 'Mở tài khoản MB',
      assetsActive: 'assets/images/ic-linked.png',
      assetsUnActive: 'assets/images/ic-linked-unselect.png',
      page: IntroduceScreen(),
    ),
    const NavigationDTO(
      name: '',
      assetsActive: 'assets/images/ic-qr-scanning.png',
      assetsUnActive: 'assets/images/ic-qr-scanning.png',
      page: SizedBox(),
    ),
    const NavigationDTO(
        name: 'Trang chủ\n',
        assetsActive: 'assets/images/ic-dashboard.png',
        assetsUnActive: 'assets/images/ic-dashboard-unselect.png',
        page: SizedBox()),
    const NavigationDTO(
      name: 'Cá nhân',
      assetsActive: 'assets/images/ic-user.png',
      assetsUnActive: 'assets/images/ic-user-unselect.png',
      page: UserSetting(
        key: PageStorageKey('USER_SETTING_PAGE'),
      ),
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
}
