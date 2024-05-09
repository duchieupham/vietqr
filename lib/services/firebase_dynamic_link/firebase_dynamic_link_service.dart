import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../commons/constants/configurations/route.dart';
import '../../commons/utils/navigator_utils.dart';
import '../../features/account/account_screen.dart';
import '../../features/maintain_charge/views/dynamic_active_key_screen.dart';
import '../../main.dart';

class DynamicLinkService {
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  static Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (dynamicLinkData.link.path.toString().contains('/service-active') &&
          dynamicLinkData.link.queryParameters['key'] != null) {
        print('New dynamic link: ${dynamicLinkData.link}');
        NavigatorUtils.navigatePage(
            NavigationService.navigatorKey.currentContext!,
            DynamicActiveKeyScreen(
              activeKey: dynamicLinkData.link.queryParameters['key']!,
            ),
            routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
      }
    }).onError((error) {
      // Handle errors here
      print('Error getting dynamic link: $error');
    });
    initUniLinks();
  }

  static Future<void> initUniLinks() async {
    try {
      // final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      // if (initialLink == null) return;
      // handleNaviagtion(initialLink.link.path);
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (initialLink == null) return;
      final Uri? deepLink = initialLink.link;
      handleNaviagtion(deepLink!);
    } catch (e) {
      // Error
    }
  }

  static void handleNaviagtion(Uri deepLink) {
    if (deepLink.path.contains('/service-active') &&
        deepLink.queryParameters['key'] != null) {
      print('New dynamic link: ${deepLink.queryParameters['key']}');

      NavigatorUtils.navigatePage(
          NavigationService.navigatorKey.currentContext!,
          DynamicActiveKeyScreen(activeKey: deepLink.queryParameters['key']!),
          routeName: Routes.DYNAMIC_ACTIVE_KEY_SCREEN);
    }
  }
}
