class GoogleChatDTO {
  int bankAccountCount;
  String webhook;
  String googleChatId;

  GoogleChatDTO({
    required this.bankAccountCount,
    required this.webhook,
    required this.googleChatId,
  });

  factory GoogleChatDTO.fromJson(Map<String, dynamic> json) {
    return GoogleChatDTO(
      bankAccountCount: json['bankAccountCount'],
      webhook: json['webhook'],
      googleChatId: json['googleChatId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankAccountCount': bankAccountCount,
      'webhook': webhook,
      'googleChatId': googleChatId,
    };
  }
}
