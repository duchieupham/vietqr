class VietQRVaWidgetDTO {
  final String qrCode;
  final String bankAccount;
  final String userBankName;
  final String bankName;
  final String bankShortName;
  final String imgId;
  final String amount;
  final String content;

  const VietQRVaWidgetDTO({
    required this.qrCode,
    required this.bankAccount,
    required this.userBankName,
    required this.bankName,
    required this.bankShortName,
    required this.imgId,
    required this.amount,
    required this.content,
  });
}
