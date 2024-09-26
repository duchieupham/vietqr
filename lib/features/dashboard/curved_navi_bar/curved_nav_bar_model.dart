import 'package:flutter/material.dart';

class CurvedNavigationBarItem {
  /// Icon of [CurvedNavigationBarItem].
  final String urlSelect;
  final String urlUnselect;
  Widget? child;
  final int index;

  /// Text of [CurvedNavigationBarItem].
  final String? label;

  /// TextStyle for [label].
  final TextStyle? labelStyle;

  final bool isSelected;

  CurvedNavigationBarItem({
    required this.urlSelect,
    required this.urlUnselect,
    this.child,
    this.label,
    this.labelStyle,
    this.isSelected = false,
    required this.index,
  });
}
