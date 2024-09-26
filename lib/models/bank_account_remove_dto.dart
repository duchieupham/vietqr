class BankAccountRemoveDTO {
  final String bankId;
  final int type;
  final bool isAuthenticated;

  const BankAccountRemoveDTO(
      {required this.bankId,
      required this.type,
      required this.isAuthenticated});

  factory BankAccountRemoveDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountRemoveDTO(
      bankId: json['bankId'],
      type: json['type'],
      isAuthenticated: json['authenticated'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['type'] = type;
    data['authenticated'] = isAuthenticated;
    return data;
  }
}
