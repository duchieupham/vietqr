import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class StepProgressView extends StatelessWidget {
  final double _width;

  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = AppColor.GREY_TEXT;
  final double lineWidth = 2.0;

  const StepProgressView(
      {super.key,
      required int curStep,
      required List<String> titles,
      required double width,
      required Color color})
      : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _iconViews(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _titleViews(),
            ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i) ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      var textColor =
          (i == 0 || _curStep > i) ? AppColor.WHITE : AppColor.GREY_TEXT;
      list.add(
        Container(
          width: 28.0,
          height: 28.0,
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              /* color: circleColor,*/
              borderRadius: const BorderRadius.all(Radius.circular(22.0)),
              color: circleColor),
          child: Text(
            '${i + 1}',
            style: TextStyle(color: textColor),
          ),
        ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      var textColor =
          (i == 0 || _curStep > i) ? AppColor.BLACK : AppColor.GREY_TEXT;
      list.add(Text(text, style: TextStyle(color: textColor, fontSize: 11)));
    });
    return list;
  }
}
