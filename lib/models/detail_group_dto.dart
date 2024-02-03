import 'package:vierqr/models/terminal_response_dto.dart';

class GroupDetailDTO {
  String id;
  String name;
  String address;
  String code;
  String userId;
  bool isDefault;
  int totalMember;
  List<TerminalBankResponseDTO> banks;
  List<AccountMemberDTO> members;
  GroupDetailDTO({
    this.id = '',
    this.name = '',
    this.address = '',
    this.code = '',
    this.userId = '',
    this.isDefault = false,
    this.totalMember = 0,
    required this.banks,
    required this.members,
  });

  factory GroupDetailDTO.fromJson(Map<String, dynamic> json) {
    List<AccountMemberDTO> listMember = json['members'] != null
        ? json['members']
            .map<AccountMemberDTO>((json) => AccountMemberDTO.fromJson(json))
            .toList()
        : [];
    listMember.sort((a, b) {
      if (b.isOwner) {
        return 1;
      }
      return -1;
    });
    return GroupDetailDTO(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      address: json["address"] ?? '',
      code: json["code"] ?? '',
      userId: json["userId"] ?? '',
      isDefault: json["isDefault"] ?? false,
      totalMember: json["totalMember"] ?? 0,
      banks: json['banks'] != null
          ? json['banks']
              .map<TerminalBankResponseDTO>(
                  (json) => TerminalBankResponseDTO.fromJson(json))
              .toList()
          : [],
      members: listMember,
    );
  }
}

class AccountMemberDTO {
  final String id;
  final String phoneNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String imgId;
  final bool isOwner;
  final int bankTypeStatus;

  AccountMemberDTO({
    this.id = '',
    this.phoneNo = '',
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.imgId = '',
    this.isOwner = false,
    this.bankTypeStatus = 0,
  });

  String fullName() {
    return '${firstName} ${middleName} ${lastName}';
  }

  factory AccountMemberDTO.fromJson(Map<String, dynamic> json) =>
      AccountMemberDTO(
        id: json["id"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
        firstName: json["firstName"] ?? '',
        middleName: json["middleName"] ?? '',
        lastName: json["lastName"] ?? '',
        imgId: json["imgId"] ?? '',
        isOwner: json["isOwner"] ?? false,
        bankTypeStatus: json["bankTypeStatus"] ?? 0,
      );
}
