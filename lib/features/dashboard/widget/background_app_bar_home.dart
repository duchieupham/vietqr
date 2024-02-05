import 'dart:io';

import 'package:flutter/material.dart';

class BackgroundAppBarHome extends StatelessWidget {
  final Widget child;
  final File file;
  final String url;

  const BackgroundAppBarHome(
      {super.key, required this.child, required this.file, required this.url});

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 230,
      width: width,
      padding: EdgeInsets.only(top: paddingTop + 12),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          image: file.path.isNotEmpty
              ? DecorationImage(image: FileImage(file), fit: BoxFit.fitWidth)
              : DecorationImage(
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
