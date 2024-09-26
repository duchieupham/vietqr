import 'package:flutter/cupertino.dart';

class GradientText extends StatelessWidget {
  final LinearGradient gradient;
  final String text;
  final TextStyle? textStyle;
  const GradientText(
      {super.key, required this.gradient, required this.text, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
