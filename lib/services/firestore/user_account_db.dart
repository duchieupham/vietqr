import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/checking_dto.dart';

class UserAccountDB {
  const UserAccountDB._privateConsrtructor();

  static const UserAccountDB _instance = UserAccountDB._privateConsrtructor();
  static UserAccountDB get instance => _instance;
  static final userAccountDb =
      FirebaseFirestore.instance.collection('user-account');

  Future<CheckingDTO> insertUserAccount(Map<String, dynamic> data) async {
    CheckingDTO result = const CheckingDTO(check: false, message: '');
    try {
      //check phone no that is existed in system
      //then insert
      await userAccountDb
          .where('phoneNo', isEqualTo: data['phoneNo'])
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isEmpty) {
          await userAccountDb.add(data).then(
                (value) => result = const CheckingDTO(check: true, message: ''),
              );
        } else {
          result = const CheckingDTO(
              check: false,
              message:
                  'Số điện thoại đã tồn tại trong hệ thống. Vui lòng sử dụng số điện thoại khác.');
        }
      });
    } catch (e) {
      result = const CheckingDTO(
          check: false,
          message: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.');
      print('Error at insertUserAccount - UserAccountDB: $e');
    }
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(
      String userId, String oldPassword, String newPassword) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      await userAccountDb
          .where('id', isEqualTo: userId)
          .where('password', isEqualTo: oldPassword)
          .get()
          .then(
        (QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference
                .update({'password': newPassword}).then((_) {
              result = {'check': true, 'msg': ''};
            });
          } else {
            result = {
              'check': false,
              'msg': 'Mật khẩu cũ không chính xác, vui lòng thử lại.'
            };
          }
        },
      );
    } catch (e) {
      result = {'check': false, 'msg': 'Vui lòng kiểm tra lại kết nối mạng.'};
      print('Error at updatePassword - UserAccountDB: $e');
    }
    return result;
  }

  Future<String> login(String phone, String password) async {
    String result = '';
    try {
      await userAccountDb
          .where('phoneNo', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          result = querySnapshot.docs.first['id'] ?? '';
        }
      });
    } catch (e) {
      print('Error at login - UserAccountDB: $e');
    }
    return result;
  }
}
