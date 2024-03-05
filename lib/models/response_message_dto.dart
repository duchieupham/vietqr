class ResponseMessageDTO {
  final String status;
  final String message;
  final DataObject? data;

  const ResponseMessageDTO(
      {required this.status, required this.message, this.data});

  factory ResponseMessageDTO.fromJson(Map<String, dynamic> json) {
    return ResponseMessageDTO(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
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
