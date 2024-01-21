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
  String file;

  ThemeDTO({
    this.id = '',
    this.type = -1,
    this.imgUrl = '',
    this.name = '',
    this.file = '',
  });

  factory ThemeDTO.fromJson(Map<String, dynamic> json) {
    return ThemeDTO(
      id: json['id'] ?? '',
      type: json['type'] ?? -1,
      imgUrl: json['imgUrl'] ?? '',
      name: json['name'] ?? '',
      file: '',
    );
  }

  setFile(String localPath) {
    file = localPath;
  }

  Future<File> getImageFile() async {
    return File(file);
  }
}
