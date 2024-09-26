class VietQRDTO {
  final String nickName;
  final String imgId;
  final String? phone;
  int colorType;
  String? code;

  VietQRDTO({
    required this.nickName,
    required this.imgId,
    this.code,
    this.phone,
    this.colorType = 0,
  });

  setColorType(value) {
    colorType = value;
  }

  setCode(value) {
    code = value;
  }

  factory VietQRDTO.fromJson(Map<String, dynamic> json) {
    return VietQRDTO(
      nickName: json['nickname'] ?? '',
      imgId: json['imgId'] ?? '',
      // phone: json['phone'] ?? '',
    );
  }
}
