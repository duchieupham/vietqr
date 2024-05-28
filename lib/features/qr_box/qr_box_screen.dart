import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/qr_box/blocs/qr_box_bloc.dart';
import 'package:vierqr/features/qr_box/states/qr_box_state.dart';
import 'package:vierqr/services/providers/qr_box_provider.dart';

class QRBoxScreen extends StatelessWidget {
  const QRBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRBoxBloc>(
      create: (context) => QRBoxBloc(context),
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
    return BlocConsumer<QRBoxBloc, QRBoxState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Consumer<QrBoxProvider>(
          builder: (context, value, child) {
            return Scaffold(
              backgroundColor: AppColor.WHITE,
            );
          },
        );
      },
    );
  }
}
