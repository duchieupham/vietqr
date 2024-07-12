class TeleDTO {
  String telegramId;
  String chatId;
  int bankAccountCount;

  TeleDTO({
    required this.telegramId,
    required this.chatId,
    required this.bankAccountCount,
  });

  factory TeleDTO.fromJson(Map<String, dynamic> json) {
    return TeleDTO(
      telegramId: json['telegramId'],
      chatId: json['chatId'],
      bankAccountCount: json['bankAccountCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'telegramId': telegramId,
      'chatId': chatId,
      'bankAccountCount': bankAccountCount,
    };
  }
}
