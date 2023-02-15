import 'package:rxdart/rxdart.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/services/firestore/notification_db.dart';

class NotificationRepository {
  static BehaviorSubject<NotificationDTO> notificationController =
      BehaviorSubject<NotificationDTO>();

  NotificationRepository();

  //step 3
  Future<void> insertNotification(NotificationDTO notificationDTO) async {
    try {
      await NotificationDB.instance.insertNotification(notificationDTO);
    } catch (e) {
      print('Error at insertNotification - NotificationRepository: $e');
    }
  }

  //step 4
  void listenNewNotification(String userId) {
    try {
      NotificationDB.instance
          .listenNotification(userId)
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            if (data['userId'] == userId) {
              if (!data['isRead']) {
                if (TimeUtils.instance
                    .checkValidTimeRange(data['timeCreated'], 30)) {
                  NotificationDTO notificationDTO = NotificationDTO(
                    id: data['id'],
                    transactionId: data['transactionId'],
                    userId: data['userId'],
                    message: data['message'],
                    type: data['type'],
                    timeInserted: data['timeCreated'],
                    isRead: data['isRead'],
                  );
                  notificationController.sink.add(notificationDTO);
                }
              }
            }
          }
        }
      });
    } catch (e) {
      print('Error at listenNewNotification - NotificationRepository: $e');
    }
  }

  //step 4
  Future<void> updateStatusNotification(String id) async {
    try {
      await NotificationDB.instance.updateNotification(id);
    } catch (e) {
      print('Error at updateStatusNotification - NotificationRepository: $e');
    }
  }

  //step 4 - update when click into icon notification
  Future<void> updateStatusNotifications(List<String> ids) async {
    try {
      for (String id in ids) {
        await NotificationDB.instance.updateNotification(id);
      }
    } catch (e) {
      print('Error at updateStatusNotifications - NotificationRepository: $e');
    }
  }

  //step 4
  Future<List<NotificationDTO>> getNotifications(String userId) async {
    List<NotificationDTO> result = [];
    try {
      result = await NotificationDB.instance.getNotificationByUserId(userId);
    } catch (e) {
      print('Error at getNotifications - NotificationRepository: $e');
    }
    return result;
  }

  //step 5
  Future<List<String>> getTransactionIdsByUserId(String userId) async {
    List<String> result = [];
    try {
      result = await NotificationDB.instance.getTransactionIdsByUserId(userId);
    } catch (e) {
      print('Error at getTransactionIdsByUserId - NotificationRepository: $e');
    }
    return result;
  }
}
