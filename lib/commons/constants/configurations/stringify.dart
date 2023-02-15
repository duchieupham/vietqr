// ignore_for_file: constant_identifier_names

class Stringify {
  //ROLE CARD MEMBER
  static const int ROLE_CARD_MEMBER_MANAGER = 2;
  static const int ROLE_CARD_MEMBER_ADMIN = 1;
  static const int ROLE_CARD_MEMBER_MEMBER = 0;

  //NOTIFICATION TYPE
  static const String NOTIFICATION_TYPE_TRANSACTION = 'TRANSACTION';
  static const String NOTIFICATION_TYPE_MEMBER_ADD = 'MEMBER_ADD';

  //RESPONSE MESSAGE STATUS
  static const String RESPONSE_STATUS_SUCCESS = 'SUCCESS';
  static const String RESPONSE_STATUS_FAILED = 'FAILED';

  //animation
  static const SUCCESS_ANI_INITIAL_STATE = 'initial';
  static const SUCCESS_ANI_STATE_MACHINE = 'state';
  static const SUCCESS_ANI_ACTION_DO_INIT = 'doInit';
  static const SUCCESS_ANI_ACTION_DO_END = 'doEnd';
}
