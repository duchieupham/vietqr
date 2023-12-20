class ResponseMessageDTO {
  final String status;
  final String message;
  final String? ewalletToken;

  const ResponseMessageDTO({
    required this.status,
    required this.message,
    this.ewalletToken,
  });

  factory ResponseMessageDTO.fromJson(Map<String, dynamic> json) {
    return ResponseMessageDTO(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      ewalletToken: json['ewalletToken'] ?? '',
    );
  }
}
