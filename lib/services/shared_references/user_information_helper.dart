import 'dart:convert';

import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';

class UserInformationHelper {
  const UserInformationHelper._privateConsrtructor();

  static const UserInformationHelper _instance =
      UserInformationHelper._privateConsrtructor();
  static UserInformationHelper get instance => _instance;

  Future<void> initialUserInformationHelper() async {
    const AccountInformationDTO accountInformationDTO = AccountInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      address: '',
      email: '',
      imgId: '',
    );
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('PHONE_NO', '');
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', accountInformationDTO.toSPJson().toString());
  }

  Future<void> setUserId(String userId) async {
    await sharedPrefs.setString('USER_ID', userId);
  }

  Future<void> setPhoneNo(String phoneNo) async {
    await sharedPrefs.setString('PHONE_NO', phoneNo);
  }

  String getPhoneNo() {
    return sharedPrefs.getString('PHONE_NO')!;
  }

  Future<void> setWalletId(String phoneNo) async {
    await sharedPrefs.setString('WALLET_ID', phoneNo);
  }

  String getWalletId() {
    return sharedPrefs.getString('WALLET_ID')!;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toSPJson().toString());
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

  Future<void> setWalletInfo(String info) async {
    await sharedPrefs.setString('WALLET_INFO', info);
  }

  IntroduceDTO getWalletInfo() {
    return IntroduceDTO.fromJson(
        json.decode(sharedPrefs.getString('WALLET_INFO')!));
  }

  String getUserId() {
    return sharedPrefs.getString('USER_ID')!;
  }

  String getUserFullname() {
    return ('${getAccountInformation().lastName} ${getAccountInformation().middleName} ${getAccountInformation().firstName}')
        .trim();
  }
}
