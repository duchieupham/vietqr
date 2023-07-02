import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
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

  TypeMoveEvent _moveEvent = TypeMoveEvent.NONE;

  get moveEvent => _moveEvent;

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
      assetsActive: 'assets/images/ic-card-selected.png',
      assetsUnActive: 'assets/images/ic-card-unselect.png',
      index: 0,
    ),
    const NavigationDTO(
      name: 'Trang chủ\n',
      assetsActive: 'assets/images/ic-dashboard.png',
      assetsUnActive: 'assets/images/ic-dashboard-unselect.png',
      index: 1,
    ),
    const NavigationDTO(
      name: '',
      assetsActive: 'assets/images/ic-qr-scanning.png',
      assetsUnActive: 'assets/images/ic-qr-scanning.png',
      index: -1,
    ),
    if (PlatformUtils.instance.isAndroidApp())
      const NavigationDTO(
        name: 'Mở tài khoản MB',
        assetsActive: 'assets/images/ic-linked.png',
        assetsUnActive: 'assets/images/ic-linked-unselect.png',
        index: 2,
      ),
    NavigationDTO(
      name: 'Cá nhân',
      assetsActive: 'assets/images/ic-user.png',
      assetsUnActive: 'assets/images/ic-user-unselect.png',
      index: (PlatformUtils.instance.isAndroidApp()) ? 3 : 2,
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
