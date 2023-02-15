class TransactionBankDTO {
  final String referenceNumber;
  final String amount;
  final int transactionDate;
  final String paymentDetail;
  final String accountNumber;
  final String reciprocalAccount;
  final String reciprocalName;
  final String currency;
  final String transactionStatus;

  TransactionBankDTO(
      {required this.referenceNumber,
      required this.amount,
      required this.transactionDate,
      required this.paymentDetail,
      required this.accountNumber,
      required this.reciprocalAccount,
      required this.reciprocalName,
      required this.currency,
      required this.transactionStatus});

  factory TransactionBankDTO.fromJson(Map<String, dynamic> json) {
    return TransactionBankDTO(
      referenceNumber: json['referenceNumber'],
      amount: json['amount'],
      transactionDate: json['transactionDate'],
      paymentDetail: json['paymentDetail'],
      accountNumber: json['accountNumber'],
      reciprocalAccount: json['reciprocalAccount'],
      reciprocalName: json['reciprocalName'],
      currency: json['currency'],
      transactionStatus: json['transactionStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['referenceNumber'] = referenceNumber;
    data['amount'] = amount;
    data['transactionDate'] = transactionDate;
    data['paymentDetail'] = paymentDetail;
    data['accountNumber'] = accountNumber;
    data['reciprocalAccount'] = reciprocalAccount;
    data['reciprocalName'] = reciprocalName;
    data['currency'] = currency;
    data['transactionStatus'] = transactionStatus;
    return data;
  }
}
