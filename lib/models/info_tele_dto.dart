class InfoTeleDTO {
  final String id;
  final String chatId;
  final String userId;
  final List<BankConnectedDTO> banks;

  const InfoTeleDTO({
    this.chatId = '',
    this.id = '',
    this.userId = '',
    required this.banks,
  });

  factory InfoTeleDTO.fromJson(Map<String, dynamic> json) {
    List<BankConnectedDTO> banks = [];
    if (json['banks'] != null) {
      json['banks'].forEach((v) {
        banks.add(BankConnectedDTO.fromJson(v));
      });
    }
    return InfoTeleDTO(
      chatId: json['chatId'] ?? '',
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      banks: banks,
    );
  }
}

class BankConnectedDTO {
  final String bankAccount;
  final String userBankName;
  final String bankId;
  final String bankCode;
  final String imageId;
  final String bankShortName;
  final String telBankId;

  const BankConnectedDTO({
    this.bankCode = '',
    this.bankId = '',
    this.bankAccount = '',
    this.imageId = '',
    this.userBankName = '',
    this.bankShortName = '',
    this.telBankId = '',
  });

  factory BankConnectedDTO.fromJson(Map<String, dynamic> json) {
    return BankConnectedDTO(
      bankCode: json['bankCode'] ?? '',
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      imageId: json['imgId'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      telBankId: json['telBankId'] ?? '',
    );
  }
}
