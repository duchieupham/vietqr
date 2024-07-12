class GoogleSheetDTO {
  String webhook;
  String ggSheetId;
  int bankAccountCount;

  GoogleSheetDTO({
    required this.webhook,
    required this.ggSheetId,
    required this.bankAccountCount,
  });

  // Factory constructor to create an instance of GoogleSheetDTO from a JSON map
  factory GoogleSheetDTO.fromJson(Map<String, dynamic> json) {
    return GoogleSheetDTO(
      webhook: json['webhook'],
      ggSheetId: json['googleSheetId'],
      bankAccountCount: json['bankAccountCount'],
    );
  }

  // Method to convert an instance of GoogleSheetDTO to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'webhook': webhook,
      'ggSheetId': ggSheetId,
      'bankAccountCount': bankAccountCount,
    };
  }
}
