class UserInformationDTO {
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthDate;
  final int gender;
  final String address;
  final String email;

  const UserInformationDTO({
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.email,
  });

  factory UserInformationDTO.fromJson(Map<String, dynamic> json) {
    return UserInformationDTO(
      userId: json['userId'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? 0,
      address: json['address'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['userId'] = userId;
    data['address'] = address;
    data['birthDate'] = birthDate;
    data['gender'] = int.tryParse(gender.toString()) ?? 0;
    data['address'] = address;
    data['email'] = email;
    return data;
  }
}
