import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/bottom_nav_dto.dart';

class DashBoardProvider with ChangeNotifier {
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
      name: 'Doanh nghiệp',
      label: 'Doanh nghiệp',
      assetsActive: 'assets/images/ic-tb-business-selected.png',
      assetsUnActive: 'assets/images/ic-tb-business.png',
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
}
