class MemberBranchModel {
  final String? phoneNo;
  final String? lastName;
  final String? middleName;
  final String? firstName;
  final String? imgId;
  final String? id;

  MemberBranchModel({
    this.phoneNo,
    this.lastName,
    this.middleName,
    this.firstName,
    this.imgId,
    this.id,
  });

  factory MemberBranchModel.fromJson(Map<String, dynamic> json) {
    return MemberBranchModel(
      id: json['id'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      lastName: json['lastName'] ?? '',
      middleName: json['middleName'] ?? '',
      firstName: json['firstName'] ?? '',
      imgId: json['imgId'] ?? '',
    );
  }
}
