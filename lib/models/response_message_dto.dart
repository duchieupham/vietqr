class ResponseMessageDTO {
  final String status;
  final String message;
  final String? ewalletToken;
  final DataObject? data;

  const ResponseMessageDTO({
    required this.status,
    required this.message,
    this.data,
    this.ewalletToken,
  });

  factory ResponseMessageDTO.fromJson(Map<String, dynamic> json) {
    return ResponseMessageDTO(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      ewalletToken: json['ewalletToken'] ?? '',
      data: (json['data'] != null) ? DataObject.fromJson(json['data']) : null,
    );
  }
}

class DataObject {
  final String merchantId;
  final String confirmId;

  DataObject({required this.merchantId, required this.confirmId});

  factory DataObject.fromJson(Map<String, dynamic> json) {
    return DataObject(
      merchantId: json['merchantId'] ?? '',
      confirmId: json['confirmId'] ?? '',
    );
  }
}
