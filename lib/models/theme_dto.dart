import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

part 'theme_dto.g.dart';

@HiveType(typeId: 1)
class ThemeDTO extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int type;
  @HiveField(2)
  String imgUrl;
  @HiveField(3)
  String name;
  @HiveField(4)
  String photoPath;

  File? xFile;

  ThemeDTO({
    this.id = '',
    this.type = -1,
    this.imgUrl = '',
    this.name = '',
    this.photoPath = '',
  });

  ThemeDTO get copy {
    final objectInstance = ThemeDTO()
      ..id = id
      ..type = type
      ..imgUrl = imgUrl
      ..name = name
      ..photoPath = photoPath;
    return objectInstance;
  }

  factory ThemeDTO.fromJson(Map<String, dynamic> json) {
    return ThemeDTO(
      id: json['id'] ?? '',
      type: json['type'] ?? -1,
      imgUrl: json['imgUrl'] ?? '',
      name: json['name'] ?? '',
      photoPath: json['photoPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["type"] = type;
    data["imgUrl"] = imgUrl;
    data["name"] = name;
    data["photoPath"] = photoPath;
    return data;
  }

  setFile(String localPath) {
    photoPath = localPath;
  }

  void setType(int themeType) {
    type = themeType;
  }
}
