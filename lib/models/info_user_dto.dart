import 'dart:convert';

class InfoUserDTO {
  final String? phoneNo;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? imgId;
  final String? id;
  final String? createdTime;

  get fullName => '${lastName ?? ''} ${middleName ?? ''} ${firstName ?? ''}';

  DateTime get expiryAsDateTime => DateTime.parse(createdTime ?? '');

  factory InfoUserDTO.fromJson(Map<String, dynamic> json) {
    return InfoUserDTO(
      phoneNo: json['phoneNo'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      imgId: json['imgId'] ?? '',
      id: json['id'] ?? '',
      createdTime: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"id"'] = (id == '') ? '""' : '"$id"';
    data['"firstName"'] = (firstName == '') ? '""' : '"$firstName"';
    data['"middleName"'] = (middleName == '') ? '""' : '"$middleName"';
    data['"lastName"'] = (lastName == '') ? '""' : '"$lastName"';
    data['"phoneNo"'] = (phoneNo == '') ? '""' : '"$phoneNo"';
    data['"imgId"'] = (imgId == '') ? '""' : '"$imgId"';
    data['"createdTime"'] = (createdTime == '') ? '""' : '"$createdTime"';
    return data;
  }

  InfoUserDTO(
      {this.phoneNo,
      this.firstName,
      this.middleName,
      this.lastName,
      this.imgId,
      this.createdTime,
      this.id});
}

class ListLoginAccountDTO {
  final List<InfoUserDTO> list;

  ListLoginAccountDTO({required this.list});

  factory ListLoginAccountDTO.fromJson(List? datas) {
    List<InfoUserDTO> list = [];
    if (datas == null || datas.isEmpty) {
      return ListLoginAccountDTO(list: list);
    }
    try {
      list = datas.map((f) => InfoUserDTO.fromJson(json.decode(f))).toList();
    } catch (e) {}
    return ListLoginAccountDTO(list: list);
  }
}
