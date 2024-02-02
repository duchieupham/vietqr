import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/main.dart';

import 'network_bloc.dart';
import 'network_event.dart';

class NetworkHelper {
  static bool isFirst = true;
  static bool isInternet = false;

  static bool get mounted =>
      NavigationService.navigatorKey.currentContext?.mounted ?? false;

  static Connectivity _connectivity = Connectivity();

  static void observeNetwork() {
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  static Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      LOG.error('Couldn\'t check connectivity status $e');
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  static Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (isInternet) {
          NetworkBloc().add(
              NetworkNotify(result: TypeInternet.CONNECT, isFirst: isFirst));
          _onChangeInternet(false);
        }
      } else {
        if (!isInternet) {
          NetworkBloc().add(
              NetworkNotify(result: TypeInternet.DISCONNECT, isFirst: isFirst));
          _onChangeInternet(true);
        }
      }
    } on SocketException catch (_) {
      if (!isInternet) {
        NetworkBloc().add(
            NetworkNotify(result: TypeInternet.DISCONNECT, isFirst: isFirst));
        _onChangeInternet(true);
      }
    }
  }

  static Future<void> _onChangeInternet(bool isInternet) async {
    await Future.delayed(Duration(seconds: 3)).then((v) {
      if (!mounted) return;
      NetworkBloc()
          .add(NetworkNotify(result: TypeInternet.NONE, isFirst: isFirst));
      updateInternet(isInternet);
    });
  }

  static Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      if (!isInternet) {
        NetworkBloc().add(
            NetworkNotify(result: TypeInternet.DISCONNECT, isFirst: isFirst));
        _onChangeInternet(true);
      }
    } else {
      checkConnection();
    }
  }

  static void update() {
    isFirst = false;
  }

  static void updateInternet(bool value) {
    isInternet = value;
  }
}
