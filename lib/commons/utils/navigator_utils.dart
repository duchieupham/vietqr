import 'package:flutter/material.dart';

class NavigatorUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? context() => navigatorKey.currentContext;

  static Future<bool> showGeneralDialog({
    BuildContext? context,
    Widget? child,
  }) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context ?? navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: child!,
          ),
        );
      },
    );

    return data;
  }

  static Future navigatePage(BuildContext context, Widget widget) async {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  static void navigateToRoot(
    BuildContext context,
  ) {
    return Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
