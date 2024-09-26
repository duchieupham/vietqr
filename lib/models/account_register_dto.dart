class AccountRegisterDTO {
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthdate;
  final bool gender;
  final String phoneNo;
  final String address;
  final String password;

  const AccountRegisterDTO({
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.phoneNo,
    required this.address,
    required this.password,
  });

  Map<String, dynamic> toUserInformationJson() {
    Map<String, dynamic> data = {};
    data['id'] = userId;
    data['address'] = address;
    data['birthDate'] = birthdate;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['phoneNo'] = phoneNo;
    return data;
  }

  Map<String, dynamic> toUserAccountJson() {
    Map<String, dynamic> data = {};
    data['id'] = userId;
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    return data;
  }
}
