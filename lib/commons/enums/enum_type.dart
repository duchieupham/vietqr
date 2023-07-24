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

enum TypePhoneBook {
  VietQR_ID,
  Bank,
  Other,
  NONE,
}
// 1: VietQR ID
// 2: Bank
// 3: Khác
// 4: CMT
// 5: link
// 5: BarCode

extension TypePhoneBookExt on int {
  TypePhoneBook get type {
    switch (this) {
      case 1:
        return TypePhoneBook.VietQR_ID;
      case 2:
        return TypePhoneBook.Bank;
      case 3:
        return TypePhoneBook.Other;
      default:
        return TypePhoneBook.NONE;
    }
  }
}

extension TypePhoneBookExt2 on TypePhoneBook {
  int get value {
    switch (this) {
      case TypePhoneBook.VietQR_ID:
        return 1;
      case TypePhoneBook.Bank:
        return 2;
      case TypePhoneBook.Other:
        return 3;
      case TypePhoneBook.NONE:
      default:
        return -1;
    }
  }

  String get typeName {
    switch (this) {
      case TypePhoneBook.VietQR_ID:
        return 'VietQR ID';
      case TypePhoneBook.Bank:
        return 'Bank';
      case TypePhoneBook.Other:
        return 'Khác';
      case TypePhoneBook.NONE:
      default:
        return '';
    }
  }
}
