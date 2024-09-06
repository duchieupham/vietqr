class EcommerceRequest {
  final String fullName;
  final String name; // Tên rút gọn
  final String bankCode;
  final String bankAccount;
  final String certificate; // Mã QR đã quét
  final String nationalId;
  final String email;
  final String phoneNo;
  final String website; //web của đối tác
  final String webhook;
  final String address; // Địa chỉ
  final String career; // Ngành nghề
  final int businessType; // 0: cá nhân, 1: doanh nghiệp

  EcommerceRequest({
    required this.fullName,
    required this.name,
    this.bankCode = '',
    this.bankAccount = '',
    required this.certificate,
    this.nationalId = '',
    this.email = '',
    this.phoneNo = '',
    this.address = '',
    this.career = '',
    this.webhook = '',
    this.website = '',
    this.businessType = 0,
  });

  // From JSON
  factory EcommerceRequest.fromJson(Map<String, dynamic> json) {
    return EcommerceRequest(
      fullName: json['fullName'],
      name: json['name'],
      bankCode: json['bankCode'],
      bankAccount: json['bankAccount'],
      certificate: json['certificate'],
      nationalId: json['nationalId'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      address: json['address'],
      career: json['career'],
      businessType: json['businessType'],
      webhook: json['webhook'],
      website: json['website'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'name': name,
      'bankCode': bankCode,
      'bankAccount': bankAccount,
      'certificate': certificate,
      'nationalId': nationalId,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'career': career,
      'businessType': businessType,
      'webhook': webhook,
      'website': website,
    };
  }
}
