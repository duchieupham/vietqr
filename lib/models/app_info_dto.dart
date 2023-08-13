class AppInfoDTO {
  final String? id;
  final String? androidVersion;
  final String? iosVersion;
  final String? telegramChatId;
  final String? webhookUrl;

  AppInfoDTO({
    this.id,
    this.androidVersion,
    this.iosVersion,
    this.telegramChatId,
    this.webhookUrl,
  });

  int get buildAdr {
    if (androidVersion != null) {
      return int.parse(androidVersion!.split('+').last);
    }
    return -1;
  }

  int get adrVer {
    if (androidVersion != null) {
      return int.parse(androidVersion!.split('+').first.replaceAll('.', ''));
    }
    return -1;
  }

  int get buildIos {
    if (iosVersion != null) {
      return int.parse(iosVersion!.split('+').last);
    }
    return -1;
  }

  int get iosVer {
    if (iosVersion != null) {
      return int.parse(iosVersion!.split('+').first.replaceAll('.', ''));
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
    );
  }
}
