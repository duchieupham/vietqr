class TopUpSuccessDTO {
  final String notificationId;

  final String amount;
  final String billNumber;
  final String transWalletId;
  final String notificationType;
  final String time;

  const TopUpSuccessDTO(
      {this.amount = '',
      this.billNumber = '',
      this.notificationId = '',
      this.notificationType = '',
      this.transWalletId = '',
      this.time = ''});

  factory TopUpSuccessDTO.fromJson(Map<String, dynamic> json) {
    return TopUpSuccessDTO(
      amount: json['amount'] ?? '',
      billNumber: json['billNumber'] ?? '',
      notificationId: json['notificationId'] ?? '',
      notificationType: json['notificationType'] ?? '',
      transWalletId: json['transWalletId'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
