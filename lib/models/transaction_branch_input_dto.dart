class TransactionBranchInputDTO {
  final String businessId;
  final String branchId;
  final int offset;

  const TransactionBranchInputDTO({
    required this.businessId,
    required this.branchId,
    required this.offset,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['businessId'] = businessId;
    data['branchId'] = branchId;
    data['offset'] = offset;
    return data;
  }
}
