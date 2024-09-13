import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart'; // Assuming this contains the AppColor constants

class StepProgressView extends StatelessWidget {
  final List<Widget> _listItem;
  final int _curStep;
  final Color _activeColor;
  final double _height;
  final Color _inactiveColor;
  final double _lineWidth;
  final Widget? _customSpace;

  StepProgressView({
    super.key,
    required int curStep,
    required double height,
    required List<Widget> listItem,
    required Color activeColor,
    Color? inactiveColor,
    double? lineWidth,
    Widget? customSpace,
  })  : _listItem = listItem,
        _height = height,
        _curStep = curStep,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor ?? activeColor.withOpacity(0.3),
        _lineWidth = lineWidth ?? 2.0,
        _customSpace = customSpace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _height,
      child: Row(
        children: <Widget>[
          Column(
            children: _iconViews(),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _itemViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _listItem.asMap().forEach((i, item) {
      var circleColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;

      // Icon for each step
      list.add(
        _customSpace ??
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: VietQRTheme.gradientColor.brightBlueLinear,
              ),
            ),
      );

      // Dashed line between icons
      if (i != _listItem.length - 1) {
        list.add(
          Expanded(
            child: SizedBox(
              width: _lineWidth,
              child: _dashedLine(lineColor),
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _itemViews() {
    var list = <Widget>[];
    _listItem.asMap().forEach((i, item) {
      var isActive = (i == 0 || _curStep > i + 1);
      list.add(item);
    });
    return list;
  }

  // Method to create a vertical dashed line
  Widget _dashedLine(Color? color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxHeight = constraints.constrainHeight();
        const dashHeight = 5.0;
        const dashSpace = 3.0;
        final dashCount = (boxHeight / (dashHeight + dashSpace)).floor();

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: _lineWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppColor.GREY_DADADA),
              ),
            );
          }),
        );
      },
    );
  }
}
