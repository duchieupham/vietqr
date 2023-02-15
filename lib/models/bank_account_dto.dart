class BankAccountDTO {
  final String id;
  final String userId;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int bankStatus;
  final int role;

  const BankAccountDTO(
      {required this.id,
      required this.userId,
      required this.bankAccount,
      required this.userBankName,
      required this.bankCode,
      required this.bankName,
      required this.imgId,
      required this.bankStatus,
      required this.role});

  factory BankAccountDTO.fromJson(Map<String, dynamic> json) {
    return BankAccountDTO(
      id: json['id'],
      userId: json['userId'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      imgId: json['imgId'],
      bankStatus: json['bankStatus'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['bankStatus'] = bankStatus;
    data['role'] = role;
    return data;
  }
}
