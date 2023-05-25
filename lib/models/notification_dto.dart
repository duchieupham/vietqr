class NotificationDTO {
  final String id;
  final int time;
  final String userId;
  final String type;
  final String message;
  final String data;
  final bool isRead;

  const NotificationDTO({
    required this.id,
    required this.time,
    required this.userId,
    required this.type,
    required this.message,
    required this.data,
    required this.isRead,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) {
    return NotificationDTO(
      id: json['id'] ?? '',
      time: json['time'] ?? 0,
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] ?? '',
      isRead: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['time'] = time;
    data['userId'] = userId;
    data['type'] = type;
    data['message'] = message;
    data['data'] = data;
    data['isRead'] = isRead;
    return data;
  }
}
