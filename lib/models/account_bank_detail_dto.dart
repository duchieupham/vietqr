class AccountBankDetailDTO {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int type;
  final String caiValue;
  final String userId;
  final String bankTypeId;
  final int bankTypeStatus;
  final String nationalId;
  final String qrCode;
  final String phoneAuthenticated;
  final List<BusinessDetails> businessDetails;
  final List<Transactions> transactions;
  final bool authenticated;

  AccountBankDetailDTO(
      {required this.id,
      required this.bankAccount,
      required this.userBankName,
      required this.bankCode,
      required this.bankName,
      required this.imgId,
      required this.type,
      required this.caiValue,
      required this.userId,
      required this.bankTypeId,
      required this.bankTypeStatus,
      required this.nationalId,
      required this.qrCode,
      required this.phoneAuthenticated,
      required this.businessDetails,
      required this.transactions,
      required this.authenticated});

  factory AccountBankDetailDTO.fromJson(Map<String, dynamic> json) {
    final List<BusinessDetails> businessDetails = [];
    final List<Transactions> transactions = [];
    if (json['businessDetails'] != null) {
      json['businessDetails'].forEach((v) {
        businessDetails.add(BusinessDetails.fromJson(v));
      });
    }
    if (json['transactions'] != null) {
      json['transactions'].forEach((v) {
        transactions.add(Transactions.fromJson(v));
      });
    }
    return AccountBankDetailDTO(
      id: json['id'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      type: json['type'] ?? 0,
      caiValue: json['caiValue'] ?? '',
      userId: json['userId'] ?? '',
      bankTypeId: json['bankTypeId'] ?? '',
      bankTypeStatus: json['bankTypeStatus'] ?? 0,
      nationalId: json['nationalId'] ?? '',
      qrCode: json['qrCode'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      businessDetails: businessDetails,
      transactions: transactions,
      authenticated: json['authenticated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['type'] = type;
    data['nationalId'] = nationalId;
    data['qrCode'] = qrCode;
    data['phoneAuthenticated'] = phoneAuthenticated;

    data['businessDetails'] = (businessDetails.isEmpty)
        ? []
        : businessDetails.map((v) => v.toJson()).toList();

    data['transactions'] = (transactions.isEmpty)
        ? []
        : transactions.map((v) => v.toJson()).toList();

    data['authenticated'] = authenticated;
    return data;
  }
}

class BusinessDetails {
  final String businessId;
  final String businessName;
  final String imgId;
  final String coverImgId;
  final List<BranchDetails> branchDetails;

  BusinessDetails({
    required this.businessId,
    required this.businessName,
    required this.imgId,
    required this.coverImgId,
    required this.branchDetails,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    final List<BranchDetails> branchDetails = [];
    if (json['branchDetails'] != null) {
      json['branchDetails'].forEach((v) {
        branchDetails.add(BranchDetails.fromJson(v));
      });
    }
    return BusinessDetails(
      businessId: json['businessId'],
      businessName: json['businessName'],
      imgId: json['imgId'],
      coverImgId: json['coverImgId'],
      branchDetails: branchDetails,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['businessId'] = businessId;
    data['businessName'] = businessName;
    data['imgId'] = imgId;
    data['coverImgId'] = coverImgId;
    data['branchDetails'] = (branchDetails.isEmpty)
        ? []
        : branchDetails.map((v) => v.toJson()).toList();
    return data;
  }
}

class BranchDetails {
  final String branchId;
  final String branchName;
  final String code;
  final String address;

  BranchDetails({
    required this.branchId,
    required this.branchName,
    required this.code,
    required this.address,
  });

  factory BranchDetails.fromJson(Map<String, dynamic> json) {
    return BranchDetails(
      branchId: json['branchId'],
      branchName: json['branchName'],
      code: json['code'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['code'] = code;
    data['address'] = address;
    return data;
  }
}

class Transactions {
  final String transactionId;
  final String bankAccount;
  final String bankId;
  final String amount;
  final String content;
  final int status;
  final int time;
  final int type;
  final String transType;

  Transactions({
    required this.transactionId,
    required this.bankAccount,
    required this.bankId,
    required this.amount,
    required this.content,
    required this.status,
    required this.time,
    required this.type,
    required this.transType,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      transactionId: json['transactionId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankId: json['bankId'] ?? '',
      amount: json['amount'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 0,
      time: json['time'] ?? 0,
      type: json['type'] ?? 0,
      transType: json['transType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['transactionId'] = transactionId;
    data['bankAccount'] = bankAccount;
    data['bankId'] = bankId;
    data['amount'] = amount;
    data['content'] = content;
    data['status'] = status;
    data['time'] = time;
    data['type'] = type;
    data['transType'] = transType;
    return data;
  }
}
