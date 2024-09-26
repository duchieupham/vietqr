
import 'package:vierqr/models/metadata_dto.dart';

class Comment {
  final String message;
  final String id;
  final String fullName;
  final String userId;
  final int timeCreated;
  final String imageId;

  Comment({
    required this.message,
    required this.id,
    required this.fullName,
    required this.userId,
    required this.timeCreated,
    required this.imageId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      message: json['message'],
      id: json['id'],
      fullName: json['fullName'],
      userId: json['userId'],
      timeCreated: json['timeCreated'],
      imageId: json['imageId'],
    );
  }
}

class Comments {
  final MetaDataDTO metadata;
  final List<Comment> data;

  Comments({
    required this.metadata,
    required this.data,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      metadata: MetaDataDTO.fromJson(json['metadata']),
      data: (json['data'] as List).map((i) => Comment.fromJson(i)).toList(),
    );
  }
}

class QrFeedDetailDTO {
  final String id;
  final String title;
  final String description;
  final String value;
  final String qrType;
  final int timeCreated;
  final String userId;
  final int likeCount;
  final int commentCount;
  final int hasLiked;
  final String data;
  final String fullName;
  final String imageId;
  final String style;
  final String theme;
  final String fileAttachmentId;

  final Comments comments;

  QrFeedDetailDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.value,
    required this.qrType,
    required this.timeCreated,
    required this.userId,
    required this.likeCount,
    required this.commentCount,
    required this.hasLiked,
    required this.data,
    required this.fullName,
    required this.imageId,
    required this.style,
    required this.theme,
    required this.comments,
    required this.fileAttachmentId,
  });

  factory QrFeedDetailDTO.fromJson(Map<String, dynamic> json) {
    return QrFeedDetailDTO(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      value: json['value'],
      qrType: json['qrType'],
      timeCreated: json['timeCreated'],
      userId: json['userId'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      hasLiked: json['hasLiked'],
      data: json['data'],
      fullName: json['fullName'],
      imageId: json['imageId'],
      style: json['style'],
      theme: json['theme'],
      fileAttachmentId: json['fileAttachmentId'],
      comments: Comments.fromJson(json['comments']),
    );
  }
}
