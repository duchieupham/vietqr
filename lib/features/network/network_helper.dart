import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_bloc.dart';
import 'network_event.dart';

class NetworkHelper {
  static bool isFirst = true;

  static void observeNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      NetworkBloc().add(NetworkNotify(result: result, isFirst: isFirst));
      if (isFirst) isFirst = false;
    });
  }
}
