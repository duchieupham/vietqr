// ignore_for_file: constant_identifier_names

enum BlocStatus {
  LOADING_PAGE,
  NONE,
  LOADING,
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

enum PageType { ACCOUNT, HOME, SCAN_QR, CARD_QR, PERSON }

extension PageTypeExt on int {
  PageType get pageType {
    switch (this) {
      case 1:
        return PageType.HOME;
      case -1:
        return PageType.SCAN_QR;
      case 2:
        return PageType.CARD_QR;
      case 3:
        return PageType.PERSON;
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
      case PageType.PERSON:
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

enum CheckType { C01, C02, C03, C04, C06 }

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

enum BankDetailType { NONE, SUCCESS, DELETED, ERROR, UN_LINK, OTP, CREATE_QR }

enum AccountType { NONE, LOG_OUT, POINT, AVATAR, ERROR }

enum AddBankType {
  NONE,
  LOAD_BANK,
  SEARCH_BANK,
  ERROR,
  ERROR_EXIST,
  ERROR_SYSTEM,
  REQUEST_BANK,
  INSERT_BANK,
  EXIST_BANK,
  OTP_BANK,
  INSERT_OTP_BANK,
  SCAN_QR,
  REQUEST_REGISTER,
  GET_BANK_LOCAL,
  SCAN_NOT_FOUND
}

enum BankType {
  QR,
  NONE,
  BANK,
  GET_BANK,
  GET_BANK_LOCAL,
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
}

enum DashBoardType {
  GET_BANK,
  GET_BANK_LOCAL,
  NONE,
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
  TOAST,
  ERROR,
  CHECK_EXIST,
  REGISTER,
  FREE_TOKEN,
  APP_VERSION,
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
      default:
        return LinkBankType.NOT_LINK;
    }
  }
}
