import 'dart:convert';

class QrFeedFolderDTO {
  String id;
  String description;
  String userId;
  String title;
  int countQrs;
  int isEdit;
  int countUsers;
  int timeCreated;

  QrFeedFolderDTO({
    required this.id,
    required this.description,
    required this.userId,
    required this.title,
    required this.isEdit,
    required this.countUsers,
    required this.countQrs,
    required this.timeCreated,
  });

  // Factory constructor to create an instance from a map (JSON)
  factory QrFeedFolderDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedFolderDTO(
      id: json['id'],
      description: json['description'],
      userId: json['userId'],
      title: json['title'],
      isEdit: json['isEdit'],
      countQrs: json['countQrs'],
      countUsers: json['countUsers'],
      timeCreated: json['timeCreated'],
    );
  }

  // Method to convert an instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'countQrs': countQrs,
      'countUsers': countUsers,
      'title': title,
      'timeCreated': timeCreated,
    };
  }

  // Method to convert an instance to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
