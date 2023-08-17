import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/network_providers_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class TopUpProvider extends ChangeNotifier {
  String _money = StringUtils.formatNumber(50000);
  String get money => _money;

  String _errorMoney = '';

  String get errorMoney => _errorMoney;

  String _phoneNo = UserInformationHelper.instance.getPhoneNo();
  String get phoneNo => _phoneNo;

  String _carrierTypeId = '';
  String get carrierTypeId => _carrierTypeId;

  String _nameUser = '';
  String get nameUser => _nameUser;

  List<NetworkProviders> _listNetworkProviders = [];
  List<NetworkProviders> get listNetworkProviders => _listNetworkProviders;

  NetworkProviders _networkProviders = const NetworkProviders();
  NetworkProviders get networkProviders => _networkProviders;

  int _rechargeType = 3;
  int get rechargeType => _rechargeType;

  int _paymentTypeMethod = 0;
  int get paymentTypeMethod => _paymentTypeMethod;
  init(List<NetworkProviders> list) {
    _listNetworkProviders = list;
    AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();

    for (var element in list) {
      if (accountInformationDTO.carrierTypeId == element.id) {
        _networkProviders = element;
      }
    }
    notifyListeners();
  }

  void updateRechargeType(int type) {
    _rechargeType = type;
  }

  void updateInfoUser(ContactDTO dto) {
    _phoneNo = dto.phoneNo;
    _nameUser = dto.nickname;

    if (dto.carrierTypeId.isEmpty) {
      _networkProviders = NetworkProviders(imgId: '');
    } else {
      _listNetworkProviders.forEach((element) {
        if (element.id == dto.carrierTypeId) {
          _networkProviders = element;
        }
      });
    }

    notifyListeners();
  }

  initNetworkProviders(NetworkProviders value) {
    _networkProviders = value;
  }

  void updateNetworkProviders(NetworkProviders value) {
    _networkProviders = value;
    notifyListeners();
  }

  void updateMoney(String value) {
    if (value.isEmpty) {
      _errorMoney = 'Số tiền không được để trống';
    } else {
      _errorMoney = '';
    }

    if (value.isEmpty) {
      _money = '0';
    } else {
      int data = int.parse(value.replaceAll(',', ''));
      if (data < 10000) {
        _errorMoney = 'Số tiền phải lớn hơn 10.000';
      }
      _money = StringUtils.formatNumber(data);
    }

    notifyListeners();
  }

  void updatePaymentMethod(int type) {
    _paymentTypeMethod = type;
    notifyListeners();
  }
}
