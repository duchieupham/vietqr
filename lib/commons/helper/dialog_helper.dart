import 'package:flutter/material.dart';

mixin DialogHelper {
  static final _allPopups = <Key, BuildContext>{};

  void dismissAllPopups() {
    for (final context in _allPopups.values) {
      Navigator.of(context).pop();
    }
    _allPopups.clear();
  }

  void dismissPopup({required Key key, bool willPop = true}) {
    final aContext = _allPopups[key];
    if (aContext != null) {
      _allPopups.remove(key);
      if (willPop) {
        Navigator.of(aContext).pop();
      }
    }
  }

  Key _keyForPopup() {
    return UniqueKey();
  }

  Future<void> showXDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    Key? key,
    String? closeItemLabel,
    List<Widget>? actions,
    Function()? onDialogClosed,
    double? width,
    double? height,
    Widget? headerWidget,
    Widget? footerWidget,
    bool barrierDismissible = false,
    EdgeInsetsGeometry? padding,
  }) async {
    Key keyDialog = key ?? _keyForPopup();
    _allPopups[keyDialog] = context;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: padding,
            width: width,
            height: height,
            child: Column(),
          ),
        );
      },
    ).then((value) {
      if (onDialogClosed != null) {
        onDialogClosed();
      }
      dismissPopup(key: keyDialog, willPop: false);
    });
  }
}
