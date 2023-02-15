import 'package:vierqr/models/user_information_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/user_phone_dto.dart';

class UserInformationDB {
  const UserInformationDB._privateConsrtructor();

  static const UserInformationDB _instance =
      UserInformationDB._privateConsrtructor();
  static UserInformationDB get instance => _instance;
  static final userInformationDb =
      FirebaseFirestore.instance.collection('user-information');

  Future<UserPhoneDTO> findUserIdByphone(String phoneNo) async {
    UserPhoneDTO result = UserPhoneDTO(userId: '', phoneNo: phoneNo);
    try {
      await userInformationDb
          .where('phoneNo', isEqualTo: phoneNo)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          result = UserPhoneDTO(
            userId: querySnapshot.docs.first['id'] ?? '',
            phoneNo: phoneNo,
          );
        }
      });
    } catch (e) {
      print('Error at findUserByPhoneNo - UserInformationDB: $e');
    }
    return result;
  }

  Future<bool> insertUserInformation(Map<String, dynamic> data) async {
    bool result = false;
    try {
      await userInformationDb.add(data).then((value) => result = true);
    } catch (e) {
      print('Error at insertUserInformation - UserInformationDB: $e');
    }
    return result;
  }

  Future<bool> updateUserInformation(UserInformationDTO dto) async {
    bool result = false;
    try {
      await userInformationDb
          .where('id', isEqualTo: dto.userId)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference
              .update(dto.toJson())
              .then((value) => result = true);
        }
      });
    } catch (e) {
      print('Error at updateUserInformation - UserInformationDB: $e');
    }
    return result;
  }

  Future<UserInformationDTO> getUserInformation(
      String userId, String? phoneNo) async {
    UserInformationDTO result = const UserInformationDTO(
      userId: '',
      firstName: 'Undefined',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      address: '',
      email: '',
    );
    try {
      await userInformationDb
          .where('id', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String userId = querySnapshot.docs.first['id'] ?? '';
          String firstName =
              querySnapshot.docs.first['firstName'] ?? 'Undefined';
          String middleName = querySnapshot.docs.first['middleName'] ?? '';
          String lastName = querySnapshot.docs.first['lastName'] ?? '';
          String birthDate = querySnapshot.docs.first['birthDate'] ?? '';
          String phone = querySnapshot.docs.first['phoneNo'] ?? phoneNo ?? '';
          bool gender = querySnapshot.docs.first['gender'] ?? 'false';
          String address = querySnapshot.docs.first['address'] ?? '';
          String email = querySnapshot.docs.first['email'] ?? '';
          result = UserInformationDTO(
            userId: userId,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            birthDate: birthDate,
            gender: int.tryParse(gender.toString()) ?? 0,
            address: address,
            email: email,
          );
        }
      });
    } catch (e) {
      print('Error at getUserInformation - UserInformationDB: $e');
    }
    return result;
  }
}
