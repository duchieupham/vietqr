// ignore_for_file: constant_identifier_names

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
