class IntroduceDTO {
  final String? amount;
  final String? point;
  final String? sharingCode;
  final String? walletId;
  final String? enableService;

  IntroduceDTO({
    this.amount,
    this.point,
    this.sharingCode,
    this.walletId,
    this.enableService,
  });

  factory IntroduceDTO.fromJson(Map<String, dynamic> json) {
    return IntroduceDTO(
      amount: json['amount'] ?? '',
      point: json['point'] ?? false,
      sharingCode: json['sharingCode'] ?? '',
      walletId: json['walletId'] ?? '',
      enableService: json['enableService'] ?? '',
    );
  }
}
