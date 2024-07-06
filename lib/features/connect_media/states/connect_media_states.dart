import 'package:equatable/equatable.dart';

import '../../../commons/enums/enum_type.dart';
import '../../../models/connect_gg_chat_info_dto.dart';

class ConnectMediaStates extends Equatable {
  final String? msg;
  final BlocStatus status;
  final ConnectMedia request;
  final InfoMediaDTO? dto;
  final bool? hasInfo;
  final bool? isValidUrl;
  final bool? isConnectSuccess;
  final bool? isAddSuccess;

  ConnectMediaStates({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = ConnectMedia.NONE,
    this.dto,
    this.hasInfo,
    this.isValidUrl,
    this.isConnectSuccess,
    this.isAddSuccess,
  });

  ConnectMediaStates copyWith({
    BlocStatus? status,
    ConnectMedia? request,
    String? msg,
    InfoMediaDTO? dto,
    bool? hasInfo,
    bool? isValidUrl,
    bool? isConnectSuccess,
    bool? isAddSuccess,
  }) {
    return ConnectMediaStates(
      status: status ?? this.status,
      request: request ?? this.request,
      msg: msg ?? this.msg,
      dto: dto ?? this.dto,
      hasInfo: hasInfo ?? this.hasInfo,
      isValidUrl: isValidUrl ?? this.isValidUrl,
      isConnectSuccess: isConnectSuccess ?? this.isConnectSuccess,
      isAddSuccess: isAddSuccess ?? this.isAddSuccess,
    );
  }

  @override
  List<Object?> get props => [
        msg,
        status,
        request,
        dto,
        hasInfo,
        isValidUrl,
        isConnectSuccess,
        isAddSuccess
      ];
}
