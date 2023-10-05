// ignore_for_file: constant_identifier_names

enum BlocStatus {
  LOADING_PAGE,
  NONE,
  LOADING,
  UNLOADING,
  ERROR,
  AWAIT,
  SUCCESS,
  DELETED,
  INSERT,
  DONE,
  DELETED_ERROR,
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
  ERROR,
  AWAIT,
  NONE,
}

enum TypeMoveEvent { LEFT, RIGHT, NONE }

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
      case TypeContact.Other:
        return 'Mã QR không xác định';
      case TypeContact.NONE:
      default:
        return '';
    }
  }
}

enum BankDetailType { NONE, SUCCESS, DELETED, ERROR, UN_LINK, OTP }

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
  SCAN_NOT_FOUND
}

enum BankType { QR, NONE, SCAN, BANK, GET_BANK, SCAN_ERROR, SCAN_NOT_FOUND }

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
  SCAN_NOT_FOUND
}

enum DashBoardType {
  GET_BANK,
  NONE,
  SCAN_ERROR,
  SCAN_NOT_FOUND,
  SCAN,
  SEARCH_BANK_NAME,
  ADD_BOOK_CONTACT,
  ADD_BOOK_CONTACT_EXIST,
  ERROR,
  EXIST_BANK,
  INSERT_BANK,
  POINT,
  TOKEN,
  APP_VERSION,
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
  FREE_TOKEN
}

enum TransactionType { NONE, LOAD_DATA, REFRESH, GET_LIST }

enum TransHistoryType { NONE, ERROR, LOAD_DATA }

enum ScanType {
  NONE,
  SCAN,
  SCAN_ERROR,
  SCAN_NOT_FOUND,
  SEARCH_NAME,
  PERMISSION,
  NICK_NAME,
}

enum TokenType {
  NONE,
  InValid,
  Valid,
  MainSystem,
  Internet,
  Expired,
  Logout,
  Logout_failed,
  Fcm_success,
  Fcm_failed,
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
  DELETE_MEMBER,
  TELEGRAM,
  LARK,
  ADD_LARK,
  ADD_TELEGRAM,
  REMOVE_TELEGRAM,
  REMOVE_LARK,
}
