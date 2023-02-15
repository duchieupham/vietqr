class ResponseMessageDTO {
  final String status;
  final String message;

  const ResponseMessageDTO({required this.status, required this.message});

  factory ResponseMessageDTO.fromJson(Map<String, dynamic> json) {
    return ResponseMessageDTO(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
