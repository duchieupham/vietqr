class MessageDTO {
  final int id;
  final int threadId;
  final String address;
  final String body;
  final bool read;
  final String date;
  final String dateSent;

  const MessageDTO(
      {required this.id,
      required this.threadId,
      required this.address,
      required this.body,
      required this.date,
      required this.dateSent,
      required this.read});

  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(
      id: json['id'] ?? 0,
      threadId: json['threadId'] ?? 0,
      address: json['address'] ?? '',
      body: json['body'] ?? '',
      date: json['date'] ?? '',
      dateSent: json['dateSent'] ?? '',
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['threadId'] = threadId;
    data['address'] = address;
    data['body'] = body;
    data['date'] = date;
    data['dateSent'] = dateSent;
    data['read'] = read;
    return data;
  }
}
