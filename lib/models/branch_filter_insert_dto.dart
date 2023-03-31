class BranchFilterInsertDTO {
  final String userId;
  final int role;
  final String businessId;

  const BranchFilterInsertDTO({
    required this.userId,
    required this.role,
    required this.businessId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['role'] = role;
    data['businessId'] = businessId;
    return data;
  }
}
