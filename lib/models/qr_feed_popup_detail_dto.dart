class QrFeedPopupDetailDTO {
  // final String? title;
  // final String? description;
  final String? bankAccount;
  final String? userBankName;
  final String? bankCode;
  final String? amount;
  final String? content;
  final String? fullName;
  final String? phoneNo;
  final String? email;
  final String? companyName;
  final String? website;
  final String? address;
  final String? value;

  QrFeedPopupDetailDTO({
    // this.title,
    // this.description,
    this.bankAccount,
    this.userBankName,
    this.bankCode,
    this.amount,
    this.content,
    this.fullName,
    this.phoneNo,
    this.email,
    this.companyName,
    this.website,
    this.address,
    this.value,
  });

  factory QrFeedPopupDetailDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedPopupDetailDTO(
      // title: json['title'],
      // description: json['description'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      bankCode: json['bankCode'],
      amount: json['amount'],
      content: json['content'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      companyName: json['companyName'],
      website: json['website'],
      address: json['address'],
      value: json['value'],
    );
  }
}
