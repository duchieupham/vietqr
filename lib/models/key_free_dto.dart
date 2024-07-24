class KeyFreeDTO {
  String keyActive;
  String bankId;
  int status;

  KeyFreeDTO({
    required this.keyActive,
    required this.bankId,
    required this.status,
  });

  // Chuyển đổi từ JSON sang đối tượng Dart
  factory KeyFreeDTO.fromJson(Map<String, dynamic> json) {
    return KeyFreeDTO(
      keyActive: json['keyActive'],
      bankId: json['bankId'],
      status: json['status'],
    );
  }

  // Chuyển đổi từ đối tượng Dart sang JSON
  Map<String, dynamic> toJson() {
    return {
      'keyActive': keyActive,
      'bankId': bankId,
      'status': status,
    };
  }
}
