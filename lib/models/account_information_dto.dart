class AccountInformationDTO {
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthDate;
  final String nationalId;
  final String oldNationalId;
  final String nationalDate;

  final int gender;
  final String address;
  final String email;
  final String imgId;
  final String carrierTypeId;

  const AccountInformationDTO({
    this.userId = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.birthDate = '',
    this.gender = 0,
    this.address = '',
    this.email = '',
    this.imgId = '',
    this.nationalDate = '',
    this.oldNationalId = '',
    this.nationalId = '',
    this.carrierTypeId = '',
  });

  factory AccountInformationDTO.fromJson(Map<String, dynamic> json) {
    return AccountInformationDTO(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: int.tryParse(json['gender'].toString()) ?? 0,
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      imgId: json['imgId'] ?? '',
      nationalDate: json['nationalDate'] ?? '',
      oldNationalId: json['oldNationalId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      carrierTypeId: json['carrierTypeId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    data['address'] = address;
    data['email'] = email;
    data['imgId'] = imgId;
    data['nationalId'] = nationalId;
    data['oldNationalId'] = oldNationalId;
    data['nationalDate'] = nationalDate;
    data['carrierTypeId'] = carrierTypeId;
    return data;
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"userId"'] = (userId == '') ? '""' : '"$userId"';
    data['"firstName"'] = (firstName == '') ? '""' : '"$firstName"';
    data['"middleName"'] = (middleName == '') ? '""' : '"$middleName"';
    data['"lastName"'] = (lastName == '') ? '""' : '"$lastName"';
    data['"birthDate"'] = (birthDate == '') ? '""' : '"$birthDate"';
    data['"gender"'] = '"$gender"';
    data['"address"'] = (address == '') ? '""' : '"$address"';
    data['"email"'] = (email == '') ? '""' : '"$email"';
    data['"imgId"'] = (imgId == '') ? '""' : '"$imgId"';
    data['"nationalDate"'] = (nationalDate == '') ? '""' : '"$nationalDate"';
    data['"oldNationalId"'] = (oldNationalId == '') ? '""' : '"$oldNationalId"';
    data['"nationalId"'] = (nationalId == '') ? '""' : '"$nationalId"';
    data['"carrierTypeId"'] = (carrierTypeId == '') ? '""' : '"$carrierTypeId"';
    return data;
  }
}
