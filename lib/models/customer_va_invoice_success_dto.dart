class CustomerVaInvoiceSuccessDTO {
// receive data: {timePaid: 1713154463, amount: 7096089,
//billId: eWJzAysAts, customerId: BCMC00001,
//notificationId: 7c6e5fa8-49b1-4671-a077-ce3ef8e16862,
//notificationType: N14}

  final String amount;
  final String billId;
  final String customerId;
  final String notificationId;
  final String notificationType;
  final int timePaid;

  const CustomerVaInvoiceSuccessDTO({
    required this.amount,
    required this.billId,
    required this.customerId,
    required this.notificationId,
    required this.notificationType,
    required this.timePaid,
  });

  factory CustomerVaInvoiceSuccessDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaInvoiceSuccessDTO(
      amount: json['amount'],
      billId: json['billId'],
      customerId: json['customerId'],
      notificationId: json['notificationId'],
      notificationType: json['notificationType'],
      timePaid: int.tryParse(json['timePaid']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['billId'] = billId;
    data['customerId'] = customerId;
    data['notificationId'] = notificationId;
    data['notificationType'] = notificationType;
    data['timePaid'] = timePaid;
    return data;
  }
}
