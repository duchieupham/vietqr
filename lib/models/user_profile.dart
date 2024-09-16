class UserProfile {
  String userId;
  String firstName;
  String middleName;
  String lastName;
  String birthDate;
  String timeCreated;
  String nationalId;
  String oldNationalId;
  String nationalDate;
  int gender;
  String address;
  String email;
  String imgId;
  String carrierTypeId;
  bool verify;
  int balance; // Added field
  int score; // Added field

  UserProfile({
    this.userId = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.birthDate = '',
    this.timeCreated = '',
    this.gender = 0,
    this.address = '',
    this.email = '',
    this.imgId = '',
    this.nationalDate = '',
    this.oldNationalId = '',
    this.nationalId = '',
    this.carrierTypeId = '',
    this.verify = false,
    this.balance = 0, // Initialize new field
    this.score = 0, // Initialize new field
  });

  String get fullName => ('$lastName $middleName $firstName').trim();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      timeCreated: json['timeCreated'] ?? '',
      gender: int.tryParse(json['gender'].toString()) ?? 0,
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      imgId: json['imgId'] ?? '',
      nationalDate: json['nationalDate'] ?? '',
      oldNationalId: json['oldNationalId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      carrierTypeId: json['carrierTypeId'] ?? '',
      verify: json['verify'] ?? false,
      balance:
          int.tryParse(json['balance'].toString()) ?? 0, // Handle new field
      score: int.tryParse(json['score'].toString()) ?? 0, // Handle new field
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['birthDate'] = birthDate;
    data['timeCreated'] = timeCreated;
    data['gender'] = gender;
    data['address'] = address;
    data['email'] = email;
    data['imgId'] = imgId;
    data['nationalId'] = nationalId;
    data['oldNationalId'] = oldNationalId;
    data['nationalDate'] = nationalDate;
    data['carrierTypeId'] = carrierTypeId;
    data['verify'] = verify;
    data['balance'] = balance; // Handle new field
    data['score'] = score; // Handle new field
    return data;
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"userId"'] = (userId == '') ? '""' : '"$userId"';
    data['"firstName"'] = (firstName == '') ? '""' : '"$firstName"';
    data['"middleName"'] = (middleName == '') ? '""' : '"$middleName"';
    data['"lastName"'] = (lastName == '') ? '""' : '"$lastName"';
    data['"birthDate"'] = (birthDate == '') ? '""' : '"$birthDate"';
    data['"timeCreated"'] = (timeCreated == '') ? '""' : '"$timeCreated"';
    data['"gender"'] = '"$gender"';
    data['"address"'] = (address == '') ? '""' : '"$address"';
    data['"email"'] = (email == '') ? '""' : '"$email"';
    data['"imgId"'] = (imgId == '') ? '""' : '"$imgId"';
    data['"nationalDate"'] = (nationalDate == '') ? '""' : '"$nationalDate"';
    data['"oldNationalId"'] = (oldNationalId == '') ? '""' : '"$oldNationalId"';
    data['"nationalId"'] = (nationalId == '') ? '""' : '"$nationalId"';
    data['"carrierTypeId"'] = (carrierTypeId == '') ? '""' : '"$carrierTypeId"';
    data['"verify"'] =
        (verify == false) ? '""' : '"$verify"'; // Handle new field
    data['"balance"'] =
        (balance == 0) ? '""' : '"$balance"'; // Handle new field
    data['"score"'] = (score == 0) ? '""' : '"$score"'; // Handle new field
    return data;
  }
}
