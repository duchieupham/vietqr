import 'package:vierqr/models/related_transaction_receive_dto.dart';

class BusinessItemDTO {
  final String businessId;
  final String code;
  final int role;
  final String imgId;
  final String coverImgId;
  final String name;
  final String address;
  final String taxCode;
  final List<RelatedTransactionReceiveDTO> transactions;
  final List<BranchDTO> branchs;
  final List<BankAccountInBusiness> bankAccounts;

  final int totalMember;
  final int totalBranch;

  const BusinessItemDTO({
    required this.businessId,
    required this.code,
    required this.role,
    required this.imgId,
    required this.coverImgId,
    required this.name,
    required this.address,
    required this.taxCode,
    required this.transactions,
    required this.totalMember,
    required this.totalBranch,
    required this.branchs,
    required this.bankAccounts,
  });

  factory BusinessItemDTO.fromJson(Map<String, dynamic> json) {
    List<RelatedTransactionReceiveDTO> transactions = [];
    if (json['transactions'] != null) {
      json['transactions'].forEach((v) {
        transactions.add(RelatedTransactionReceiveDTO.fromJson(v));
      });
    }

    List<BranchDTO> branchs = [];
    if (json['branchs'] != null) {
      json['branchs'].forEach((v) {
        branchs.add(BranchDTO.fromJson(v));
      });
    }

    List<BankAccountInBusiness> bankAccounts = [];
    if (json['bankAccounts'] != null) {
      json['bankAccounts'].forEach((v) {
        bankAccounts.add(BankAccountInBusiness.fromJson(v));
      });
    }

    return BusinessItemDTO(
      businessId: json['businessId'] ?? '',
      code: json['code'] ?? '',
      role: json['role'] ?? 0,
      imgId: json['imgId'] ?? '',
      coverImgId: json['coverImgId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      taxCode: json['taxCode'] ?? '',
      transactions: transactions,
      totalMember: json['totalMember'] ?? 0,
      totalBranch: json['totalBranch'] ?? 0,
      branchs: branchs,
      bankAccounts: bankAccounts,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['businessId'] = businessId;
    data['code'] = code;
    data['role'] = role;
    data['imgId'] = imgId;
    data['coverImgId'] = coverImgId;
    data['name'] = name;
    data['address'] = address;
    data['taxCode'] = taxCode;
    data['transactions'] = transactions;
    data['totalMember'] = totalMember;
    data['totalBranch'] = totalBranch;
    return data;
  }
}

class BranchDTO {
  final String branchId;
  final int connected;

  BranchDTO({required this.branchId, required this.connected});

  factory BranchDTO.fromJson(Map<String, dynamic> json) {
    return BranchDTO(
      branchId: json['branchId'] ?? '',
      connected: json['connected'] ?? 0,
    );
  }
}

class BankAccountInBusiness {
  String bankId;
  String bankAccount;
  String userBankName;
  String bankCode;
  String bankName;
  String imageId;
  int bankType;
  bool authenticated;

  BankAccountInBusiness(
      {this.userBankName = '',
      this.bankCode = '',
      this.bankName = '',
      this.bankAccount = '',
      this.bankId = '',
      this.bankType = 0,
      this.authenticated = false,
      this.imageId = ''});
  factory BankAccountInBusiness.fromJson(Map<String, dynamic> json) {
    return BankAccountInBusiness(
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankId: json['bankId'] ?? '',
      bankType: json['bankType'] ?? 0,
      authenticated: json['authenticated'] ?? false,
      imageId: json['imgId'] ?? '',
    );
  }
}
