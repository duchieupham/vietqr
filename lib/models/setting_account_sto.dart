class SettingAccountDTO {
  final String id;
  final String userId;
  final bool guideWeb;
  final bool guideMobile;
  final bool voiceWeb;
  final bool voiceMobile;
  final bool voiceMobileKiot;
  final bool status;
  final String edgeImgId;
  final String footerImgId;
  final int themeType;
  final String themeImgUrl;
  final String logoUrl;
  bool keepScreenOn;
  final int qrShowType;

  SettingAccountDTO({
    this.status = false,
    this.id = '',
    this.userId = '',
    this.guideMobile = false,
    this.guideWeb = false,
    this.voiceMobile = false,
    this.voiceMobileKiot = false,
    this.voiceWeb = false,
    this.edgeImgId = '',
    this.footerImgId = '',
    this.themeType = -1,
    this.themeImgUrl = '',
    this.logoUrl = '',
    this.keepScreenOn = false,
    this.qrShowType = -1,
  });

  bool get isEvent => themeType == 0;

  factory SettingAccountDTO.fromJson(Map<String, dynamic> json) {
    return SettingAccountDTO(
      status: json['status'] ?? false,
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      guideMobile: json['guideMobile'] ?? false,
      guideWeb: json['guideWeb'] ?? false,
      voiceMobile: json['voiceMobile'] ?? false,
      voiceMobileKiot: json['voiceMobileKiot'] ?? false,
      voiceWeb: json['voiceWeb'] ?? false,
      edgeImgId: json['edgeImgId'] ?? '',
      footerImgId: json['footerImgId'] ?? '',
      themeType: json['themeType'] ?? -1,
      themeImgUrl: json['themeImgUrl'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      keepScreenOn: json['keepScreenOn'] ?? false,
      qrShowType: json['qrShowType'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["userId"] = userId;
    data["id"] = id;
    data["status"] = status;
    data["guideMobile"] = guideMobile;
    data["guideWeb"] = guideWeb;
    data["voiceMobile"] = voiceMobile;
    data["voiceMobileKiot"] = voiceMobileKiot;
    data["voiceWeb"] = voiceWeb;
    data["edgeImgId"] = edgeImgId;
    data["footerImgId"] = footerImgId;
    data["themeType"] = themeType;
    data["themeImgUrl"] = themeImgUrl;
    data["logoUrl"] = logoUrl;
    data["keepScreenOn"] = keepScreenOn;
    data["qrShowType"] = qrShowType;
    return data;
  }

  Map<String, dynamic> toSPJson() {
    final Map<String, dynamic> data = {};
    data['"userId"'] = (userId == '') ? '""' : '"$userId"';
    data['"id"'] = (id == '') ? '""' : '"$id"';
    data['"status"'] = '$status';
    data['"guideMobile"'] = '$guideMobile';
    data['"guideWeb"'] = '$guideWeb';
    data['"voiceMobile"'] = '$voiceMobile';
    data['"voiceMobileKiot"'] = '$voiceMobileKiot';
    data['"voiceWeb"'] = '$voiceWeb';
    data['"edgeImgId"'] = '"$edgeImgId"';
    data['"footerImgId"'] = '"$footerImgId"';
    data['"themeType"'] = '$themeType';
    data['"themeImgUrl"'] = '"$themeImgUrl"';
    data['"logoUrl"'] = '"$logoUrl"';
    data['"keepScreenOn"'] = '$keepScreenOn';
    data['"qrShowType"'] = '$qrShowType';

    return data;
  }
}
