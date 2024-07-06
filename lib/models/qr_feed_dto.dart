import 'dart:convert';

class QrFeedDTO {
  String value;
  String id;
  String fullName;
  String imageId;
  String fileAttachmentId;
  String description;
  String data;
  String userId;
  String title;
  String style;
  String theme;

  int timeCreated;
  String qrType;
  int likeCount;
  int commentCount;
  bool hasLiked;

  QrFeedDTO({
    required this.value,
    required this.id,
    required this.fullName,
    required this.imageId,
    required this.description,
    required this.data,
    required this.userId,
    required this.title,
    required this.timeCreated,
    required this.qrType,
    required this.likeCount,
    required this.commentCount,
    required this.hasLiked,
    required this.style,
    required this.theme,
    required this.fileAttachmentId,
  });

  // Factory constructor to create an instance from a map (JSON)
  factory QrFeedDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedDTO(
      value: json['value'],
      id: json['id'],
      fullName: json['fullName'],
      imageId: json['imageId'],
      description: json['description'],
      style: json['style'] ?? '',
      theme: json['theme'] ?? '',
      data: json['data'],
      userId: json['userId'],
      title: json['title'],
      timeCreated: json['timeCreated'],
      qrType: json['qrType'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      hasLiked: json['hasLiked'] == 1,
      fileAttachmentId: json['fileAttachmentId'] ?? '',
    );
  }

  // Method to convert an instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'id': id,
      'fullName': fullName,
      'imageId': imageId,
      'description': description,
      'data': data,
      'userId': userId,
      'title': title,
      'timeCreated': timeCreated,
      'qrType': qrType,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'hasLiked': hasLiked ? 1 : 0,
      'fileAttachmentId': fileAttachmentId,
    };
  }

  // Method to convert an instance to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
