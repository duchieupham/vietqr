import 'package:flutter/material.dart';
import 'package:vierqr/features/bank_card/views/bank_card_select_view.dart';
import 'package:vierqr/features/personal/views/user_setting.dart';
import 'package:vierqr/models/bottom_nav_dto.dart';

class BottomNavigationProvider with ChangeNotifier {
  NavigationDTO? _selected;

  get selected => _selected;

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
      name: '',
      assetsActive: 'assets/images/ic-qr-scanning.png',
      assetsUnActive: 'assets/images/ic_brand_grey.png',
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

  BottomNavigationProvider() : super() {
    setItemActive(_listBottomNavigation.elementAt(0));
  }

  setItemActive(NavigationDTO value) {
    _selected = value;
    notifyListeners();
  }

  List<NavigationDTO> get listItem => _listBottomNavigation;
}
