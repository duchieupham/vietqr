import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../navigator/app_navigator.dart';

class PlatformUtils {
  const PlatformUtils._privateConsrtructor();

  static const PlatformUtils _instance = PlatformUtils._privateConsrtructor();
  static PlatformUtils get instance => _instance;

  bool checkResize(double width) {
    bool check = false;
    check = width >= 600 && kIsWeb;
    return check;
  }

  bool resizeWhen(double width, double widthResize) {
    bool check = false;
    check = ((width >= widthResize) && kIsWeb);
    return check;
  }

  double getDynamicWidth({
    required double screenWidth,
    required double defaultWidth,
    required double minWidth,
  }) {
    double result = 0;
    if (screenWidth < defaultWidth) {
      result = minWidth;
    } else {
      result = defaultWidth;
    }
    return result;
  }

  bool isWeb() {
    return kIsWeb;
  }

  //Mobile flatform contains Android app, iOS app and web mobile app
  bool isMobileFlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return (platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS);
  }

  //check iOS Platform
  bool isIOsApp() {
    BuildContext context = NavigationService.context!;
    final platform = Theme.of(context).platform;
    return (!isWeb() && platform == TargetPlatform.iOS);
  }

  //check android Platform
  bool isAndroidApp() {
    BuildContext context = NavigationService.context!;
    final platform = Theme.of(context).platform;
    return (!isWeb() && platform == TargetPlatform.android);
  }

  bool isPhysicalDevice() {
    final BuildContext context = NavigationService.context!;
    final platform = Theme.of(context).platform;
    bool result = false;
    if (platform == TargetPlatform.android) {
      result = (Platform.environment['ANDROID_EMULATOR_SNAPSHOT'] != null ||
          Platform.environment['ANDROID_EMULATOR_DEVICE'] != null);
    } else if (platform == TargetPlatform.iOS) {
      result = (Platform.environment['SIMULATOR_DEVICE_NAME'] != null);
    }
    return result;
  }
}
