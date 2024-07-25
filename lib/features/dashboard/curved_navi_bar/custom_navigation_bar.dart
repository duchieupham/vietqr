import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import 'curved_nav_bar_model.dart';
import 'nav_bar_item.dart';
import 'nav_custom_painter.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBar extends StatefulWidget {
  /// Defines the appearance of the [CurvedNavigationBarItem] list that are
  /// arrayed within the bottom navigation bar.
  final List<CurvedNavigationBarItem> items;

  /// The index into [items] for the current active [CurvedNavigationBarItem].
  final int indexPage;

  /// The index into [items] for the current PaintCustom
  final int indexPaint;

  /// The color of the [CurvedNavigationBar] itself, default Colors.white.
  final Color color;

  /// The background color of floating button, default same as [color] attribute.
  final Color? buttonBackgroundColor;

  /// The color of [CurvedNavigationBar]'s background, default Colors.blueAccent.
  final Color backgroundColor;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int> onTap;

  /// Function which takes page index as argument and returns bool. If function
  /// returns false then page is not changed on button tap. It returns true by
  /// default.
  final _LetIndexPage letIndexChange;

  /// Curves interpolating button change animation, default Curves.easeOut.
  final Curve animationCurve;

  /// Duration of button change animation, default Duration(milliseconds: 600).
  final Duration animationDuration;

  /// Height of [CurvedNavigationBar].
  final double height;

  /// Padding of icon in floating button.
  final double iconPadding;

  /// Check if [CurvedNavigationBar] has label.
  final bool hasLabel;
  final bool isAnimation;

  final Stream<int> stream;

  CurvedNavigationBar({
    super.key,
    required this.items,
    this.indexPaint = -1,
    this.indexPage = -1,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    required this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.iconPadding = 12.0,
    this.isAnimation = false,
    double? height,
    required this.stream,
  })  : assert(items.isNotEmpty),
        assert(0 <= indexPaint && indexPaint < items.length),
        letIndexChange = letIndexChange ?? ((_) => true),
        height = height ?? (Platform.isAndroid ? 70.0 : 80.0),
        hasLabel = items.any((item) => item.label != null);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  late double _pos;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;
  int _endingIndex = 0;
  double _buttonHide = 0;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      _endingIndex = event;
      if (!mounted) return;
      setState(() {});
    });

    if (widget.indexPaint != -1) {
      _icon = Image.asset(
        'assets/images/ic-menu-slide-home-blue.png',
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    }

    if (widget.isAnimation) {
      _pos = widget.indexPaint / _length;
    } else {
      _pos = 0.4;
    }

    _length = widget.items.length;
    _startingPos = widget.indexPaint / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    if (widget.isAnimation) {
      _animationController.addListener(() {
        setState(() {
          _pos = _animationController.value;
          final endingPos = _endingIndex / widget.items.length;
          final middle = (endingPos + _startingPos) / 2;
          if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
            _icon = Image.asset(
              widget.items[_endingIndex].urlSelect,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            );
          }
          _buttonHide =
              (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
        });
      });
    }
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.indexPaint != widget.indexPaint) {
      final newPosition = widget.indexPaint / _length;
      _startingPos = _pos;
      _endingIndex = widget.indexPaint;
      _animationController.animateTo(
        newPosition,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: widget.backgroundColor,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Selected button
          Positioned(
            bottom: widget.height - 120.0,
            left: Directionality.of(context) == TextDirection.rtl
                ? null
                : _pos * size.width,
            right: Directionality.of(context) == TextDirection.rtl
                ? _pos * size.width
                : null,
            width: size.width / _length,
            child: Center(
              child: Transform.translate(
                offset: Offset(0, (_buttonHide - 1) * 80),
                child: Material(
                  color: widget.buttonBackgroundColor ?? widget.color,
                  type: MaterialType.circle,
                  child: Padding(
                    padding: EdgeInsets.all(widget.iconPadding),
                    child: _icon,
                  ),
                ),
              ),
            ),
          ),
          // Background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              painter: NavCustomPainter(
                startingLoc: _pos,
                itemsLength: _length,
                color: widget.color,
                textDirection: Directionality.of(context),
                hasLabel: widget.hasLabel,
              ),
              child: Container(height: widget.height),
            ),
          ),
          // Unselected buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: widget.height,
              child: Row(
                children: widget.items.map((item) {
                  int indexOf = widget.items.indexOf(item);
                  return NavBarItemWidget(
                    onTap: (index) {
                      _buttonTap(item.index);
                    },
                    position: _pos,
                    length: _length,
                    index: indexOf,
                    label: item.label,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: item.index == _endingIndex
                          ? AppColor.BLUE_TEXT
                          : null,
                    ),
                    child: Center(
                      child: item.child ??
                          XImage(
                            imagePath: item.urlUnselect,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            color: item.index == _endingIndex
                                ? AppColor.BLUE_TEXT
                                : null,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index) || _animationController.isAnimating) {
      return;
    }
    widget.onTap(index);
    if (index < 0) return;
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(
        newPosition,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    });
  }
}
