class GoogleSheetDTO {
  String webhook;
  String ggSheetId;
  int bankAccountCount;
  String name;

  GoogleSheetDTO({
    required this.webhook,
    required this.ggSheetId,
    required this.bankAccountCount,
    required this.name,
  });

  // Factory constructor to create an instance of GoogleSheetDTO from a JSON map
  factory GoogleSheetDTO.fromJson(Map<String, dynamic> json) {
    return GoogleSheetDTO(
      webhook: json['webhook'],
      ggSheetId: json['googleSheetId'],
      bankAccountCount: json['bankAccountCount'],
      name: json['name'] ?? json['webhook'],
    );
  }

  // Method to convert an instance of GoogleSheetDTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'webhook': webhook,
      'ggSheetId': ggSheetId,
      'bankAccountCount': bankAccountCount,
      'name': name
    };
  }
}
