import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';

class QrFolderScreen extends StatefulWidget {
  const QrFolderScreen({super.key});

  @override
  State<QrFolderScreen> createState() => _QrFolderScreenState();
}

class _QrFolderScreenState extends State<QrFolderScreen> {
  final QrFeedBloc _bloc = getIt.get<QrFeedBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
