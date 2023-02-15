class CodeLoginDTO {
  final String code;
  final bool isScanned;
  final String userId;

  const CodeLoginDTO({
    required this.code,
    required this.isScanned,
    required this.userId,
  });

  factory CodeLoginDTO.fromJson(Map<String, dynamic> json) {
    return CodeLoginDTO(
      code: json['code'] ?? '',
      isScanned: json['isScanned'] ?? false,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['code'] = code;
    data['isScanned'] = isScanned;
    data['userId'] = userId;
    return data;
  }
}
