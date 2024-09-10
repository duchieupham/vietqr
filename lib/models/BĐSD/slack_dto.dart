class SlackDTO {
  String webhook;
  String slackId;
  int bankAccountCount;
  String name;

  SlackDTO({
    required this.webhook,
    required this.slackId,
    required this.bankAccountCount,
    required this.name,
  });

  // Factory constructor to create an instance of SlackDTO from a JSON map
  factory SlackDTO.fromJson(Map<String, dynamic> json) {
    return SlackDTO(
      webhook: json['webhook'],
      slackId: json['slackId'],
      bankAccountCount: json['bankAccountCount'],
      name: json['name'] ?? ''
    );
  }

  // Method to convert an instance of SlackDTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'webhook': webhook,
      'slackId': slackId,
      'bankAccountCount': bankAccountCount,
      'name': name
    };
  }
}
