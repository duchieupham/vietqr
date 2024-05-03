import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

import '../../../commons/constants/configurations/theme.dart';

class BackgroundAppBarLogin extends StatelessWidget {
  final Widget? child;

  const BackgroundAppBarLogin({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      File _file = provider.bannerApp;
      bool isFileNotEmpty = _file.path.isNotEmpty;
      return Container(
        height: 180,
        width: width,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: AppColor.WHITE,
          // image: isFileNotEmpty
          //     ? DecorationImage(image: FileImage(_file), fit: BoxFit.cover)
          //     : DecorationImage(
          //         image: AssetImage('assets/images/bgr-header.png'),
          //         fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     height: 50,
            //     width: width,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //           colors: [
            //             Theme.of(context).scaffoldBackgroundColor,
            //             Theme.of(context)
            //                 .scaffoldBackgroundColor
            //                 .withOpacity(0.1),
            //           ],
            //           begin: Alignment.bottomCenter,
            //           end: Alignment.topCenter,
            //           tileMode: TileMode.clamp),
            //     ),
            //   ),
            // ),
            child ??
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 100,
                    width: width / 2,
                    margin: const EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      image: provider.logoApp.path.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(provider.logoApp),
                              fit: BoxFit.contain,
                            )
                          : DecorationImage(
                              image: AssetImage(
                                  'assets/images/logo_vietgr_payment.png'),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
          ],
        ),
      );
    });
  }
}
