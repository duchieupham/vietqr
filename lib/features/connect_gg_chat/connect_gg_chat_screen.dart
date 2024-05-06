import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/connect_gg_chat/states/connect_gg_chat_states.dart';

import '../../services/providers/connect_gg_chat_provider.dart';
import 'blocs/connect_gg_chat_bloc.dart';

class ConnectGgChatScreen extends StatelessWidget {
  const ConnectGgChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectGgChatBloc>(
      create: (context) => ConnectGgChatBloc(context),
      child: _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectGgChatBloc, ConnectGgChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Consumer<ConnectGgChatProvider>(
          builder: (context, value, child) {
            return Scaffold();
          },
        );
      },
    );
  }
}
