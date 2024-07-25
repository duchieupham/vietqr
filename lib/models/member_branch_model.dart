import 'package:vierqr/commons/enums/enum_type.dart';

class MemberBranchModel {
  final String? phoneNo;
  final String? lastName;
  final String? middleName;
  final String? firstName;
  final String imgId;
  final String id;
  final bool isOwner;
  int? existed;

  MemberBranchModel({
    this.phoneNo,
    this.lastName,
    this.middleName,
    this.firstName,
    this.imgId = '',
    this.id = '',
    this.existed,
    this.isOwner = false,
  });

  setExisted(value) {
    existed = value;
  }

  TypeAddMember get typeMember {
    if (existed == 0) {
      return TypeAddMember.MORE;
    } else if (existed == 1) {
      return TypeAddMember.ADDED;
    }
    return TypeAddMember.AWAIT;
  }

  String get fullName =>
      '${lastName ?? ''} ${middleName ?? ''} ${firstName ?? ''}';

  factory MemberBranchModel.fromJson(Map<String, dynamic> json) {
    return MemberBranchModel(
      id: json['id'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
      firstName: json['firstName'] ?? '',
      imgId: json['imgId'] ?? '',
      existed: json['existed'] ?? 0,
      isOwner: json['isOwner'] ?? false,
    );
  }
}
