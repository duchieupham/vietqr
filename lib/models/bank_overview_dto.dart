class BankOverviewDTO {
  final int totalCredit;
  final int countCredit;
  final int totalDebit;
  final int countDebit;

  BankOverviewDTO({
    this.totalCredit = 0,
    this.countCredit = 0,
    this.totalDebit = 0,
    this.countDebit = 0,
  });

  // Factory constructor to create an instance from a JSON map
  factory BankOverviewDTO.fromJson(Map<String, dynamic> json) {
    return BankOverviewDTO(
      totalCredit: json['totalCredit'] ?? 0,
      countCredit: json['countCredit'] ?? 0,
      totalDebit: json['totalDebit'] ?? 0,
      countDebit: json['countDebit'] ?? 0,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalCredit': totalCredit,
      'countCredit': countCredit,
      'totalDebit': totalDebit,
      'countDebit': countDebit,
    };
  }
}
