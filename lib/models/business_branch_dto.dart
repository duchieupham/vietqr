class BusinessAvailDTO {
  final String? businessId;
  final String? image;
  final String? coverImage;
  final String? name;
  final List<BranchModel> branchs;

  BusinessAvailDTO({
    this.businessId,
    this.image,
    this.coverImage,
    this.name,
    required this.branchs,
  });

  factory BusinessAvailDTO.fromJson(Map<String, dynamic> json) {
    List<BranchModel> branchChoices = [];
    if (json['branchs'] != null) {
      json['branchs'].forEach((v) {
        branchChoices.add(BranchModel.fromJson(v));
      });
    }
    return BusinessAvailDTO(
      businessId: json['businessId'],
      image: json['image'],
      coverImage: json['coverImage'],
      name: json['name'],
      branchs: branchChoices,
    );
  }
}

class BranchModel {
  final String? branchId;
  final String? name;
  final String? address;

  BranchModel({this.branchId, this.name, this.address});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'],
      name: json['name'],
      address: json['address'],
    );
  }
}
