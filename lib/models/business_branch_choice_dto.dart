class BusinessBranchChoiceDTO {
  final String image;
  final String coverImage;
  final String name;
  final List<BranchChoiceDTO> branchs;

  const BusinessBranchChoiceDTO({
    required this.image,
    required this.coverImage,
    required this.name,
    required this.branchs,
  });

  factory BusinessBranchChoiceDTO.fromJson(Map<String, dynamic> json) {
    List<BranchChoiceDTO> branchChoices = [];
    if (json['branchs'] != null) {
      json['branchs'].forEach((v) {
        branchChoices.add(BranchChoiceDTO.fromJson(v));
      });
    }
    return BusinessBranchChoiceDTO(
      image: json['image'],
      coverImage: json['coverImage'],
      name: json['name'],
      branchs: branchChoices,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['image'] = image;
    data['coverImage'] = coverImage;
    data['name'] = name;
    if (branchs.isNotEmpty) {
      data['branchs'] = branchs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BranchChoiceDTO {
  final String branchId;
  final String name;
  final String address;

  const BranchChoiceDTO({
    required this.branchId,
    required this.name,
    required this.address,
  });

  factory BranchChoiceDTO.fromJson(Map<String, dynamic> json) {
    return BranchChoiceDTO(
      branchId: json['branchId'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['branchId'] = branchId;
    data['name'] = name;
    data['address'] = address;
    return data;
  }
}
