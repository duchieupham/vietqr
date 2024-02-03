class TerminalDto {
  final int totalTerminals;
  final String userId;
  final List<TerminalResponseDTO> terminals;

  TerminalDto({
    this.totalTerminals = 0,
    this.userId = '',
    required this.terminals,
  });

  factory TerminalDto.fromJson(Map<String, dynamic> json) {
    return TerminalDto(
      totalTerminals: json['totalTerminals'] ?? 0,
      userId: json['userId'] ?? '',
      terminals: json['terminals'] != null
          ? json['terminals']
              .map<TerminalResponseDTO>(
                  (json) => TerminalResponseDTO.fromJson(json))
              .toList()
          : [],
    );
  }
}

class TerminalResponseDTO {
  final String id;
  final int totalMembers;
  final String name;
  final String address;
  final String code;

  final bool isDefault;
  final String userId;
  final List<TerminalBankResponseDTO> banks;

  TerminalResponseDTO({
    this.id = '',
    this.totalMembers = 0,
    this.name = '',
    this.address = '',
    this.code = '',
    this.isDefault = false,
    this.userId = '',
    required this.banks,
  });

  factory TerminalResponseDTO.fromJson(Map<String, dynamic> json) {
    return TerminalResponseDTO(
      id: json['id'] ?? '',
      totalMembers: json['totalMembers'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      code: json['code'] ?? '',
      isDefault: json['isDefault'] ?? false,
      userId: json['userId'] ?? '',
      banks: json['banks'] != null
          ? json['banks']
              .map<TerminalBankResponseDTO>(
                  (json) => TerminalBankResponseDTO.fromJson(json))
              .toList()
          : [],
    );
  }
}

class TerminalBankResponseDTO {
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankShortName;

  final String bankName;
  final String imgId;
  final String terminalId;
  final String userId;
  final int totalbankShares;
  final List<BankShareResponseDTO> bankShares;

  TerminalBankResponseDTO({
    this.bankId = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankCode = '',
    this.bankShortName = '',
    this.bankName = '',
    this.imgId = '',
    required this.bankShares,
    this.userId = '',
    this.terminalId = '',
    this.totalbankShares = 0,
  });

  factory TerminalBankResponseDTO.fromJson(Map<String, dynamic> json) {
    return TerminalBankResponseDTO(
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      userId: json['userId'] ?? '',
      terminalId: json['terminalId'] ?? '',
      totalbankShares: json['totalbankShares'] ?? 0,
      bankShares: json['bankShares'] != null
          ? json['bankShares']
              .map<BankShareResponseDTO>(
                  (json) => BankShareResponseDTO.fromJson(json))
              .toList()
          : [],
    );
  }
}

class BankShareResponseDTO {
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankShortName;

  final String bankName;
  final String imgId;
  final List<TerminalShareDTO> terminals;

  BankShareResponseDTO({
    this.bankId = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankCode = '',
    this.bankShortName = '',
    this.bankName = '',
    this.imgId = '',
    required this.terminals,
  });

  factory BankShareResponseDTO.fromJson(Map<String, dynamic> json) {
    return BankShareResponseDTO(
        bankId: json['bankId'] ?? '',
        bankAccount: json['bankAccount'] ?? '',
        userBankName: json['userBankName'] ?? '',
        bankCode: json['bankCode'] ?? '',
        bankShortName: json['bankShortName'] ?? '',
        bankName: json['bankName'] ?? '',
        imgId: json['imgId'] ?? '',
        terminals: json['terminals'] != null
            ? json['terminals']
                .map<TerminalShareDTO>(
                    (json) => TerminalShareDTO.fromJson(json))
                .toList()
            : []);
  }
}

class TerminalShareDTO {
  final String id;
  final int totalMembers;
  final String terminalName;
  final String terminalAddress;
  final String terminalCode;

  final bool isDefault;
  final String bankId;
  const TerminalShareDTO(
      {this.id = '',
      this.totalMembers = 0,
      this.terminalName = '',
      this.terminalAddress = '',
      this.terminalCode = '',
      this.isDefault = false,
      this.bankId = ''});

  factory TerminalShareDTO.fromJson(Map<String, dynamic> json) {
    return TerminalShareDTO(
      id: json['id'] ?? '',
      totalMembers: json['totalMembers'] ?? 0,
      terminalName: json['terminalName'] ?? '',
      terminalAddress: json['terminalAddress'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      isDefault: json['default'] ?? false,
      bankId: json['bankId'] ?? '',
    );
  }
}
