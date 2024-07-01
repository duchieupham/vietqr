import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';

import '../commons/di/injection/injection.dart';
import 'image/x_image.dart';

class XLogoApp extends StatelessWidget {
  const XLogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: getIt.get<ThemeBloc>(),
      buildWhen: (previous, current) =>
          current is UpdateSetting || current is UpdateLogoApp,
      builder: (context, state) {
        return XImage(
          imagePath: state.logoApp.path.isEmpty
              ? state.settingDTO.logoUrl
              : state.logoApp.path,
          width: 96,
          height: 56,
          borderRadius: BorderRadius.circular(10),
        );
      },
    );
  }
}
