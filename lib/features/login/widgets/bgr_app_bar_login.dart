import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';

import '../../../commons/constants/configurations/theme.dart';

class BackgroundAppBarLogin extends StatelessWidget {
  final Widget? child;

  const BackgroundAppBarLogin({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 180,
      width: width,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: AppColor.WHITE,
      ),
      child: Stack(
        children: [
          child ??
              Align(
                alignment: Alignment.center,
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  bloc: getIt.get<ThemeBloc>(),
                  buildWhen: (previous, current) => current is UpdateLogoApp,
                  builder: (context, state) {
                    return Container(
                      height: 100,
                      width: width / 2,
                      margin: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        image: state.logoApp.path.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(state.logoApp),
                                fit: BoxFit.contain,
                              )
                            : const DecorationImage(
                                image:
                                    AssetImage(ImageConstant.logoVietQRPayment),
                                fit: BoxFit.contain,
                              ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
