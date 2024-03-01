class IntroduceDTO {
  String amount;
  String point;
  String sharingCode;
  String walletId;
  bool enableService;

  IntroduceDTO({
    this.amount = '',
    this.point = '',
    this.sharingCode = '',
    this.walletId = '',
    this.enableService = false,
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['point'] = point;
    data['sharingCode'] = sharingCode;
    data['walletId'] = walletId;
    data['enableService'] = enableService;
    return data;
  }
}
