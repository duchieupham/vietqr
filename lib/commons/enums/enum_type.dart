// ignore_for_file: constant_identifier_names

enum BlocStatus {
  LOADING_PAGE,
  NONE,
  LOADING,
  LOAD_MORE,
  LOADING_SHARE,
  UNLOADING,
  ERROR,
  AWAIT,
  SUCCESS,
  DELETED,
  INSERT,
  DONE,
  DELETED_ERROR,
}

enum TypeImage { SAVE, SHARE }

enum PageType { ACCOUNT, HOME, SCAN_QR, CARD_QR, STORE }

extension PageTypeExt on int {
  PageType get pageType {
    switch (this) {
      case 0:
        return PageType.ACCOUNT;
      case 1:
        return PageType.HOME;
      case 2:
        return PageType.SCAN_QR;
      case 3:
        return PageType.CARD_QR;
      case 4:
        return PageType.STORE;
      // case 1:
      //   return PageType.HOME;
      // case -1:
      //   return PageType.SCAN_QR;
      // case 2:
      //   return PageType.CARD_QR;
      // case 3:
      //   return PageType.STORE;
      default:
        return PageType.ACCOUNT;
    }
  }
}

extension PageTypeExt2 on PageType {
  int get pageIndex {
    switch (this) {
      case PageType.HOME:
        return 1;
      case PageType.SCAN_QR:
        return -1;
      case PageType.CARD_QR:
        return 2;
      case PageType.STORE:
        return 3;
      default:
        return 0;
    }
  }
}

enum ExitsType { ADD, LINKED }

enum StepType { first_screen, second_screen, three_screen }

enum TypeSelect {
  BANK,
  MEMBER,
}

enum CheckType { C01, C02, C03, C04, C06, C12 }

enum TypeOTP {
  SUCCESS,
  FAILED,
  TOO_MANY_REQUEST,
  ERROR,
  AWAIT,
  NONE,
}

enum TypeMoveEvent { LEFT_TO_RIGHT, RIGHT_TO_LEFT, NONE }

enum TypeAddMember { MORE, ADDED, AWAIT }

extension TypeMemberExt on TypeAddMember {
  int get existed {
    switch (this) {
      case TypeAddMember.MORE:
        return 0;
      case TypeAddMember.ADDED:
        return 1;
      case TypeAddMember.AWAIT:
      default:
        return 2;
    }
  }
}

enum TypeRole { ADMIN, USER, MANAGER, BRANCH_MANAGER }

extension TypeRoleExt on TypeRole {
  int get role {
    switch (this) {
      case TypeRole.ADMIN:
        return 5;
      case TypeRole.MANAGER:
        return 1;
      case TypeRole.BRANCH_MANAGER:
        return 3;
      case TypeRole.USER:
      default:
        return -1;
    }
  }
}

enum TypeQR {
  NONE,
  QR_ID,
  QR_CMT,
  QR_BANK,
  QR_BARCODE,
  OTHER,
  QR_LINK,
  QR_VCARD,
  QR_SALE,
  QR_MER_ECM,
  CERTIFICATE,
  LINK_ACTIVE_KEY,
  LOGIN_WEB,
  TOKEN_PLUGIN,
  NEGATIVE_TWO,
  NEGATIVE_ONE,
}

extension TypeQRExt on TypeQR {
  String get value {
    switch (this) {
      case TypeQR.NEGATIVE_TWO:
        return '-2';
      case TypeQR.NEGATIVE_ONE:
        return '-1';
      case TypeQR.QR_CMT:
      case TypeQR.QR_BANK:
      default:
        return '0';
    }
  }
}

enum TypeContact {
  VietQR_ID,
  Bank,
  Other,
  VCard,
  Login_Web,
  Sale,
  token_plugin,
  NONE,
  UPDATE,
  ERROR,
  NOT_FOUND,
}
// 1: VietQR ID
// 2: Bank
// 3: Khác
// 4: CMT
// 5: link
// 5: BarCode

