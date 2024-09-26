class AccountLoginDTO {
  final String phoneNo;
  final String password;
  final String platform;
  final String device;
  final String fcmToken;
  final String sharingCode;
  final String method;
  final String userId;
  final String cardNumber;

  const AccountLoginDTO({
    required this.phoneNo,
    required this.password,
    this.device = '',
    this.fcmToken = '',
    this.platform = '',
    this.sharingCode = '',
    this.method = '',
    this.userId = '',
    this.cardNumber = '',
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    data['method'] = method;
    data['userId'] = userId;
    data['cardNumber'] = cardNumber;
    return data;
  }
}
