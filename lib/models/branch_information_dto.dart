class BranchInformationDTO {
  final String id;
  final String businessId;
  final String code;
  final String name;
  final String address;
  final bool isActive;

  const BranchInformationDTO({
    required this.id,
    required this.businessId,
    required this.code,
    required this.name,
    required this.address,
    required this.isActive,
  });

  factory BranchInformationDTO.fromJson(Map<String, dynamic> json) {
    return BranchInformationDTO(
      id: json['id'] ?? '',
      businessId: json['businessId'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
