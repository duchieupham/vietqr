class QrData {
  String id;
  String description;
  String isPublic;
  String qrType;
  String timeCreate;
  String title;
  String content;
  String data;
  String vlue;
  String fileAttachmentId;

  QrData({
    required this.id,
    required this.description,
    required this.isPublic,
    required this.qrType,
    required this.timeCreate,
    required this.title,
    required this.content,
    required this.data,
    required this.vlue,
    required this.fileAttachmentId,
  });

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      id: json['id'],
      description: json['description'],
      isPublic: json['isPublic'],
      qrType: json['qrType'],
      timeCreate: json['timeCreate'],
      title: json['title'],
      content: json['content'],
      data: json['data'],
      vlue: json['vlue'],
      fileAttachmentId: json['fileAttachmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isPublic': isPublic,
      'qrType': qrType,
      'timeCreate': timeCreate,
      'title': title,
      'content': content,
      'data': data,
      'vlue': vlue,
      'fileAttachmentId': fileAttachmentId,
    };
  }
}

class QrFolderDetailDTO {
  String userId;
  List<QrData> qrData;
  String folderId;
  String titleFolder;
  String descriptionFolder;

  QrFolderDetailDTO({
    required this.userId,
    required this.qrData,
    required this.folderId,
    required this.titleFolder,
    required this.descriptionFolder,
  });

  factory QrFolderDetailDTO.fromJson(Map<String, dynamic> json) {
    return QrFolderDetailDTO(
      userId: json['userId'],
      qrData: List<QrData>.from(
          json['qrData'].map((data) => QrData.fromJson(data))),
      folderId: json['folderId'],
      titleFolder: json['titleFolder'],
      descriptionFolder: json['descriptionFolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'qrData': qrData.map((data) => data.toJson()).toList(),
      'folderId': folderId,
      'titleFolder': titleFolder,
      'descriptionFolder': descriptionFolder,
    };
  }
}
