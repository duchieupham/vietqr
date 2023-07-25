// ignore_for_file: constant_identifier_names

enum BlocStatus {
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

enum StepType { first_screen, second_screen, three_screen }

enum TypeSelect {
  BANK,
  MEMBER,
}

enum CheckType {
  C01,
  C02,
  C03,
  C04,
}

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
  VietQR_ID,
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
}

enum BankDetailType { NONE, SUCCESS, DELETED, ERROR, UN_LINK, OTP }

enum AccountType { NONE, LOG_OUT, POINT, AVATAR, ERROR }

enum AddBankType {
  NONE,
  LOAD_BANK,
  SEARCH_BANK,
  ERROR,
  REQUEST_BANK,
  INSERT_BANK,
  EXIST_BANK,
  OTP_BANK,
  INSERT_OTP_BANK,
  SCAN_QR,
  SCAN_NOT_FOUND
}

enum BankType { QR, NONE, SCAN, BANK, GET_BANK, SCAN_ERROR, SCAN_NOT_FOUND }

enum TransType { NONE, GET_TRANDS }

enum ContactType {
  NONE,
  GET_LIST,
  GET_DETAIL,
  REMOVE,
  UPDATE,
  ERROR,
  SAVE,
  SUGGEST,
  NICK_NAME,
  SCAN,
  SCAN_ERROR,
  OTHER,
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

enum HomeType { GET_BANK, NONE, SCAN_ERROR, SCAN_NOT_FOUND, SCAN }

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

enum LoginType { NONE, SUCCESS, TOAST, ERROR, CHECK_EXIST, REGISTER }

enum TransactionType { NONE, LOAD_DATA, REFRESH }

enum TransHistoryType { NONE, ERROR, LOAD_DATA }
