class AccountLoginDTO {
  final String phoneNo;
  final String password;
  final String platform;
  final String device;
  final String fcmToken;
  final String sharingCode;

  const AccountLoginDTO({
    required this.phoneNo,
    required this.password,
    required this.platform,
    required this.device,
    required this.fcmToken,
    required this.sharingCode,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    data['fcmToken'] = fcmToken;
    data['device'] = device;
    data['platform'] = platform;
    data['sharingCode'] = sharingCode;
    return data;
  }
}
