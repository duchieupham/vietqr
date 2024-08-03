class TerminalDTO {
  String terminalId;
  String terminalName;
  String terminalCode;
  String rawTerminalCode;
  String terminalAddress;
  String qrCode;

  TerminalDTO({
    required this.terminalId,
    required this.terminalName,
    required this.terminalCode,
    required this.rawTerminalCode,
    required this.terminalAddress,
    required this.qrCode,
  });

  factory TerminalDTO.fromJson(Map<String, dynamic> json) {
    return TerminalDTO(
      terminalId: json['terminalId'],
      terminalName: json['terminalName'],
      terminalCode: json['terminalCode'],
      rawTerminalCode: json['rawTerminalCode'],
      terminalAddress: json['terminalAddress'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terminalId': terminalId,
      'terminalName': terminalName,
      'terminalCode': terminalCode,
      'rawTerminalCode': rawTerminalCode,
      'terminalAddress': terminalAddress,
      'qrCode': qrCode,
    };
  }
}

class VietQRStoreDTO {
  String merchantId;
  String merchantName;
  List<TerminalDTO> terminals;

  VietQRStoreDTO({
    this.merchantId = '',
    this.merchantName = '',
    required this.terminals,
  });

  factory VietQRStoreDTO.fromJson(Map<String, dynamic> json) {
    var terminalsJson = json['terminals'] as List;
    List<TerminalDTO> terminalsList =
        terminalsJson.map((i) => TerminalDTO.fromJson(i)).toList();

    return VietQRStoreDTO(
      merchantId: json['merchantId'] ?? '',
      merchantName: json['merchantName'] ?? '',
      terminals: terminalsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantName': merchantName,
      'terminals': terminals.map((item) => item.toJson()).toList(),
    };
  }
}
