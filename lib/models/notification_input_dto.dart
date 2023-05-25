class NotificationInputDTO {
  final String userId;
  final int offset;

  const NotificationInputDTO({
    required this.userId,
    required this.offset,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['offset'] = offset;
    return data;
  }
}
