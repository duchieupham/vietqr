import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/notification_dto.dart';

class NotificationDB {
  const NotificationDB._privateConsrtructor();

  static const NotificationDB _instance = NotificationDB._privateConsrtructor();
  static NotificationDB get instance => _instance;
  static final notificationDB =
      FirebaseFirestore.instance.collection('notification');

  //listen new data
  Stream<QuerySnapshot> listenNotification(String userId) {
    return FirebaseFirestore.instance
        .collection('notification')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .orderBy('timeCreated', descending: true)
        .snapshots();
  }

  //insert
  Future<bool> insertNotification(NotificationDTO dto) async {
    bool result = false;
    try {
      await notificationDB
          .where('transactionId', isEqualTo: dto.transactionId)
          .where('userId', isEqualTo: dto.userId)
          // .where('timeCreated', isEqualTo: dto.timeCreated)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          await notificationDB.add(dto.toJson()).then((value) => result = true);
        } else {
          result = true;
        }
      });
    } catch (e) {
      print('Error at insertNotification - NotificationDB: $e');
    }
    return result;
  }

  //update status
  Future<bool> updateNotification(String id) async {
    bool result = false;
    try {
      await notificationDB
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.update({'isRead': true});
        }
        result = true;
      });
    } catch (e) {
      print('Error at updateNotification - NotificationDB: $e');
    }
    return result;
  }

  //get list transactionId by userId
  Future<List<String>> getTransactionIdsByUserId(String userId) async {
    List<String> result = [];
    try {
      await notificationDB
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            String userId = querySnapshot.docs[i]['transactionId'];
            result.add(userId);
          }
        }
      });
    } catch (e) {
      print('Error at getTransactionIdsByUserId - NotificationDB: $e');
    }
    return result;
  }

  Future<List<NotificationDTO>> getNotificationByUserId(String userId) async {
    List<NotificationDTO> result = [];
    try {
      await notificationDB
          .where('userId', isEqualTo: userId)
          .orderBy('timeCreated', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            NotificationDTO notificationDTO = NotificationDTO(
              id: data['id'],
              transactionId: data['transactionId'],
              userId: data['userId'],
              type: data['type'],
              message: data['message'],
              timeInserted: data['timeCreated'],
              isRead: data['isRead'],
            );
            result.add(notificationDTO);
          }
        }
      });
    } catch (e) {
      print('Error at getNotificationByUserId - NotificationDB: $e');
    }
    return result;
  }
}
