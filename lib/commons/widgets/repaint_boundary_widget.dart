import 'package:flutter/material.dart';

class RepaintBoundaryWidget extends StatelessWidget {
  final Function(GlobalKey key) builder;
  final GlobalKey globalKey;

  const RepaintBoundaryWidget({
    super.key,
    required this.globalKey,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: builder(globalKey),
    );
  }
}
