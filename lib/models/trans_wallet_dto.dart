class TransWalletDto {
  final String amount;
  final String transType;
  final int paymentType;
  final int paymentMethod;
  final String billNumber;
  final int timeCreated;
  final int timePaid;
  final int status;
  final String id;

  TransWalletDto(
      {this.status = 0,
      this.id = '',
      this.paymentType = 0,
      this.billNumber = '',
      this.amount = '',
      this.paymentMethod = 0,
      this.timeCreated = 0,
      this.timePaid = 0,
      this.transType = ''});

  factory TransWalletDto.fromJson(Map<String, dynamic> json) => TransWalletDto(
        status: json["status"] ?? 0,
        id: json["id"] ?? '',
        paymentType: json["paymentType"] ?? 0,
        billNumber: json["billNumber"] ?? '',
        paymentMethod: json["paymentMethod"] ?? 0,
        timeCreated: json["timeCreated"] ?? 0,
        timePaid: json["timePaid"] ?? 0,
        transType: json["transType"] ?? '',
        amount: json["amount"] ?? '',
      );
}
