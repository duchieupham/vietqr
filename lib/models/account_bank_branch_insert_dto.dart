class AccountBankBranchInsertDTO {
  final String userId;
  final String bankId;
  final String businessId;
  final String branchId;

  const AccountBankBranchInsertDTO({
    required this.userId,
    required this.bankId,
    required this.businessId,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['bankId'] = bankId;
    data['businessId'] = businessId;
    data['branchId'] = branchId;
    return data;
  }
}
