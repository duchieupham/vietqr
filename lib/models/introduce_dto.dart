class IntroduceDTO {
  final String? amount;
  final String? point;
  final String? sharingCode;
  final String? walletId;
  final bool? enableService;

  IntroduceDTO({
    this.amount,
    this.point,
    this.sharingCode,
    this.walletId,
    this.enableService,
  });

  String get sharingCodeLink =>
      'https://vietqr.vn/register?share_code=${sharingCode ?? ''}';

  factory IntroduceDTO.fromJson(Map<String, dynamic> json) {
    return IntroduceDTO(
      amount: json['amount'] ?? '',
      point: json['point'] ?? '',
      sharingCode: json['sharingCode'] ?? '',
      walletId: json['walletId'] ?? '',
      enableService: json['enableService'] ?? false,
    );
  }
}
