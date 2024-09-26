class NearestTransDTO {
  String transactionId;
  String amount;
  String transType;
  int status;
  int type;
  int time;
  int timePaid;

  NearestTransDTO({
    required this.transactionId,
    required this.amount,
    required this.transType,
    required this.status,
    required this.type,
    required this.time,
    required this.timePaid,
  });

  factory NearestTransDTO.fromJson(Map<String, dynamic> json) {
    return NearestTransDTO(
      transactionId: json['transactionId'],
      amount: json['amount'],
      transType: json['transType'],
      status: json['status'],
      type: json['type'],
      time: json['time'],
      timePaid: json['timePaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'transType': transType,
      'status': status,
      'type': type,
      'time': time,
      'timePaid': timePaid,
    };
  }
}
