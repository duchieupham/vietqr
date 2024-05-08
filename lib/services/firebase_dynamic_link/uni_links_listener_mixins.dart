import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';

abstract class UniLinksCallback {
  void onUniLink(Uri uri);

  void getInitUri(Uri? uri);
}

mixin UniLinksListenerMixin<T extends StatefulWidget> on State<T>
    implements UniLinksCallback {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    closeUniLinks();
    super.dispose();
  }

  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      // Use the uri and warn the user, if it is not correct
      if (uri != null) {
        debugPrint('onUniLink: $uri');
        onUniLink(uri);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  void closeUniLinks() {
    if (_sub != null) {
      _sub!.cancel();
      _sub = null;
    }
  }

  Future<void> getInitUniLinks() async {
    // Uri parsing may fail, so we use a try/catch FormatException.
    try {
      final initialUri = await getInitialUri();
      // Use the uri and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      if (initialUri != null) {
        debugPrint('getInitUniLinks: $initialUri');
        getInitUri(initialUri);
      }
    } on FormatException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
