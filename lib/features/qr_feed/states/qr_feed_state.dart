import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';

class QrFeedState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QrFeed request;
  final MetaDataDTO? metadata;
  final List<QrFeedDTO>? listQrFeed;

  const QrFeedState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QrFeed.NONE,
    this.metadata,
    this.listQrFeed,
  });

  QrFeedState copyWith({
    BlocStatus? status,
    String? msg,
    QrFeed? request,
    MetaDataDTO? metadata,
    List<QrFeedDTO>? listQrFeed,
  }) {
    return QrFeedState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      metadata: metadata ?? this.metadata,
      listQrFeed: listQrFeed ?? this.listQrFeed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        metadata,
        listQrFeed,
      ];
}
