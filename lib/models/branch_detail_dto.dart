import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/business_member_dto.dart';

class BranchDetailDTO {
  final String branchId;
  final String branchCode;
  final String branchName;
  final String address;
  final int totalMember;
  final BusinessMemberDTO manager;
  final BankAccountDTO bankAccount;

  const BranchDetailDTO({
    required this.branchId,
    required this.branchCode,
    required this.branchName,
    required this.address,
    required this.totalMember,
    required this.manager,
    required this.bankAccount,
  });

  factory BranchDetailDTO.fromJson(Map<String, dynamic> json) {
    return BranchDetailDTO(
      branchId: json['branchId'] ?? '',
      branchCode: json['branchCode'] ?? '',
      branchName: json['branchName'] ?? '',
      address: json['address'] ?? '',
      totalMember: json['totalMember'] ?? 0,
      manager: BusinessMemberDTO.fromJson(
        json['manager'],
      ),
      bankAccount: BankAccountDTO.fromJson(
        json['bankAccount'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['branchId'] = branchId;
    data['branchCode'] = branchCode;
    data['branchName'] = branchName;
    data['address'] = address;
    data['totalMember'] = totalMember;
    data['manager'] = manager.toJson();
    data['bankAccount'] = bankAccount.toJson();
    return data;
  }
}
