class BankOverviewDTO {
  final int totalCredit;
  final int countCredit;
  final int totalDebit;
  final int countDebit;
  final String merchantName;
  final List<String> terminals;

  BankOverviewDTO({
    this.totalCredit = 0,
    this.countCredit = 0,
    this.totalDebit = 0,
    this.countDebit = 0,
    this.merchantName = '',
    required this.terminals,
  });

  // Factory constructor to create an instance from a JSON map
  factory BankOverviewDTO.fromJson(Map<String, dynamic> json) {
    return BankOverviewDTO(
      totalCredit: json['totalCredit'] ?? 0,
      countCredit: json['countCredit'] ?? 0,
      totalDebit: json['totalDebit'] ?? 0,
      countDebit: json['countDebit'] ?? 0,
      merchantName: json['merchantName'] ?? '',
      terminals:
          json['terminals'] != null ? List<String>.from(json['terminals']) : [],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalCredit': totalCredit,
      'countCredit': countCredit,
      'totalDebit': totalDebit,
      'countDebit': countDebit,
      'merchantName': merchantName,
      'terminals': terminals,
    };
  }
}
