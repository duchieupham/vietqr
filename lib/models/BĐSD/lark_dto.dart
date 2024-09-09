class LarkDTO {
  String larkId;
  String webhook;
  int bankAccountCount;
  String name;

  LarkDTO({
    required this.larkId,
    required this.webhook,
    required this.bankAccountCount,
    required this.name,
  });

  factory LarkDTO.fromJson(Map<String, dynamic> json) {
    return LarkDTO(
      larkId: json['larkId'],
      webhook: json['webhook'],
      bankAccountCount: json['bankAccountCount'],
      name: json['name'] ?? json['webhook'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'larkId': larkId,
      'webhook': webhook,
      'bankAccountCount': bankAccountCount,
      'name': name
    };
  }
}
