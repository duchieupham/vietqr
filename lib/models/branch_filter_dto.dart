class BranchFilterDTO {
  final String branchId;
  final String branchName;

  const BranchFilterDTO({
    required this.branchId,
    required this.branchName,
  });

  factory BranchFilterDTO.fromJson(Map<String, dynamic> json) {
    return BranchFilterDTO(
      branchId: json['branchId'],
      branchName: json['branchName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    return data;
  }
}
