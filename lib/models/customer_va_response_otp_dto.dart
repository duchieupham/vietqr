class ResponseObjectDTO {
  final String message;
  final CustomerVaResponseOtpDTO data;

  ResponseObjectDTO({
    required this.message,
    required this.data,
  });

  factory ResponseObjectDTO.fromJson(Map<String, dynamic> json) {
    return ResponseObjectDTO(
      message: json['message'],
      data: CustomerVaResponseOtpDTO.fromJson(
        json['data'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['message'] = message;
    json['data'] = data.toJson();
    return json;
  }
}

class CustomerVaResponseOtpDTO {
  final String merchantId;
  final String confirmId;

  CustomerVaResponseOtpDTO({required this.merchantId, required this.confirmId});

  factory CustomerVaResponseOtpDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaResponseOtpDTO(
      merchantId: json['merchantId'],
      confirmId: json['confirmId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantId'] = merchantId;
    data['confirmId'] = confirmId;
    return data;
  }
}
