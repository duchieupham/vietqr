class NotificationDTO {
  final String id;
  final String transactionId;
  final String userId;
  final String type;
  final String message;
  final dynamic timeInserted;
  final bool isRead;

  const NotificationDTO({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.message,
    required this.timeInserted,
    required this.isRead,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['transactionId'] = transactionId;
    data['userId'] = userId;
    data['type'] = type;
    data['message'] = message;
    data['timeCreated'] = timeInserted;
    data['isRead'] = isRead;
    return data;
  }
}
