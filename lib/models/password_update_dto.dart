class PasswordUpdateDTO {
  final String userId;
  final String oldPassword;
  final String newPassword;
  final String phoneNo;

  const PasswordUpdateDTO({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
    required this.phoneNo,
  });

  factory PasswordUpdateDTO.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateDTO(
      userId: json['userId'] ?? '',
      oldPassword: json['oldPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['oldPassword'] = oldPassword;
    data['newPassword'] = newPassword;
    return data;
  }
}
