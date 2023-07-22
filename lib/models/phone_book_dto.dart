class PhoneBookDTO {
  String id;
  String nickname;
  int status;
  int type;
  String imgId;
  String description;

  PhoneBookDTO({
    required this.id,
    required this.nickname,
    required this.status,
    required this.type,
    required this.imgId,
    required this.description,
  });

  factory PhoneBookDTO.fromJson(Map<String, dynamic> json) => PhoneBookDTO(
        id: json["id"],
        nickname: json["nickname"],
        status: json["status"],
        type: json["type"],
        imgId: json["imgId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "status": status,
        "type": type,
        "imgId": imgId,
        "description": description,
      };
}
