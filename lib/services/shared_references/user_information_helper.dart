import 'dart:convert';

import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';

import '../../models/setting_account_sto.dart';

class UserHelper {
  const UserHelper._privateConstructor();

  static const UserHelper _instance = UserHelper._privateConstructor();

  static UserHelper get instance => _instance;

  static String user_key = 'USER_ID';
  static String phone_key = 'USER_ID';
  static String wallet_key = 'WALLET_ID';
  static String account_setting_key = 'ACCOUNT_SETTING';
  static String account_info_key = 'ACCOUNT_INFORMATION';
  static String bank_type_key = 'BANK_TYPE_KEY';

  Future<void> initialUserInformationHelper() async {
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('PHONE_NO', '');
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', AccountInformationDTO().toSPJson().toString());
  }

  reset() {
    initialUserInformationHelper();
  }

  Future<void> setUserId(String userId) async {
    if (!sharedPrefs.containsKey(user_key) ||
        sharedPrefs.getString('USER_ID') == null) {
      await sharedPrefs.setString('USER_ID', userId);
      return;
    }
    await sharedPrefs.setString('USER_ID', userId);
  }

  Future<void> setBankTypeKey(bool value) async {
    if (!sharedPrefs.containsKey(bank_type_key) ||
        sharedPrefs.getBool(bank_type_key) == null) {
      await sharedPrefs.setBool(bank_type_key, value);
      return;
    }
    await sharedPrefs.setBool(bank_type_key, value);
  }

  bool getBankTypeKey() {
    return sharedPrefs.getBool(bank_type_key) ?? false;
  }

  Future<void> setPhoneNo(String phoneNo) async {
    if (!sharedPrefs.containsKey('PHONE_NO') ||
        sharedPrefs.getString('PHONE_NO') == null) {
      await sharedPrefs.setString('PHONE_NO', phoneNo);
      return;
    }
    await sharedPrefs.setString('PHONE_NO', phoneNo);
  }

  String getPhoneNo() {
    return sharedPrefs.getString('PHONE_NO')!;
  }

  Future<void> setWalletId(String walletId) async {
    if (!sharedPrefs.containsKey('WALLET_ID') ||
        sharedPrefs.getString('WALLET_ID') == null) {
      await sharedPrefs.setString('WALLET_ID', walletId);
      return;
    }
    await sharedPrefs.setString('WALLET_ID', walletId);
  }

  String getWalletId() {
    return sharedPrefs.getString('WALLET_ID')!;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toSPJson().toString());
  }

  Future<void> setAccountSetting(SettingAccountDTO dto) async {
    await sharedPrefs.setString('ACCOUNT_SETTING', dto.toSPJson().toString());
  }

  Future<void> setImageId(String imgId) async {
    AccountInformationDTO dto = AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
    AccountInformationDTO newDto = AccountInformationDTO(
        address: dto.address,
        birthDate: dto.birthDate,
        email: dto.email,
        firstName: dto.firstName,
        gender: dto.gender,
        imgId: imgId,
        lastName: dto.lastName,
        middleName: dto.middleName,
        userId: dto.userId);
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', newDto.toSPJson().toString());
  }

  AccountInformationDTO getAccountInformation() {
    return AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
  }

  SettingAccountDTO getAccountSetting() {
    return SettingAccountDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_SETTING') ?? ''));
  }

  Future<void> setWalletInfo(String info) async {
    await sharedPrefs.setString('WALLET_INFO', info);
  }

  IntroduceDTO getWalletInfo() {
    return IntroduceDTO.fromJson(
        json.decode(sharedPrefs.getString('WALLET_INFO') ?? ''));
  }

  String getUserId() {
    return sharedPrefs.getString('USER_ID') ?? '';
  }

  String getUserFullName() {
    return ('${getAccountInformation().lastName} ${getAccountInformation().middleName} ${getAccountInformation().firstName}')
        .trim();
  }

  Future<void> setLoginAccount(List<String> list) async {
    await sharedPrefs.setStringList('LOGIN_ACCOUNT', list);
  }

  List<InfoUserDTO> getLoginAccount() {
    return ListLoginAccountDTO.fromJson(
            sharedPrefs.getStringList('LOGIN_ACCOUNT'))
        .list;
  }
}
