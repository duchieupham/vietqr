class BusinessDetailDTO {
  final String id;
  final String name;
  final String address;
  final String code;
  final String imgId;
  final String coverImgId;
  final String taxCode;
  final int userRole;
  final List<BusinessManagerDTO> managers;
  final List<BusinessBranchDTO> branchs;
  final List<BusinessTransactionDTO> transactions;
  final bool active;

  const BusinessDetailDTO({
    required this.id,
    required this.name,
    required this.address,
    required this.code,
    required this.imgId,
    required this.coverImgId,
    required this.taxCode,
    required this.userRole,
    required this.managers,
    required this.branchs,
    required this.transactions,
    required this.active,
  });

  factory BusinessDetailDTO.fromJson(Map<String, dynamic> json) {
    List<BusinessManagerDTO> managers = [];
    if (json['managers'] != null) {
      json['managers'].forEach((v) {
        managers.add(BusinessManagerDTO.fromJson(v));
      });
    }
    List<BusinessBranchDTO> branchs = [];
    if (json['branchs'] != null) {
      json['branchs'].forEach((v) {
        branchs.add(BusinessBranchDTO.fromJson(v));
      });
    }
    List<BusinessTransactionDTO> transactions = [];
    if (json['transactions'] != null) {
      json['transactions'].forEach((v) {
        transactions.add(BusinessTransactionDTO.fromJson(v));
      });
    }
    return BusinessDetailDTO(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      code: json['code'] ?? '',
      imgId: json['imgId'] ?? '',
      coverImgId: json['coverImgId'] ?? '',
      taxCode: json['taxCode'] ?? '',
      userRole: json['userRole'] ?? json['role'] ?? 0,
      managers: managers,
      branchs: branchs,
      transactions: transactions,
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['code'] = code;
    data['imgId'] = imgId;
    data['coverImgId'] = coverImgId;
    data['taxCode'] = taxCode;
    data['role'] = userRole;
    data['managers'] =
        (managers.isEmpty) ? [] : managers.map((v) => v.toJson()).toList();
    data['branchs'] =
        (branchs.isEmpty) ? [] : branchs.map((v) => v.toJson()).toList();
    data['transactions'] = (transactions.isEmpty)
        ? []
        : transactions.map((v) => v.toJson()).toList();
    data['active'] = active;
    return data;
  }
}

class BusinessManagerDTO {
  final String userId;
  final String imgId;
  final int role;
  final String phoneNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthDate;
  final int gender;
  final String email;
  final String id;
  final String address;

  const BusinessManagerDTO(
      {required this.userId,
      required this.imgId,
      required this.role,
      required this.phoneNo,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.birthDate,
      required this.gender,
      required this.email,
      required this.id,
      required this.address});

  factory BusinessManagerDTO.fromJson(Map<String, dynamic> json) {
    return BusinessManagerDTO(
      userId: json['userId'] ?? '',
      imgId: json['imgId'] ?? '',
      role: json['role'] ?? 0,
      phoneNo: json['phoneNo'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? 0,
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['imgId'] = imgId;
    data['role'] = role;
    data['phoneNo'] = phoneNo;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    data['email'] = email;
    data['id'] = id;
    data['address'] = address;
    return data;
  }
}

class BusinessBranchDTO {
  final String id;
  final String code;
  final String name;
  final String address;
  final int totalMember;
  final BusinessManagerDTO manager;
  final List<BusinessBankDTO> banks;

  const BusinessBranchDTO({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.totalMember,
    required this.manager,
    required this.banks,
  });

  factory BusinessBranchDTO.fromJson(Map<String, dynamic> json) {
    BusinessManagerDTO manager = const BusinessManagerDTO(
      userId: '',
      imgId: '',
      role: 0,
      phoneNo: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      email: '',
      id: '',
      address: '',
    );
    if (json['manager'] != null) {
      manager = BusinessManagerDTO.fromJson(json['manager']);
    }
    List<BusinessBankDTO> banks = [];
    if (json['banks'] != null) {
      json['banks'].forEach((v) {
        banks.add(BusinessBankDTO.fromJson(v));
      });
    }
    return BusinessBranchDTO(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      totalMember: json['totalMember'] ?? 0,
      manager: manager,
      banks: banks,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    data['totalMember'] = totalMember;
    data['manager'] = manager.toJson();
    data['banks'] =
        (banks.isEmpty) ? [] : banks.map((v) => v.toJson()).toList();
    return data;
  }
}

class BusinessBankDTO {
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final bool authenticated;
  final String id;

  const BusinessBankDTO({
    required this.bankAccount,
    required this.userBankName,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.authenticated,
    required this.id,
  });

  factory BusinessBankDTO.fromJson(Map<String, dynamic> json) {
    return BusinessBankDTO(
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      authenticated: json['authenticated'] ?? false,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['authenticated'] = authenticated;
    data['id'] = id;
    return data;
  }
}

class BusinessTransactionDTO {
  final String bankAccount;
  final String amount;
  final int time;
  final int status;
  final int type;
  final String content;
  final String transactionId;
  final String tranStype;

  const BusinessTransactionDTO({
    required this.bankAccount,
    required this.amount,
    required this.time,
    required this.status,
    required this.type,
    required this.content,
    required this.transactionId,
    required this.tranStype,
  });

  factory BusinessTransactionDTO.fromJson(Map<String, dynamic> json) {
    return BusinessTransactionDTO(
      bankAccount: json['bankAccount'] ?? '',
      amount: json['amount'] ?? '',
      time: json['time'] ?? 0,
      status: json['status'] ?? 0,
      type: json['type'] ?? 0,
      content: json['content'] ?? '',
      transactionId: json['transactionId'] ?? '',
      tranStype: json['transType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['amount'] = amount;
    data['time'] = time;
    data['status'] = status;
    data['type'] = type;
    data['content'] = content;
    data['transactionId'] = transactionId;
    data['transType'] = tranStype;
    return data;
  }
}
