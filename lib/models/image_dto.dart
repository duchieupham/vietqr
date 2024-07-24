class ImageDTO {
  String imgId;

  ImageDTO({
    required this.imgId,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) {
    return ImageDTO(
      imgId: json['imgId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imgId': imgId,
    };
  }
}
