import 'package:flutter/material.dart';

class NavigatorUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? context() => navigatorKey.currentContext;

  static Future<dynamic> showGeneralDialog({
    BuildContext? context,
    Widget? child,
  }) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context ?? navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          insetPadding: const EdgeInsets.symmetric(
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

  static Future navigatePage(BuildContext context, Widget widget,
      {required String routeName}) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => widget,
          settings: RouteSettings(name: routeName)),
    );
  }

  static Future navigatePageReplacement(BuildContext context, Widget widget,
      {required String routeName}) async {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => widget,
          settings: RouteSettings(name: routeName)),
    );
  }

  static void navigateToRoot(BuildContext context) {
    return Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
