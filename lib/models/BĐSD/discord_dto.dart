class DiscordDTO {
  String webhook;
  String discordId;
  int bankAccountCount;

  DiscordDTO({
    required this.webhook,
    required this.discordId,
    required this.bankAccountCount,
  });

  // Factory constructor to create an instance of SlackDTO from a JSON map
  factory DiscordDTO.fromJson(Map<String, dynamic> json) {
    return DiscordDTO(
      webhook: json['webhook'],
      discordId: json['discordId'],
      bankAccountCount: json['bankAccountCount'],
    );
  }

  // Method to convert an instance of SlackDTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'webhook': webhook,
      'discordId': discordId,
      'bankAccountCount': bankAccountCount,
    };
  }
}
