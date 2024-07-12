class SlackDTO {
  String webhook;
  String slackId;
  int bankAccountCount;

  SlackDTO({
    required this.webhook,
    required this.slackId,
    required this.bankAccountCount,
  });

  // Factory constructor to create an instance of SlackDTO from a JSON map
  factory SlackDTO.fromJson(Map<String, dynamic> json) {
    return SlackDTO(
      webhook: json['webhook'],
      slackId: json['slackId'],
      bankAccountCount: json['bankAccountCount'],
    );
  }

  // Method to convert an instance of SlackDTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'webhook': webhook,
      'slackId': slackId,
      'bankAccountCount': bankAccountCount,
    };
  }
}
