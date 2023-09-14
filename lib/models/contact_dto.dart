class ContactDTO {
  String id;
  String nickname;
  int status;
  int type;
  String imgId;
  String description;
  String phoneNo;
  String carrierTypeId;
  int relation;

  ContactDTO({
    required this.id,
    required this.nickname,
    required this.status,
    required this.type,
    required this.imgId,
    required this.description,
    required this.phoneNo,
    required this.carrierTypeId,
    required this.relation,
  });

  factory ContactDTO.fromJson(Map<String, dynamic> json) => ContactDTO(
        id: json["id"] ?? '',
        nickname: json["nickname"] ?? '',
        status: json["status"] ?? 0,
        type: json["type"] ?? 0,
        imgId: json["imgId"] ?? '',
        description: json["description"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
        carrierTypeId: json["carrierTypeId"] ?? '',
        relation: json["relation"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "status": status,
        "type": type,
        "imgId": imgId,
        "description": description,
        "phoneNo": phoneNo,
        "carrierTypeId": carrierTypeId,
        "relation": relation,
      };
}
