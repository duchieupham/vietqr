import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/code_login_dto.dart';

class CodeLoginDB {
  const CodeLoginDB._privateConsrtructor();

  static const CodeLoginDB _instance = CodeLoginDB._privateConsrtructor();
  static CodeLoginDB get instance => _instance;
  static final codeLoginDB =
      FirebaseFirestore.instance.collection('code-login');

  //listen response when userId is updated
  Stream<QuerySnapshot> listenLoginCode(String code) {
    return FirebaseFirestore.instance
        .collection('code-login')
        .where('code', isEqualTo: code)
        .where('isScanned', isEqualTo: true)
        .where('userId', isNotEqualTo: '')
        .snapshots();
  }

  //insert
  Future<bool> insertCodeLogin(CodeLoginDTO dto) async {
    bool result = false;
    try {
      await codeLoginDB.add(dto.toJson()).then((value) => result = true);
    } catch (e) {
      print('Error at insertCodeLogin - CodeLoginDB: $e');
    }
    return result;
  }

  //update
  Future<void> updateCodeLogin(CodeLoginDTO dto) async {
    try {
      await codeLoginDB
          .where('code', isEqualTo: dto.code)
          .where('isScanned', isEqualTo: false)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.update(dto.toJson());
        }
      });
    } catch (e) {
      print('Error at updateCodeLogin - CodeLoginDB: $e');
    }
  }

  //delete
  Future<bool> deleteCodeLogin(String code) async {
    bool result = false;
    try {
      await codeLoginDB
          .where('code', isEqualTo: code)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
        }
        result = true;
      });
    } catch (e) {
      print('Error at deleteCodeLogin - CodeLoginDB: $e');
    }
    return result;
  }
}
