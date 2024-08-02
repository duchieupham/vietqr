class BankOverviewDTO {
  final int totalCredit;
  final int countCredit;
  final int totalDebit;
  final int countDebit;
  final String merchantName;
  final List<String> terminals;

  BankOverviewDTO({
    required this.totalCredit,
    required this.countCredit,
    required this.totalDebit,
    required this.countDebit,
    required this.merchantName,
    required this.terminals,
  });

  // Factory constructor to create an instance from a JSON map
  factory BankOverviewDTO.fromJson(Map<String, dynamic> json) {
    return BankOverviewDTO(
      totalCredit: json['totalCredit'],
      countCredit: json['countCredit'],
      totalDebit: json['totalDebit'],
      countDebit: json['countDebit'],
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
