import 'dart:io';

import 'package:flutter/material.dart';

class BackgroundAppBarLogin extends StatelessWidget {
  final Widget child;
  final File file;
  final String url;
  final bool isEventTheme;

  const BackgroundAppBarLogin(
      {super.key,
      required this.child,
      required this.file,
      required this.url,
      this.isEventTheme = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 230,
      width: width,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: file.path.isNotEmpty
            ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
            : DecorationImage(
                image: AssetImage('assets/images/bgr-header.png'),
                fit: BoxFit.cover),
      ),
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