extension TypeContactExt on int {
  TypeContact get type {
    switch (this) {
      case 1:
        return TypeContact.VietQR_ID;
      case 2:
        return TypeContact.Bank;
      case 3:
        return TypeContact.Other;
      case 4:
        return TypeContact.VCard;
      default:
        return TypeContact.NONE;
    }
  }
}

extension TypeContactExt2 on TypeContact {
  int get value {
    switch (this) {
      case TypeContact.VietQR_ID:
        return 1;
      case TypeContact.Bank:
        return 2;
      case TypeContact.Other:
        return 3;
      case TypeContact.NONE:
      default:
        return -1;
    }
  }

  String get typeName {
    switch (this) {
      case TypeContact.VietQR_ID:
        return 'VietQR ID';
      case TypeContact.Bank:
        return 'Bank';
      case TypeContact.VCard:
        return 'VCard';
      case TypeContact.Other:
        return 'Khác';
      case TypeContact.NONE:
      default:
        return '';
    }
  }

  String get dialogName {
    switch (this) {
      case TypeContact.VietQR_ID:
        return 'VietQR ID';
      case TypeContact.Bank:
        return 'Mã VietQR ngân hàng';
      case TypeContact.VCard:
        return 'VCard';
      case TypeContact.Other:
        return 'Mã QR không xác định';
      case TypeContact.NONE:
      default:
        return '';
    }
  }
}

enum BankDetailType {
  NONE,
  SUCCESS,
  GET_MERCHANT_INFO,
  DELETED,
  ERROR,
  UN_LINK_BIDV,
  OTP,
  CREATE_QR,
  GET_LIST_GROUP,
  REQUEST_OTP
}

enum AccountType { NONE, LOG_OUT, POINT, AVATAR, ERROR }

enum AddBankType {
  NONE,
  LOAD_BANK,
  SEARCH_BANK,
  ERROR,
  ERROR_OTP,
  ERROR_SEARCH_NAME,
  ERROR_EXIST,
  ERROR_SYSTEM,
  REQUEST_BANK,
  RESENT_REQUEST_BANK,
  INSERT_BANK,
  EXIST_BANK,
  OTP_BANK,
  INSERT_OTP_BANK,
  SCAN_QR,
  REQUEST_REGISTER,
  GET_BANK_LOCAL,
  SCAN_NOT_FOUND
}

enum VietQrStore {
  NONE,
  GET_LIST,
  LOADMORE,
}

enum BankType {
  QR,
  NONE,
  BANK,
  GET_BANK,
  GET_BANK_LOCAL,
  GET_KEY_FREE,
  GET_OVERVIEW,
  GET_INVOICE_OVERVIEW,
  GET_TRANS,
  ARRANGE,
  VERIFY,
}

enum ConnectMedia {
  NONE,
  GET_LIST_CHAT,
  GET_LIST_TELE,
  GET_LIST_LARK,
  GET_LIST_DISCORD,
  GET_LIST_SLACK,
  GET_LIST_SHEET,

  LOAD_MORE,
  GET_INFO,
  CHECK_URL,
  DELETE_URL,
  UPDATE_SHARING,
  UPDATE_URL,
  MAKE_CONNECTION,
  ADD_BANKS,
  REMOVE_BANK,
}

enum InvoiceType {
  NONE,
  GET_INVOICE_LIST,
  INVOICE_DETAIL,
  FILTER_INVOICE,
}

enum MainChargeType {
  NONE,
  CREATE_MAINTAIN,
  CONFIRM_SUCCESS,
  GET_ANNUAL_FEE_LIST,
  REQUEST_ACTIVE_ANNUAL_FEE,
  CONFIRM_ACTIVE_ANNUAL_FEE
}

enum TransType { NONE, GET_TRANDS, GET_FILTER }

