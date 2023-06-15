// ignore_for_file: constant_identifier_names

enum BlocStatus {
  NONE,
  LOADING,
  ERROR,
  AWAIT,
  SUCCESS,
  DONE,
}

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
