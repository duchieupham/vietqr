class BusinessMemberDTO {
  final String userId;
  final int role;
  final String name;
  final String phoneNo;
  final String imgId;
  //for check status reponse found member or not
  final String status;
  final int existed;

  const BusinessMemberDTO({
    required this.userId,
    required this.name,
    required this.role,
    required this.phoneNo,
    required this.imgId,
    required this.status,
    required this.existed,
  });

  factory BusinessMemberDTO.fromJson(Map<String, dynamic> json) {
    return BusinessMemberDTO(
      userId: json['id'] ?? '',
      name: (json['lastName'] != null)
          ? json['lastName'] +
              ' ' +
              json['middleName'] +
              ' ' +
              json['firstName']
          : '',
      role: json['role'] ?? 0,
      phoneNo: json['phoneNo'] ?? '',
      imgId: json['imgId'] ?? '',
      status: json['status'] ?? '',
      existed: json['existed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['role'] = role;
    return data;
  }
}