enum ContactType {
  NONE,
  GET_LIST,
  GET_LIST_PEN,
  GET_DETAIL,
  GET_LIST_RECHARGE,
  REMOVE,
  UPDATE,
  UPDATE_RELATION,
  ERROR,
  SAVE,
  SUGGEST,
  NICK_NAME,
  SCAN,
  SCAN_ERROR,
  SEARCH_USER,
  OTHER,
  VCARD,
  INSERT_VCARD,
}

enum CreateQRType {
  NONE,
  CREATE_QR,
  UPLOAD_IMAGE,
  ERROR,
  PAID,
  LOAD_DATA,
  SCAN_QR,
  SCAN_NOT_FOUND,
  LIST_BANK,
  LIST_TERMINAL,
  LIST_QR_BOX,
}

enum QrFeed {
  NONE,
  GET_QR_FEED_LIST,
  GET_QR_FEED_PRIVATE,
  GET_QR_FEED_POPUP_DETAIL,
  DELETE_QR_FEED,
  GET_QR_FEED_FOLDER,
  GET_FOLDER_DETAIL,
  GET_USER_FOLDER,
  GET_UPDATE_FOLDER_DETAIL,
  ADD_USER,
  UPDATE_QR,
  UPDATE_QR_FOLDER,
  UPDATE_FOLDER_TITLE,
  REMOVE_QR_FOLDER,
  GET_QR_FOLDER,
  REMOVE_USER,
  UPDATE_USER_ROLE,
  GET_MORE_USER_FOLDER,
  GET_MORE_FOLDER_DETAIL,
  GET_USER_QR,
  DELETE_FOLDER,
  GET_MORE,
  GET_MORE_QR,
  GET_MORE_FOLDER,
  GET_DETAIL_QR,
  LOAD_CMT,
  ADD_CMT,
  CREATE_FOLDER,
  CREATE_QR,
  GET_BANKS,
  SEARCH_BANK,
  INTERACT_WITH_QR,
}

enum DashBoardType {
  GET_BANK,
  GET_BANK_LOCAL,
  NONE,
  LOGIN,
  LOGIN_ERROR,
  ERROR,
  POINT,
  TOKEN,
  APP_VERSION,
  THEMES,
  UPDATE_THEME,
  UPDATE_THEME_ERROR,
  GET_USER_SETTING,
  KEEP_BRIGHT,
  COUNT_NOTIFY,
  UPDATE_STATUS_NOTIFY,
  CLOSE_NOTIFICATION,
}

enum DashBoardTypePermission {
  None,
  CameraDenied,
  CameraAllow,
  CameraRequest,
  Allow,
  Request,
  Denied,
  Error,
}

enum HomeType { NONE, GET_BANK, SCAN_ERROR, SCAN_NOT_FOUND, SCAN, POINT }

enum TypePermission {
  None,
  CameraDenied,
  CameraAllow,
  CameraRequest,
  Allow,
  Request,
  Denied,
  Error,
}

enum LoginType {
  NONE,
  SUCCESS,
  LOGIN,
  ERROR,
  CHECK_EXIST,
  REGISTER,
  FREE_TOKEN,
  APP_VERSION,
}

enum ForgotPasswordType {
  NONE,
  SUCCESS,
  SEND_OTP,
  RESEND_OTP,
  ERROR,
  UPDATE_VERIFY_ID,
  UPDATE_RESEND_TOKEN,
  UDPATE_RESSEND_OTP,
  VERIFY_OTP,
  FREE_TOKEN,
  APP_VERSION,
  FORGOT_PASS,
  CONFIRM_PASS,
  NEW_PASS,
  CHANGE_PASS
}

