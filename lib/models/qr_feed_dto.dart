class QrFeedDTO {
  String id;
  String description;
  bool isPublic;
  String qrType;
  DateTime timeCreate;
  String title;
  String content;

  QrFeedDTO({
    required this.id,
    required this.description,
    required this.isPublic,
    required this.qrType,
    required this.timeCreate,
    required this.title,
    required this.content,
  });

  factory QrFeedDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedDTO(
      id: json['id'],
      description: json['description'],
      isPublic: json['isPublic'] == "1",
      qrType: json['qrType'],
      timeCreate: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['timeCreate']) * 1000),
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isPublic': isPublic ? "1" : "0",
      'qrType': qrType,
      'timeCreate': (timeCreate.millisecondsSinceEpoch / 1000).round(),
      'title': title,
      'content': content,
    };
  }
}
