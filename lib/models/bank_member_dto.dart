class BankMemberDTO {
  final String id;
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNo;
  final String imgId;
  final int role;
  final String status;

  const BankMemberDTO({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phoneNo,
    required this.imgId,
    required this.role,
    required this.status,
  });

  factory BankMemberDTO.fromJson(Map<String, dynamic> json) {
    return BankMemberDTO(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      imgId: json['imgId'] ?? '',
      role: json['role'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['[phoneNo'] = phoneNo;
    data['imgId'] = imgId;
    data['role'] = role;
    data['status'] = status;
    return data;
  }
}