enum RegisterType {
  NONE,
  SUCCESS,
  REGISTER,
  ERROR,
  CHECK_EXIST,
  SENT_OPT,
  RESENT_OTP,
  UPDATE_HEIGHT,
  UPDATE_VERIFY_ID,
  UPDATE_RESEND_TOKEN,
  UPDATE_PHONE,
  UPDATE_PASSWORD,
  UPDATE_CONFIRM_PASSWORD,
  UPDATE_ERROR,
  UPDATE_INTRODUCE,
  RESET,
  UPDATE_PAGE,
  VERIFY_OTP,
  PHONE_AUTHENTICATION,
  LOGIN_AFTER_REGISTER
}

enum TransactionType {
  NONE,
  LOAD_DATA,
  REFRESH,
  GET_LIST,
  ERROR,
  UPDATE_NOTE,
}

enum TransHistoryType { NONE, ERROR, LOAD_DATA, UPDATE_NOTE, GET_LIST_GROUP }

enum ScanType {
  NONE,
  SCAN,
  SCAN_ERROR,
  SCAN_NOT_FOUND,
  SEARCH_NAME,
  PERMISSION,
  NICK_NAME,
}

enum TypeInternet {
  NONE,
  CONNECT,
  DISCONNECT,
}

enum ShareBDSDType {
  NONE,
  Avail,
  ERROR,
  CONNECT,
  MEMBER,
  SEARCH_MEMBER,
  DELETE_MEMBER,
  TELEGRAM,
  LARK,
  ADD_LARK,
  ADD_TELEGRAM,
  REMOVE_TELEGRAM,
  SHARE_BDSD,
  GET_LIST_GROUP,
  REMOVE_LARK,
}

enum CategoryType {
  vcard,
  community,
  personal,
  bank,
  viet_id,
  other,
  suggest,
}

extension categoryExt on CategoryType {
  int get value {
    switch (this) {
      case CategoryType.vcard:
        return 4;
      case CategoryType.community:
        return 8;
      case CategoryType.personal:
        return 9;
      case CategoryType.bank:
        return 2;
      case CategoryType.viet_id:
        return 1;
      case CategoryType.other:
        return 3;
      case CategoryType.suggest:
      default:
        return 0;
    }
  }
}

enum TypeTimeFilter {
  ALL,
  TODAY,
  SEVEN_LAST_DAY,
  THIRTY_LAST_DAY,
  THREE_MONTH_LAST_DAY,
  PERIOD,
  NONE
}

extension TypeTimeFilterExt on TypeTimeFilter {
  int get id {
    switch (this) {
      case TypeTimeFilter.ALL:
        return 0;
      case TypeTimeFilter.TODAY:
        return 1;
      case TypeTimeFilter.SEVEN_LAST_DAY:
        return 2;
      case TypeTimeFilter.THIRTY_LAST_DAY:
        return 3;
      case TypeTimeFilter.THREE_MONTH_LAST_DAY:
        return 4;
      case TypeTimeFilter.PERIOD:
        return 5;
      default:
        return 0;
    }
  }
}

enum TypeFilter {
  ALL,
  BANK_NUMBER,
  TRANS_CODE,
  ORDER_ID,
  CODE_SALE,
  CONTENT,
  STATUS_TRANS,
  NONE
}

extension TypeFilterExt on int {
  TypeFilter get typeTrans {
    switch (this) {
      case 9:
        return TypeFilter.ALL;
      case 0:
        return TypeFilter.BANK_NUMBER;
      case 1:
        return TypeFilter.TRANS_CODE;
      case 2:
        return TypeFilter.ORDER_ID;
      case 3:
        return TypeFilter.CONTENT;
      case 4:
        return TypeFilter.CODE_SALE;
      case 5:
        return TypeFilter.STATUS_TRANS;
      default:
        return TypeFilter.NONE;
    }
  }
}

enum LinkBankType { LINK, NOT_LINK }

extension LinkBankTypeExt on int {
  LinkBankType get linkType {
    switch (this) {
      case 1:
        return LinkBankType.LINK;
      case 0:
        return LinkBankType.NOT_LINK;

      default:
        return LinkBankType.NOT_LINK;
    }
  }
}
