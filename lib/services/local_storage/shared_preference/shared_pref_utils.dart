import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart'
    as Constants;
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';

import '../../../features/login/login_screen.dart';
import 'secure_storage_service.dart';
import 'shared_pref_local.dart';

class SharePrefUtils {
  static String tokenInfo = '';

  String get userId => getProfile().userId;

  /// Access Token
  static Future<String> getTokenInfo() async {
    if (tokenInfo.isNotEmpty) {
      return tokenInfo;
    }
    final secureStorageService = SecureStorageService<String>(
      Constants.SharedPreferenceKey.TokenInfo.sharedValue,
    );

    final _tokenInfo = await secureStorageService.getStorage();
    tokenInfo = _tokenInfo ?? '';
    print('Token - $tokenInfo');
    return tokenInfo;
  }

  static Future<void> setTokenInfo(String value) async {
    final secureStorageService = SecureStorageService<String>(
      Constants.SharedPreferenceKey.TokenInfo.sharedValue,
    );
    await secureStorageService.set(data: value);
    tokenInfo = value;
  }

  static Future<void> clearTokenInfoFromSecureStorage() async {
    final secureStorageService = SecureStorageService<String>(
      Constants.SharedPreferenceKey.TokenInfo.sharedValue,
    );
    await secureStorageService.remove();
    tokenInfo = '';
  }

  /// Token no Auth
  static Future<void> saveTokenFree(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.TokenFree.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getTokenFree() {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.TokenFree.sharedValue);

    return sharedPreferenceService.get() ?? '';
  }

  /// Profile
  static Future<void> saveProfileToCache(UserProfile profile) async {
    final sharedPreferenceService = SharedPrefLocal<UserProfile>(
        Constants.SharedPreferenceKey.Profile.sharedValue);
    await sharedPreferenceService.set(data: profile);
  }

  static UserProfile getProfile() {
    final sharedPreferenceService = SharedPrefLocal<UserProfile>(
        Constants.SharedPreferenceKey.Profile.sharedValue);
    return sharedPreferenceService.get(
            fromJson: (json) => UserProfile.fromJson(json)) ??
        UserProfile();
  }

  /// Token FCM
  static Future<void> saveTokenFCM(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.TokenFCM.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getTokenFCM() {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.TokenFCM.sharedValue);

    return sharedPreferenceService.get() ?? '';
  }

  ///Bank token
  static Future<void> saveBankToken(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.BankToken.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getBankToken() {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.BankToken.sharedValue);

    return sharedPreferenceService.get() ?? '';
  }

