
class QrFeedPrivateDTO {
  final String data;
  final String fullName;
  final String theme;
  final String style;
  final String userId;
  final String title;
  final int timeCreated;
  final String fileAttachmentId;
  final String qrType;
  final String imageId;
  final String description;
  final String value;
  final String id;

  QrFeedPrivateDTO({
    required this.data,
    required this.fullName,
    required this.theme,
    required this.style,
    required this.userId,
    required this.title,
    required this.timeCreated,
    required this.fileAttachmentId,
    required this.qrType,
    required this.imageId,
    required this.description,
    required this.value,
    required this.id,
  });

  factory QrFeedPrivateDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedPrivateDTO(
      data: json['data'],
      fullName: json['fullName'],
      theme: json['theme'],
      style: json['style'],
      userId: json['userId'],
      title: json['title'],
      timeCreated: json['timeCreated'],
      fileAttachmentId: json['fileAttachmentId'],
      qrType: json['qrType'],
      imageId: json['imageId'],
      description: json['description'],
      value: json['value'],
      id: json['id'],
    );
  }
}
