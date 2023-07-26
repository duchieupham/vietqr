class ResponseTopUpDTO {
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;
  final String amount;
  final String content;
  final String qrCode;
  final String imgId;
  final int existing;
  final String transactionId;

  const ResponseTopUpDTO(
      {this.imgId = '',
      this.bankAccount = '',
      this.bankName = '',
      this.amount = '',
      this.bankCode = '',
      this.content = '',
      this.userBankName = '',
      this.transactionId = '',
      this.existing = 0,
      this.qrCode = ''});

  factory ResponseTopUpDTO.fromJson(Map<String, dynamic> json) {
    return ResponseTopUpDTO(
      imgId: json['imgId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankName: json['bankName'] ?? '',
      amount: json['amount'] ?? '',
      bankCode: json['bankCode'] ?? '',
      content: json['content'] ?? '',
      userBankName: json['userBankName'] ?? '',
      transactionId: json['transactionId'] ?? '',
      existing: json['existing'] ?? 0,
      qrCode: json['qrCode'] ?? '',
    );
  }
}
