import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/metadata_dto.dart';

class QrFeedState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final QrFeed request;
  final MetaDataDTO? metadata;

  const QrFeedState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = QrFeed.NONE,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
        metadata,
      ];
}
