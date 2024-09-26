class BankNameInformationDTO {
  final String accountName;
  final String customerName;
  final String customerShortName;
  final bool isNaviAddBank;

  const BankNameInformationDTO({
    required this.accountName,
    required this.customerName,
    required this.customerShortName,
    this.isNaviAddBank = false,
  });

  factory BankNameInformationDTO.fromJson(Map<String, dynamic> json) {
    return BankNameInformationDTO(
      accountName: json['accountName'],
      customerName: json['customerName'],
      customerShortName: json['customerShortName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accountName'] = accountName;
    data['customerName'] = customerName;
    data['customerShortName'] = customerShortName;
    return data;
  }
}
