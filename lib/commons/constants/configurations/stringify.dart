// ignore_for_file: constant_identifier_names

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
      : 'https://apps.apple.com/vn/app/qr-vn/id1595737575?l=vi';
}
