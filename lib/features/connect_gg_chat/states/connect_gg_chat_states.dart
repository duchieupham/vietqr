import 'package:equatable/equatable.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/connect_gg_chat_info_dto.dart';

class ConnectGgChatStates extends Equatable {
  final String? msg;
  final BlocStatus status;
  final ConnectGgChat request;
  final InfoGgChatDTO? dto;
  final bool? hasInfo;
  final bool? isValidUrl;
  final bool? isConnectSuccess;

  ConnectGgChatStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = ConnectGgChat.NONE,
    this.dto,
    this.hasInfo,
    this.isValidUrl,
    this.isConnectSuccess,
  });

  ConnectGgChatStates copyWith({
    BlocStatus? status,
    ConnectGgChat? request,
    String? msg,
    InfoGgChatDTO? dto,
    bool? hasInfo,
    bool? isValidUrl,
    bool? isConnectSuccess,
  }) {
    return ConnectGgChatStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      hasInfo: hasInfo ?? this.hasInfo,
      isValidUrl: isValidUrl ?? this.isValidUrl,
      isConnectSuccess: isConnectSuccess ?? this.isConnectSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [msg, status, request, dto, hasInfo, isValidUrl, isConnectSuccess];
}
