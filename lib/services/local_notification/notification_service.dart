import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialNotification() async {
    // if (notificationsPlugin.resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>() !=
    //     null) {
    //   notificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //           AndroidFlutterLocalNotificationsPlugin>()!
    //       .requestPermission();
    // }

    AndroidInitializationSettings androidInitializationSettingsAndroid =
        const AndroidInitializationSettings('icon');

    var initializationSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        LOG.info('onDidReceiveLocalNotification iOS: $title - $body');
      },
    );

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettingsAndroid,
      iOS: initializationSettingIOS,
    );

    await notificationsPlugin.initialize(
      initializationSetting,

      onDidReceiveNotificationResponse: (details) async {
        Map<String, dynamic> data = json.decode(details.payload!);
        if (data['transactionReceiveId'] != null) {
          NavigatorUtils.navigatePage(
              NavigationService.navigatorKey.currentContext!,
              TransactionDetailScreen(
                  transactionId: data['transactionReceiveId']),
              routeName: TransactionDetailScreen.routeName);
        }

        LOG.info('onDidReceiveNotificationResponse: ${details.payload}');
      },
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   LOG.info(
      //       'onDidReceiveBackgroundNotificationResponse: ${details.payload}');
      // },
    );
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        playSound: true,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'notification_sound.aiff',
        presentSound: true,
      ),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payload);
  }
}
