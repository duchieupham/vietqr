import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class BackgroundAppBarHome extends StatelessWidget {
  final Widget child;
  const BackgroundAppBarHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 230,
      width: width,
      padding: EdgeInsets.only(top: paddingTop + 12),
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bgr-header.png'),
              fit: BoxFit.fitWidth)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
