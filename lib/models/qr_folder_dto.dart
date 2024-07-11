import 'package:vierqr/models/metadata_dto.dart';

class QRFolderData {
  String data;
  String fullName;
  int addedToFolder;
  String theme;
  String style;
  String title;
  int timeCreated;
  String fileAttachmentId;
  String qrType;
  String imageId;
  String description;
  String value;
  String id;

  QRFolderData({
    required this.data,
    required this.fullName,
    required this.addedToFolder,
    required this.theme,
    required this.style,
    required this.title,
    required this.timeCreated,
    required this.fileAttachmentId,
    required this.qrType,
    required this.imageId,
    required this.description,
    required this.value,
    required this.id,
  });

  factory QRFolderData.fromJson(Map<String, dynamic> json) {
    return QRFolderData(
      data: json['data'],
      fullName: json['fullName'],
      addedToFolder: json['addedToFolder'],
      theme: json['theme'],
      style: json['style'],
      title: json['title'],
      timeCreated: json['timeCreated'],
      fileAttachmentId: json['fileAttachmentId'],
      qrType: json['qrType'],
      imageId: json['imageId'],
      description: json['description'],
      value: json['value'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'fullName': fullName,
      'addedToFolder': addedToFolder,
      'theme': theme,
      'style': style,
      'title': title,
      'timeCreated': timeCreated,
      'fileAttachmentId': fileAttachmentId,
      'qrType': qrType,
      'imageId': imageId,
      'description': description,
      'value': value,
      'id': id,
    };
  }
}

class QRFolderDTO {
  MetaDataDTO metadata;
  List<QRFolderData> data;

  QRFolderDTO({
    required this.metadata,
    required this.data,
  });

  factory QRFolderDTO.fromJson(Map<String, dynamic> json) {
    return QRFolderDTO(
      metadata: MetaDataDTO.fromJson(json['metadata']),
      data:
          (json['data'] as List).map((i) => QRFolderData.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'metadata': metadata.toJson(),
      'data': data.map((i) => i.toJson()).toList(),
    };
  }
}
