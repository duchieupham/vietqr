class GoogleChatDTO {
  int bankAccountCount;
  String webhook;
  String googleChatId;
  String name;

  GoogleChatDTO({
    required this.bankAccountCount,
    required this.webhook,
    required this.googleChatId,
    required this.name,
  });

  factory GoogleChatDTO.fromJson(Map<String, dynamic> json) {
    return GoogleChatDTO(
      bankAccountCount: json['bankAccountCount'],
      webhook: json['webhook'],
      googleChatId: json['googleChatId'],
      name: json['name'] ?? json['webhook'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankAccountCount': bankAccountCount,
      'webhook': webhook,
      'googleChatId': googleChatId,
      'name': name,
    };
  }
}
