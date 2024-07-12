class LarkDTO {
  String larkId;
  String webhook;
  int bankAccountCount;

  LarkDTO({
    required this.larkId,
    required this.webhook,
    required this.bankAccountCount,
  });

  factory LarkDTO.fromJson(Map<String, dynamic> json) {
    return LarkDTO(
      larkId: json['larkId'],
      webhook: json['webhook'],
      bankAccountCount: json['bankAccountCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'larkId': larkId,
      'webhook': webhook,
      'bankAccountCount': bankAccountCount,
    };
  }
}
