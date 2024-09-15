class PlatformDTO {
  List<PlatformItem> items;

  PlatformDTO({
    required this.items,
  });

  factory PlatformDTO.fromJson(Map<String, dynamic> json) {
    return PlatformDTO(
      items: List<PlatformItem>.from(
          json['items'].map((x) => PlatformItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class PlatformItem {
  final String platformId;
  final String platformName;
  final String connectionDetail;

  PlatformItem(
      {required this.platformId,
      required this.platformName,
      required this.connectionDetail});

  factory PlatformItem.fromJson(Map<String, dynamic> json) {
    return PlatformItem(
      platformId: json['platformId'],
      platformName: json['platformName'],
      connectionDetail: json['connectionDetail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platformId'] = platformId;
    data['platformName'] = platformName;
    data['connectionDetail'] = connectionDetail;
    return data;
  }
}
