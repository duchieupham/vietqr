class AccountLoginDTO {
  final String phoneNo;
  final String password;
  final String platform;
  final String device;
  final String fcmToken;
  final String sharingCode;
  final String? method;
  final String? userId;
  final String? cardNumber;

  const AccountLoginDTO({
    required this.phoneNo,
    required this.password,
    required this.platform,
    required this.device,
    required this.fcmToken,
    required this.sharingCode,
    this.method,
    this.userId,
    this.cardNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    if (method != null) data['method'] = method;
    if (userId != null) data['userId'] = userId;
    if (cardNumber != null) data['cardNumber'] = cardNumber;
    return data;
  }
}
