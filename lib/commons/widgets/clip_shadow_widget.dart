import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/clip_shadow_painter_widget.dart';

class ClipShadowWidget extends StatelessWidget {
  /// A list of [BoxShadow] which will appear behind and around the [CustomClipper].
  final List<BoxShadow> shadows;

  /// The clipper to apply.
  final CustomClipper<Path> clipper;

  /// The [Widget] below this widget in the tree.
  final Widget child;

  /// Constructor.
  const ClipShadowWidget(
      {super.key,
      required this.shadows,
      required this.clipper,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClipShadowPainterWidget(shadows: shadows, clipper: clipper),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}