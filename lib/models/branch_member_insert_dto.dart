class BranchMemberInsertDTO {
  final String branchId;
  final String businessId;
  final String userId;
  final int role;

  const BranchMemberInsertDTO({
    required this.branchId,
    required this.businessId,
    required this.userId,
    required this.role,
  });

  factory BranchMemberInsertDTO.fromJson(Map<String, dynamic> json) {
    return BranchMemberInsertDTO(
      branchId: json['branchId'] ?? '',
      businessId: json['businessId'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['branchId'] = branchId;
    data['businessId'] = businessId;
    data['userId'] = userId;
    data['role'] = role;
    return data;
  }
}
