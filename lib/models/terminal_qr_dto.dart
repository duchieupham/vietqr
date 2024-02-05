class TerminalQRDTO {
  final String terminalId;
  final String terminalAddress;
  final String terminalName;
  final String terminalCode;
  final String userId;

  TerminalQRDTO({
    this.terminalId = '',
    this.terminalAddress = '',
    this.terminalName = '',
    this.terminalCode = '',
    this.userId = '',
  });

  factory TerminalQRDTO.fromJson(Map<String, dynamic> json) {
    return TerminalQRDTO(
      terminalId: json['terminalId'] ?? '',
      terminalAddress: json['terminalAddress'] ?? '',
      terminalName: json['terminalName'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
