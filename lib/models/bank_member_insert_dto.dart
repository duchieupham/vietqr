class BankMemberInsertDTO {
  final String bankId;
  final String userId;
  final int role;
  final String phoneNo;

  const BankMemberInsertDTO({
    required this.bankId,
    required this.userId,
    required this.role,
    required this.phoneNo,
  });

  factory BankMemberInsertDTO.fromJson(Map<String, dynamic> json) {
    return BankMemberInsertDTO(
      bankId: json['bankId'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? 0,
      phoneNo: json['phoneNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['role'] = role;
    data['phoneNo'] = phoneNo;
    return data;
  }
}
