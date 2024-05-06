import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/mixin/base_manager.dart';
import '../events/connect_gg_chat_evens.dart';
import '../states/connect_gg_chat_states.dart';

class ConnectGgChatBloc extends Bloc<ConnectGgChatEvent, ConnectGgChatStates>
    with BaseManager {
  @override
  final BuildContext context;

  ConnectGgChatBloc(this.context) : super(const ConnectGgChatStates()) {}
}
