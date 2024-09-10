class TeleDTO {
  String telegramId;
  String chatId;
  int bankAccountCount;
  String name;

  TeleDTO({
    required this.telegramId,
    required this.chatId,
    required this.bankAccountCount,
    required this.name,
  });

  factory TeleDTO.fromJson(Map<String, dynamic> json) {
    return TeleDTO(
      telegramId: json['telegramId'],
      chatId: json['chatId'],
      bankAccountCount: json['bankAccountCount'],
      name: json['name'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'telegramId': telegramId,
      'chatId': chatId,
      'bankAccountCount': bankAccountCount,
      'name': name
    };
  }
}
