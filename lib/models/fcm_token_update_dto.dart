class FcmTokenUpdateDTO {
  final String userId;
  final String oldToken;
  final String newToken;

  const FcmTokenUpdateDTO({
    required this.userId,
    required this.oldToken,
    required this.newToken,
  });

  factory FcmTokenUpdateDTO.fromJson(Map<String, dynamic> json) {
    return FcmTokenUpdateDTO(
      userId: json['userId'] ?? '',
      oldToken: json['oldToken'] ?? '',
      newToken: json['newToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['oldToken'] = oldToken;
    data['newToken'] = newToken;
    return data;
  }
}
