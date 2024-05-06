import 'package:equatable/equatable.dart';

import '../../../commons/enums/enum_type.dart';

class ConnectGgChatStates extends Equatable {
  final String? msg;

  final BlocStatus status;

  const ConnectGgChatStates({
    this.msg,
    this.status = BlocStatus.NONE,
  });

  @override
  List<Object?> get props => [msg, status];
}
