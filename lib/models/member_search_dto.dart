import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class MemberSearchDto {
  final String? phoneNo;
  final String? lastName;
  final String? middleName;
  final String? firstName;
  final String imgId;
  final String? id;
  late int existed;

  MemberSearchDto({
    this.phoneNo,
    this.lastName,
    this.middleName,
    this.firstName,
    this.imgId = '',
    this.id,
    this.existed = 0,
  });

  String get fullName =>
      '${lastName ?? ''}' + ' ${middleName ?? ''} ' + '${firstName ?? ''}';

  bool get isMe => id == SharePrefUtils.getProfile().userId;

  factory MemberSearchDto.fromJson(Map<String, dynamic> json) {
    return MemberSearchDto(
      id: json['id'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
      firstName: json['firstName'] ?? '',
      imgId: json['imgId'] ?? '',
      existed: json['existed'] ?? 0,
    );
  }
}
