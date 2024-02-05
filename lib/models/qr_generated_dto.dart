class QRGeneratedDTO {
  String? bankId;
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;
  final String amount;
  final String content;
  String qrCode;
  String imgId;
  final int? existing;
  final String? transactionId;
  final String? transactionRefId;
  final String qrLink;
  final String terminalCode;

  //
  final String? bankTypeId;
  final bool isNaviAddBank;
  final String email;
  final int? type;
  final String phone;

  QRGeneratedDTO({
    this.bankId,
    required this.bankCode,
    required this.bankName,
    required this.bankAccount,
    required this.userBankName,
    this.amount = '',
    this.content = '',
    this.qrCode = '',
    this.imgId = '',
    this.transactionId,
    this.existing,
    this.bankTypeId,
    this.email = '',
    this.type,
    this.phone = '',
    this.isNaviAddBank = false,
    this.qrLink = '',
    this.terminalCode = '',
    this.transactionRefId = '',
  });

  setBankId(value) {
    bankId = value;
  }

  factory QRGeneratedDTO.fromJson(Map<String, dynamic> json) {
    return QRGeneratedDTO(
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      amount: json['amount'],
      content: json['content'],
      qrCode: json['qrCode'],
      imgId: json['imgId'],
      transactionId: json['transactionId'],
      transactionRefId: json['transactionRefId'],
      existing: json['existing'],
      qrLink: json['qrLink'],
      terminalCode: json['terminalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['amount'] = amount;
    data['content'] = content;
    data['qrCode'] = qrCode;
    data['imgId'] = imgId;
    data['transactionId'] = transactionId;
    data['existing'] = existing;
    return data;
  }
}
