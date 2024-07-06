import 'dart:convert';

class QrFeedFolderDTO {
  String id;
  String description;
  String userId;
  String title;
  int timeCreated;

  QrFeedFolderDTO({
    required this.id,
    required this.description,
    required this.userId,
    required this.title,
    required this.timeCreated,
  });

  // Factory constructor to create an instance from a map (JSON)
  factory QrFeedFolderDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedFolderDTO(
      id: json['id'],
      description: json['description'],
      userId: json['userId'],
      title: json['title'],
      timeCreated: json['timeCreated'],
    );
  }

  // Method to convert an instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'title': title,
      'timeCreated': timeCreated,
    };
  }

  // Method to convert an instance to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
