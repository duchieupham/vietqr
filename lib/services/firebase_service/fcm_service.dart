import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/top_up/widget/pop_up_top_up_sucsess.dart';
import 'package:vierqr/features/transaction_detail/transaction_detail_screen.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/top_up_sucsess_dto.dart';
import 'package:vierqr/services/local_notification/notification_service.dart';

class FCMService {
  static void onFcmMessage() async {
    await NotificationService().initialNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Xử lý push notification nếu ứng dụng đang chạy
      LOG.info(
          "Push notification received: ${message.notification?.title} - ${message.notification?.body}");
      LOG.info("receive data: ${message.data}");
      if (message.data['notificationType'] != 'N05') {
        NotificationService().showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: json.encode(message.data),
        );
      }
      // NotificationService().showNotification(
      //   title: message.notification?.title,
      //   body: message.notification?.body,
      //   payload: json.encode(message.data),
      // );

      //process when receive data
      if (message.data.isNotEmpty) {
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] == Stringify.NOTI_TYPE_TOPUP) {
          DialogWidget.instance.showModelBottomSheet(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 12),
            height: 500,
            widget: PopupTopUpSuccess(
              dto: TopUpSuccessDTO.fromJson(message.data),
            ),
          );
        }
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] ==
                Stringify.NOTI_TYPE_MOBILE_RECHARGE) {
          if (message.data['paymentMethod'] == "1") {
            DialogWidget.instance.showModelBottomSheet(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 12),
              height: 500,
              widget: PopupTopUpSuccess(
                dto: TopUpSuccessDTO.fromJson(message.data),
              ),
            );
          }
        }
        if (message.data['notificationType'] != null &&
            message.data['notificationType'] ==
                Stringify.NOTI_TYPE_INVOICE_SUCCESS) {
          // BuildContext? checkContext =
          //     NavigationService.context;
          // ModalRoute? modalRoute = ModalRoute.of(checkContext!);
          // String? currentRoute = modalRoute?.settings.name;
          bool? isClose = true;

          // if (currentRoute != null && currentRoute == Routes.INVOICE_DETAIL) {
          //   isClose = true;
          // }
          DialogWidget.instance.showCuperModelPopUp(
            isInvoiceDetail: isClose,
            billNumber: message.data['billNumber'],
            totalAmount: message.data['amount'],
            timePaid: message.data['timePaid'],
          );
        }
      }
      notificationController.sink.add(true);
    });
  }

  static void onFcmMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Xử lý push notification nếu ứng dụng không đang chạy
      if (message.data['transactionReceiveId'] != null) {
        NavigatorUtils.navigatePage(
            context,
            TransactionDetailScreen(
                transactionId: message.data['transactionReceiveId']),
            routeName: TransactionDetailScreen.routeName);
      }
      if (message.notification != null) {
        LOG.info(
            "Push notification clicked: ${message.notification?.title.toString()} - ${message.notification?.body}");
      }
    });
  }

  static void handleMessageOnBackground(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data['transactionReceiveId'] != null) {
            NavigatorUtils.navigatePage(
                context,
                TransactionDetailScreen(
                    transactionId: remoteMessage.data['transactionReceiveId']),
                routeName: TransactionDetailScreen.routeName);
          }
        }
      },
    );
  }
}
