import 'dart:io';

class BusinessInformationInsertDTO {
  final String userId;
  final String name;
  final String address;
  final String taxCode;
  final File? image;
  final File? coverImage;
  final List<MemberBusinessInsertDTO> members;
  final List<BranchBusinessInsertDTO> branchs;

  const BusinessInformationInsertDTO({
    required this.userId,
    required this.name,
    required this.address,
    required this.taxCode,
    required this.image,
    required this.coverImage,
    required this.members,
    required this.branchs,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['name'] = name;
    data['address'] = address;
    data['taxCode'] = taxCode;
    if (members.isNotEmpty) {
      for (int i = 0; i < members.length; i++) {
        data['members[$i].userId'] = members[i].userId;
        data['members[$i].role'] = members[i].role;
      }
    }
    if (branchs.isNotEmpty) {
      for (int i = 0; i < branchs.length; i++) {
        data['branchs[$i].name'] = branchs[i].name;
        data['branchs[$i].address'] = branchs[i].address;
      }
    }
    return data;
  }
}

class MemberBusinessInsertDTO {
  final String userId;
  final String role;

  const MemberBusinessInsertDTO({
    required this.userId,
    required this.role,
  });
}

class BranchBusinessInsertDTO {
  final String name;
  final String address;

  const BranchBusinessInsertDTO({
    required this.name,
    required this.address,
  });
}
