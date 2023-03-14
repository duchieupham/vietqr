// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vierqr/commons/constants/configurations/stringify.dart';
// import 'package:vierqr/models/bank_member_old_dto.dart';

// class BankMemberDB {
//   const BankMemberDB._privateConsrtructor();

//   static const BankMemberDB _instance = BankMemberDB._privateConsrtructor();
//   static BankMemberDB get instance => _instance;
//   static final bankMemberDb =
//       FirebaseFirestore.instance.collection('bank-member');

//   Future<List<String>> getBankIdsByUserId(String userId) async {
//     List<String> result = [];
//     try {
//       await bankMemberDb
//           .where('userId', isEqualTo: userId)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           for (var element in querySnapshot.docs) {
//             String bankId = element['bankId'] ?? '';
//             result.add(bankId);
//           }
//         }
//       });
//     } catch (e) {
//       print('Error at getBankIdsByUserId - BankMemberDB: $e');
//     }

//     return result;
//   }

//   //to get list other bank
//   Future<List<String>> getListBankIdByUserId(String userId) async {
//     List<String> result = [];
//     try {
//       await bankMemberDb
//           .where('userId', isEqualTo: userId)
//           .where('role', isNotEqualTo: Stringify.ROLE_CARD_MEMBER_ADMIN)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           for (var element in querySnapshot.docs) {
//             String bankId = element['bankId'] ?? '';
//             result.add(bankId);
//           }
//         }
//       });
//     } catch (e) {
//       print('Error at getListBankIdByUserId - BankMemberDB: $e');
//     }

//     return result;
//   }

//   //to get list userIds by specific bankId
//   Future<List<String>> getUserIdsByBankId(String bankId) async {
//     List<String> result = [];
//     try {
//       await bankMemberDb
//           .where('bankId', isEqualTo: bankId)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           for (var element in querySnapshot.docs) {
//             String userId = element['userId'] ?? '';
//             if (userId.isNotEmpty) {
//               result.add(userId);
//             }
//           }
//         }
//       });
//     } catch (e) {
//       print('Error at getUserIdsByBankId - BankMemberDB: $e');
//     }

//     return result;
//   }

//   Future<List<BankMemberOldDTO>> getListBankNotification(String bankId) async {
//     List<BankMemberOldDTO> result = [];
//     try {
//       await bankMemberDb
//           .where('bankId', isEqualTo: bankId)
//           .orderBy('time', descending: true)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           for (var element in querySnapshot.docs) {
//             BankMemberOldDTO dto = BankMemberOldDTO(
//               id: element['id'] ?? '',
//               bankId: element['bankId'] ?? '',
//               userId: element['userId'] ?? '',
//               role: element['role'] ?? '',
//               phoneNo: element['phoneNo'] ?? '',
//               time: element['time'] ?? FieldValue.serverTimestamp(),
//             );
//             result.add(dto);
//           }
//         }
//       });
//     } catch (e) {
//       print('Error at getListBankNotification - BankMemberDB: $e');
//     }
//     return result;
//   }

//   Future<bool> addUserToBankCard(
//       String bankId, String userId, String role, String phoneNo) async {
//     bool result = false;
//     try {
//       if (userId != '') {
//         await bankMemberDb
//             .where('bankId', isEqualTo: bankId)
//             .where('userId', isEqualTo: userId)
//             .get()
//             .then((QuerySnapshot querySnapshot) async {
//           if (querySnapshot.docs.isEmpty) {
//             const Uuid uuid = Uuid();
//             BankMemberOldDTO dto = BankMemberOldDTO(
//               id: uuid.v1(),
//               bankId: bankId,
//               userId: userId,
//               role: role,
//               phoneNo: phoneNo,
//               time: FieldValue.serverTimestamp(),
//             );
//             await bankMemberDb.add(dto.toJson()).then((value) => result = true);
//           }
//         });
//       } else {
//         const Uuid uuid = Uuid();
//         BankMemberOldDTO dto = BankMemberOldDTO(
//           id: uuid.v1(),
//           bankId: bankId,
//           userId: userId,
//           role: role,
//           phoneNo: phoneNo,
//           time: FieldValue.serverTimestamp(),
//         );
//         await bankMemberDb.add(dto.toJson()).then((value) => result = true);
//       }
//     } catch (e) {
//       print('Error at addParentUser - BankMemberDB: $e');
//     }
//     return result;
//   }

//   Future<bool> removeUserFromBank(String bankId, String userId) async {
//     bool result = false;
//     try {
//       await bankMemberDb
//           .where('bankId', isEqualTo: bankId)
//           .where('userId', isEqualTo: userId)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           await querySnapshot.docs.first.reference
//               .delete()
//               .then((value) => result = true);
//         }
//       });
//     } catch (e) {
//       print('Error at removeUserFromBank - BankMemberDB: $e');
//     }
//     return result;
//   }

//   Future<bool> removeAllUsers(String bankId) async {
//     bool result = false;
//     try {
//       await bankMemberDb
//           .where('bankId', isEqualTo: bankId)
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         if (querySnapshot.docs.isNotEmpty) {
//           for (int i = 0; i < querySnapshot.docs.length; i++) {
//             await querySnapshot.docs[i].reference
//                 .delete()
//                 .then((value) => result = true);
//           }
//         }
//       });
//     } catch (e) {
//       print('Error at removeAllUsers - BankMemberDB: $e');
//     }
//     return result;
//   }

//   // Future<bool> addUsers(String bankId, List<String> userIds) async {
//   //   bool result = false;
//   //   try {
//   //     await bankMemberDb
//   //         .where('bankId', isEqualTo: bankId)
//   //         .get()
//   //         .then((QuerySnapshot querySnapshot) async {
//   //       //
//   //       if (querySnapshot.docs.isNotEmpty) {
//   //         for (String userId in userIds) {
//   //           for (var element in querySnapshot.docs) {
//   //             if (userId != element['userId']) {
//   //               const Uuid uuid = Uuid();
//   //               BankMemberOldDTO dto = BankMemberOldDTO(
//   //                 id: uuid.v1(),
//   //                 bankId: bankId,
//   //                 userId: userId,
//   //                 role: 'child',
//   //                 time: FieldValue.serverTimestamp(),
//   //               );
//   //               await bankMemberDb
//   //                   .add(dto.toJson())
//   //                   .then((value) => result = true);
//   //             }
//   //           }
//   //         }
//   //       } else {
//   //         for (String userId in userIds) {
//   //           const Uuid uuid = Uuid();
//   //           BankMemberOldDTO dto = BankMemberOldDTO(
//   //             id: uuid.v1(),
//   //             bankId: bankId,
//   //             userId: userId,
//   //             role: 'child',
//   //             time: FieldValue.serverTimestamp(),
//   //           );
//   //           await bankMemberDb
//   //               .add(dto.toJson())
//   //               .then((value) => result = true);
//   //         }
//   //       }
//   //     });
//   //   } catch (e) {
//   //     print('Error at addUsers - BankMemberDB: $e');
//   //   }
//   //   return result;
//   // }

// }
