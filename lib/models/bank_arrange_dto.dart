class BankArrangeDTO {
  String bankId;
  int index;

  BankArrangeDTO({
    required this.bankId,
    required this.index,
  });

  factory BankArrangeDTO.fromJson(Map<String, dynamic> json) {
    return BankArrangeDTO(
      bankId: json['bankId'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'index': index,
    };
  }
}
