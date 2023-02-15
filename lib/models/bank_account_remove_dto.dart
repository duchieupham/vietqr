class BankAccountRemoveDTO {
  final String bankId;
  final String userId;
  final int role;

  const BankAccountRemoveDTO(
      {required this.bankId, required this.userId, required this.role});

  factory BankAccountRemoveDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountRemoveDTO(
      bankId: json['bankId'],
      userId: json['userId'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['role'] = role;
    return data;
  }
}
