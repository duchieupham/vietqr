import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialNotification() async {
    if (notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    }

    AndroidInitializationSettings androidInitializationSettingsAndroid =
        const AndroidInitializationSettings('icon');
    var initializationSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }
}
