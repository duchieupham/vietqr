class InfoUserDTO {
  final String? phoneNo;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? imgId;
  final String? id;

  get fullName => '${lastName ?? ''} ${middleName ?? ''} ${firstName ?? ''}';

  factory InfoUserDTO.fromJson(Map<String, dynamic> json) {
    return InfoUserDTO(
      phoneNo: json['phoneNo'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      imgId: json['imgId'] ?? '',
      id: json['id'] ?? '',
    );
  }

  InfoUserDTO(
      {this.phoneNo,
      this.firstName,
      this.middleName,
      this.lastName,
      this.imgId,
      this.id});
}
