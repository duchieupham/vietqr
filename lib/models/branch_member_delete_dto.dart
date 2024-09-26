class BranchMemberDeleteDTO {
  final String userId;
  final String businessId;

  const BranchMemberDeleteDTO({
    required this.userId,
    required this.businessId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['businessId'] = businessId;
    return data;
  }
}