  /// scroll card
  static Future<void> saveScrollCard(bool value) async {
    final sharedPreferenceService = SharedPrefLocal<bool>(
        Constants.SharedPreferenceKey.ScrollCard.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static bool getScrollCard() {
    final sharedPreferenceService = SharedPrefLocal<bool>(
        Constants.SharedPreferenceKey.ScrollCard.sharedValue);

    return sharedPreferenceService.get() ?? false;
  }

  ///Wallet Info
  static Future<void> saveWalletInfo(IntroduceDTO value) async {
    final sharedPreferenceService = SharedPrefLocal<IntroduceDTO>(
        Constants.SharedPreferenceKey.WalletInfo.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static IntroduceDTO getWalletInfo() {
    final sharedPreferenceService = SharedPrefLocal<IntroduceDTO>(
        Constants.SharedPreferenceKey.WalletInfo.sharedValue);

    return sharedPreferenceService.get(
            fromJson: (json) => IntroduceDTO.fromJson(json)) ??
        IntroduceDTO();
  }

  /// Wallet ID
  static Future<void> saveWalletID(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.WalletID.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getWalletID() {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.WalletID.sharedValue);
    return sharedPreferenceService.get() ?? '';
  }

  ///List Login Account
  static Future<void> saveLoginAccountList(List<InfoUserDTO> list) async {
    final sharedPreferenceService = SharedPrefLocal(
        Constants.SharedPreferenceKey.LoginAccountList.sharedValue);
    await sharedPreferenceService.set(data: list);
  }

  static Future<List<InfoUserDTO>?> getLoginAccountList() async {
    final sharedPreferenceService = SharedPrefLocal<InfoUserDTO>(
      Constants.SharedPreferenceKey.LoginAccountList.sharedValue,
    );

    return sharedPreferenceService.getList(
      fromJson: (json) => InfoUserDTO.fromJson(json),
    );
  }

  static Future<void> setLoginAccount(InfoUserDTO dto) async {
    final sharedPreferenceService = SharedPrefLocal<InfoUserDTO>(
        Constants.SharedPreferenceKey.LoginAccount.sharedValue);
    await sharedPreferenceService.set(data: dto);
  }

  static InfoUserDTO getLoginAccount() {
    final sharedPreferenceService = SharedPrefLocal<InfoUserDTO>(
      Constants.SharedPreferenceKey.LoginAccount.sharedValue,
    );

    return sharedPreferenceService.get(
            fromJson: (json) => InfoUserDTO.fromJson(json)) ??
        InfoUserDTO();
  }

  /// Account Setting
  static Future<void> saveAccountSetting(SettingAccountDTO value) async {
    final sharedPreferenceService = SharedPrefLocal<SettingAccountDTO>(
        Constants.SharedPreferenceKey.AccountSetting.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static SettingAccountDTO getAccountSetting() {
    final sharedPreferenceService = SharedPrefLocal<SettingAccountDTO>(
      Constants.SharedPreferenceKey.AccountSetting.sharedValue,
    );

    return sharedPreferenceService.get(
            fromJson: (json) => SettingAccountDTO.fromJson(json)) ??
        SettingAccountDTO();
  }

  /// Show Qr Intro
  static Future<void> saveQrIntro(bool value) async {
    final sharedPreferenceService = SharedPrefLocal<bool>(
        Constants.SharedPreferenceKey.QrIntro.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static bool getQrIntro() {
    final sharedPreferenceService = SharedPrefLocal<bool>(
      Constants.SharedPreferenceKey.QrIntro.sharedValue,
    );

    return sharedPreferenceService.get() ?? false;
  }

  ///Biến check reset List Bank Type
  static Future<void> saveBankType(bool value) async {
    final sharedPreferenceService = SharedPrefLocal<bool>(
        Constants.SharedPreferenceKey.BankType.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static bool getBankType() {
    final sharedPreferenceService = SharedPrefLocal<bool>(
      Constants.SharedPreferenceKey.BankType.sharedValue,
    );

    return sharedPreferenceService.get() ?? false;
  }

  ///Phone number
  static Future<void> savePhone(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.PhoneNumber.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getPhone() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.PhoneNumber.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  ///Theme Version
  static Future<void> saveThemeVersion(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.ThemeVersion.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getThemeVersion() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.ThemeVersion.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  ///Logo Version
  static Future<void> saveLogoVersion(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.LogoVersion.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getLogoVersion() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.LogoVersion.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  ///Logo App
  static Future<void> saveLogoApp(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.LogoApp.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getLogoApp() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.LogoApp.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  ///Banner App
  static Future<void> saveBannerApp(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
        Constants.SharedPreferenceKey.BannerApp.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static String getBannerApp() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.BannerApp.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  ///Banner App
  static Future<void> saveBannerEvent(bool value) async {
    final sharedPreferenceService = SharedPrefLocal<bool>(
        Constants.SharedPreferenceKey.BannerEvent.sharedValue);
    await sharedPreferenceService.set(data: value);
  }

  static bool getBannerEvent() {
    final sharedPreferenceService = SharedPrefLocal<bool>(
      Constants.SharedPreferenceKey.BannerEvent.sharedValue,
    );

    return sharedPreferenceService.get() ?? false;
  }

  ///List Bank
  static Future<void> saveBanks(List<BankTypeDTO> list) async {
    final sharedPreferenceService =
        SharedPrefLocal(Constants.SharedPreferenceKey.Banks.sharedValue);
    await sharedPreferenceService.set(data: list);
  }

  static Future<List<BankTypeDTO>?> getBanks() async {
    final sharedPreferenceService = SharedPrefLocal<BankTypeDTO>(
      Constants.SharedPreferenceKey.Banks.sharedValue,
    );

    return sharedPreferenceService.getList(
      fromJson: (json) => BankTypeDTO.fromJson(json),
    );
  }

  ///List Theme
  static Future<void> saveThemes(List<ThemeDTO> list) async {
    final sharedPreferenceService =
        SharedPrefLocal(Constants.SharedPreferenceKey.Themes.sharedValue);
    await sharedPreferenceService.set(data: list);
  }

  static Future<List<ThemeDTO>?> getThemes() async {
    final sharedPreferenceService = SharedPrefLocal<ThemeDTO>(
      Constants.SharedPreferenceKey.Themes.sharedValue,
    );

    return sharedPreferenceService.getList(
      fromJson: (json) => ThemeDTO.fromJson(json),
    );
  }

  static Future<bool> removeThemes() async {
    final sharedPreferenceService = SharedPrefLocal<ThemeDTO>(
      Constants.SharedPreferenceKey.Themes.sharedValue,
    );

    return await sharedPreferenceService.remove();
  }

  /// Theme Event
  static Future<void> saveSingleTheme(ThemeDTO value) async {
    final sharedPreferenceService = SharedPrefLocal<ThemeDTO>(
      Constants.SharedPreferenceKey.SingleTheme.sharedValue,
    );
    await sharedPreferenceService.set(data: value);
  }

  static Future<ThemeDTO?> getSingleTheme() async {
    final sharedPreferenceService = SharedPrefLocal<ThemeDTO>(
      Constants.SharedPreferenceKey.SingleTheme.sharedValue,
    );

    return sharedPreferenceService.get(
        fromJson: (json) => ThemeDTO.fromJson(json));
  }

  static Future<bool> removeSingleTheme() async {
    final sharedPreferenceService = SharedPrefLocal<ThemeDTO>(
      Constants.SharedPreferenceKey.SingleTheme.sharedValue,
    );

    return await sharedPreferenceService.remove();
  }

  /// Theme Event
  static Future<void> saveVersionApp(String value) async {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.UpdateApp.sharedValue,
    );
    await sharedPreferenceService.set(data: value);
  }

  static String getVersionApp() {
    final sharedPreferenceService = SharedPrefLocal<String>(
      Constants.SharedPreferenceKey.UpdateApp.sharedValue,
    );

    return sharedPreferenceService.get() ?? '';
  }

  static Future<void> resetServices() async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<AuthProvider>(context, listen: false).reset();
    await saveProfileToCache(UserProfile());
    await setTokenInfo('');
    AppDataHelper.instance.clearListQRDetailBank();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Login(),
    ));
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil(Routes.LOGIN, (route) => route.isFirst);
  }
}
