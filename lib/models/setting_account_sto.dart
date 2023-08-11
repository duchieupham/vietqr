class SettingAccountDTO {
  final String id;

  final String userId;
  final bool guideWeb;
  final bool guideMobile;
  final bool voiceWeb;
  final bool voiceMobile;
  final bool voiceMobileKiot;
  final bool status;

  const SettingAccountDTO({
    this.status = false,
    this.id = '',
    this.userId = '',
    this.guideMobile = false,
    this.guideWeb = false,
    this.voiceMobile = false,
    this.voiceMobileKiot = false,
    this.voiceWeb = false,
  });

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
    );
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

    return data;
  }
}
