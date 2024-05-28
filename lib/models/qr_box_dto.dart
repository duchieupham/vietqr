class QRBoxDTO {
  final String terminalName;
  final String subTerminalId;
  final String subTerminalAddress;
  final String subTerminalCode;
  final String subRawTerminalCode;

  QRBoxDTO({
    this.terminalName = '',
    this.subTerminalId = '',
    this.subTerminalAddress = '',
    this.subTerminalCode = '',
    this.subRawTerminalCode = '',
  });

  factory QRBoxDTO.fromJson(Map<String, dynamic> json) {
    return QRBoxDTO(
      terminalName: json['terminalName'] ?? '',
      subTerminalId: json['subTerminalId'] ?? '',
      subTerminalAddress: json['subTerminalAddress'] ?? '',
      subTerminalCode: json['subTerminalCode'] ?? '',
      subRawTerminalCode: json['subRawTerminalCode'] ?? '',
    );
  }
}
