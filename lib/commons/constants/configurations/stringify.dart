// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:vierqr/commons/utils/platform_utils.dart';

class Stringify {
  //ROLE CARD MEMBER
  static const int CARD_TYPE_BUSINESS = 1;
  static const int CARD_TYPE_PERSONAL = 0;

  //NOTIFICATION TYPE
  static const String NOTIFICATION_TYPE_TRANSACTION = 'TRANSACTION';
  static const String NOTIFICATION_TYPE_MEMBER_ADD = 'MEMBER_ADD';

  //RESPONSE MESSAGE STATUS
  static const String RESPONSE_STATUS_SUCCESS = 'SUCCESS';
  static const String RESPONSE_STATUS_FAILED = 'FAILED';
  static const String RESPONSE_STATUS_CHECK = 'CHECK';

  //animation
  static const SUCCESS_ANI_INITIAL_STATE = 'initial';
  static const SUCCESS_ANI_STATE_MACHINE = 'state';
  static const SUCCESS_ANI_ACTION_DO_INIT = 'doInit';
  static const SUCCESS_ANI_ACTION_DO_END = 'doEnd';

  //notification FCM type
  static const String NOTI_TYPE_LOGIN = "N02";
  static const String NOTI_TYPE_TRANSACTION = "N01";
  static const String NOTI_TYPE_NEW_MEMBER = "N03";
  static const String NOTI_TYPE_NEW_TRANSACTION = "N04";
  static const String NOTI_TYPE_UPDATE_TRANSACTION = "N05";
  static const String NOTI_TYPE_TOPUP = "N10";
  static const String NOTI_TYPE_MOBILE_RECHARGE = "N11";

  //
  static final String urlStore = PlatformUtils.instance.isAndroidApp()
      ? 'https://play.google.com/store/apps/details?id=com.vietqr.product&hl=en_US&pli=1'
      : 'https://apps.apple.com/vn/app/vietqr-vn/id6447118484?l=vi';
}

enum PictureType {
  PNG,
  JPG,
}

extension PictureTypeExtension on PictureType {
  String get pictureValue {
    switch (this) {
      case PictureType.PNG:
        return '.png';
      case PictureType.JPG:
        return '.jpg';
    }
  }
}

enum SharedPreferenceKey {
  TokenInfo,
  TokenFree,
  TokenFCM,
  Profile,
  ScrollCard,
  BankToken,
  WalletInfo,
  LoginAccount,
  AccountSetting,
  WalletID,
  QrIntro,
  BankType,
  PhoneNumber,
  ThemeVersion,
  LogoVersion,
  LogoApp,
  BannerApp,
  BannerEvent,
  Banks,
  Themes,
  SingleTheme,
  UpdateApp,
}

extension SharedPreferenceKeyExtension on SharedPreferenceKey {
  String get sharedValue {
    switch (this) {
      case SharedPreferenceKey.TokenInfo:
        return 'TOKEN';
      case SharedPreferenceKey.TokenFree:
        return 'TOKEN_FREE';
      case SharedPreferenceKey.TokenFCM:
        return 'FCM_TOKEN';
      case SharedPreferenceKey.Profile:
        return 'ACCOUNT_INFORMATION';
      case SharedPreferenceKey.ScrollCard:
        return 'SCROLL_CARD';
      case SharedPreferenceKey.BankToken:
        return 'BANK_TOKEN';
      case SharedPreferenceKey.WalletInfo:
        return 'WALLET_INFO';
      case SharedPreferenceKey.LoginAccount:
        return 'LOGIN_ACCOUNT';
      case SharedPreferenceKey.AccountSetting:
        return 'ACCOUNT_SETTING';
      case SharedPreferenceKey.WalletID:
        return 'WALLET_ID';
      case SharedPreferenceKey.QrIntro:
        return 'QR_INTRO';
      case SharedPreferenceKey.BankType:
        return 'BANK_TYPE';
      case SharedPreferenceKey.PhoneNumber:
        return 'PHONE_NUMBER';
      case SharedPreferenceKey.ThemeVersion:
        return 'THEME_VERSION';
      case SharedPreferenceKey.LogoVersion:
        return 'LOGO_VERSION';
      case SharedPreferenceKey.LogoApp:
        return 'LOGO_APP';
      case SharedPreferenceKey.BannerApp:
        return 'BANNER_APP';
      case SharedPreferenceKey.BannerEvent:
        return 'BANNER_EVENT';
      case SharedPreferenceKey.Banks:
        return 'BANKS';
      case SharedPreferenceKey.Themes:
        return 'THEMES';
      case SharedPreferenceKey.SingleTheme:
        return 'SINGLE_THEME';
      case SharedPreferenceKey.UpdateApp:
        return 'UPDATE_APP_V2';
    }
  }
}
