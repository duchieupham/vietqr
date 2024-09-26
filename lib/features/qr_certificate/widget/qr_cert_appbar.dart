import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class VietQrAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final Color? bgrColor;
  final Widget? title;
  final Widget? leading;
  final double leadingWidth;
  final List<Widget>? actions;
  final bool centerTitle;

  const VietQrAppBar(
      {super.key,
      this.bgrColor,
      this.title,
      this.leading,
      this.actions,
      this.centerTitle = true,
      this.leadingWidth = 50})
      : preferredSize = const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      title: title,
      leading: leading,
      leadingWidth: leadingWidth,
      actions: actions,
      centerTitle: centerTitle,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: bgrColor ?? AppColor.TRANSPARENT,
    );
  }
}
