class NetworkProviders {
  final String id;
  final String name;
  final String code;
  final String imgId;

  const NetworkProviders({
    this.imgId = '',
    this.id = '',
    this.code = '',
    this.name = '',
  });

  factory NetworkProviders.fromJson(Map<String, dynamic> json) {
    return NetworkProviders(
      imgId: json['imgId'] ?? '',
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
