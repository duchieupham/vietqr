class AppInfoDTO {
  final String id;
  final String androidVersion;
  final String iosVersion;
  final String telegramChatId;
  final String webhookUrl;
  final String themeVersion;
  final String logoVersion;
  final String themeImgUrl;
  final String logoUrl;
  final bool isEventTheme;
  bool isCheckApp;

  AppInfoDTO({
    this.id = '',
    this.androidVersion = '',
    this.iosVersion = '',
    this.telegramChatId = '',
    this.webhookUrl = '',
    this.isEventTheme = false,
    this.themeVersion = '',
    this.logoVersion = '',
    this.themeImgUrl = '',
    this.logoUrl = '',
    this.isCheckApp = false,
  });

  int get buildAdr {
    if (androidVersion.isNotEmpty) {
      return int.parse(androidVersion.split('+').last);
    }
    return -1;
  }

  int get adrVer {
    if (androidVersion.isNotEmpty) {
      return int.parse(androidVersion.split('+').first.replaceAll('.', ''));
    }
    return -1;
  }

  int get buildIos {
    if (iosVersion.isNotEmpty) {
      return int.parse(iosVersion.split('+').last);
    }
    return -1;
  }

  int get iosVer {
    if (iosVersion.isNotEmpty) {
      return int.parse(iosVersion.split('+').first.replaceAll('.', ''));
    }
    return -1;
  }

  int get themeVer {
    if (themeVersion.isNotEmpty) {
      return int.parse(themeVersion.replaceAll('.', ''));
    }
    return -1;
  }

  int get logoVer {
    if (logoVersion.isNotEmpty) {
      return int.parse(logoVersion.replaceAll('.', ''));
    }
    return -1;
  }

  factory AppInfoDTO.fromJson(Map<String, dynamic> json) {
    return AppInfoDTO(
      id: json['id'] ?? '',
      androidVersion: json['androidVersion'] ?? '',
      iosVersion: json['iosVersion'] ?? '',
      telegramChatId: json['telegramChatId'] ?? '',
      webhookUrl: json['webhookUrl'] ?? '',
      logoVersion: json['logoVersion'] ?? '',
      themeVersion: json['themeVersion'] ?? '',
      themeImgUrl: json['themeImgUrl'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      isEventTheme: json['eventTheme'] ?? false,
      isCheckApp: json['isCheckApp'] ?? false,
    );
  }
}
