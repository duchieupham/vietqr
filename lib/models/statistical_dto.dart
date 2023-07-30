class ResponseStatisticDTO {
  final int totalTrans;
  final int totalTransC;
  final int totalTransD;
  final int totalCashIn;
  final int totalCashOut;

  final String date;
  final String month;
  const ResponseStatisticDTO(
      {this.date = '',
      this.month = '',
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.totalTrans = 0,
      this.totalTransC = 0,
      this.totalTransD = 0});

  factory ResponseStatisticDTO.fromJson(Map<String, dynamic> json) {
    return ResponseStatisticDTO(
      date: json['date'] ?? '',
      month: json['month'] ?? '',
      totalCashIn: json['totalCashIn'] ?? '',
      totalCashOut: json['totalCashOut'] ?? '',
      totalTrans: json['totalTrans'] ?? '',
      totalTransC: json['totalTransC'] ?? '',
      totalTransD: json['totalTransD'] ?? '',
    );
  }
}
