import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/transaction_dto.dart';

class TransactionDB {
  const TransactionDB._privateConsrtructor();

  static const TransactionDB _instance = TransactionDB._privateConsrtructor();
  static TransactionDB get instance => _instance;
  static final transactionDb =
      FirebaseFirestore.instance.collection('transaction');

  Future<bool> insertTransaction(TransactionDTO dto) async {
    bool result = false;
    try {
      await transactionDb.add(dto.toJson()).then((value) => result = true);
    } catch (e) {
      print('Error at insertTransaction - TransactionDB: $e');
    }
    return result;
  }

  Stream<QuerySnapshot> listenTransactionBy(List<String> bankIds) {
    return FirebaseFirestore.instance
        .collection('transaction')
        .where('bankId', whereIn: bankIds)
        .snapshots();
  }

  Future<List<TransactionDTO>> getTransactionsByIds(List<String> ids) async {
    List<TransactionDTO> result = [];
    try {
      for (String id in ids) {
        await transactionDb
            .where('id', isEqualTo: id)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            String id = querySnapshot.docs.first['id'] ?? '';
            String accountBalance =
                querySnapshot.docs.first['accountBalance'] ?? '';
            String address = querySnapshot.docs.first['address'] ?? '';
            String bankAccount = querySnapshot.docs.first['bankAccount'] ?? '';
            String bankId = querySnapshot.docs.first['bankId'] ?? '';
            String content = querySnapshot.docs.first['content'] ?? '';
            bool isFormatted = querySnapshot.docs.first['isFormatted'] ?? false;
            String status = querySnapshot.docs.first['status'] ?? '';
            dynamic timeInserted = querySnapshot.docs.first['timeCreated'];
            String timeReceived =
                querySnapshot.docs.first['timeReceived'] ?? '';
            String transaction = querySnapshot.docs.first['transaction'] ?? '';
            String type = querySnapshot.docs.first['type'] ?? '';
            String userId = querySnapshot.docs.first['userId'] ?? '';
            TransactionDTO dto = TransactionDTO(
              id: id,
              accountBalance: accountBalance,
              address: address,
              bankAccount: bankAccount,
              bankId: bankId,
              content: content,
              isFormatted: isFormatted,
              status: status,
              timeInserted: timeInserted,
              timeReceived: timeReceived,
              transaction: transaction,
              type: type,
              userId: userId,
            );
            result.add(dto);
          }
        });
      }
    } catch (e) {
      print('Error at getTransactionsByIds - TransactionDB: $e');
    }

    result.sort((a, b) {
      DateTime dateA = DateTime.fromMicrosecondsSinceEpoch(
          a.timeInserted.microsecondsSinceEpoch);
      DateTime dateB = DateTime.fromMicrosecondsSinceEpoch(
          b.timeInserted.microsecondsSinceEpoch);
      return dateB.compareTo(dateA);
    });
    return result;
  }

  Future<TransactionDTO> getTransactionById(String id) async {
    TransactionDTO result = const TransactionDTO(
      id: '',
      accountBalance: '',
      address: '',
      bankAccount: '',
      bankId: '',
      content: '',
      isFormatted: false,
      status: '',
      timeInserted: null,
      timeReceived: '',
      transaction: '',
      type: '',
      userId: '',
    );
    try {
      await transactionDb
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String id = querySnapshot.docs.first['id'] ?? '';
          String accountBalance =
              querySnapshot.docs.first['accountBalance'] ?? '';
          String address = querySnapshot.docs.first['address'] ?? '';
          String bankAccount = querySnapshot.docs.first['bankAccount'] ?? '';
          String bankId = querySnapshot.docs.first['bankId'] ?? '';
          String content = querySnapshot.docs.first['content'] ?? '';
          bool isFormatted = querySnapshot.docs.first['isFormatted'] ?? false;
          String status = querySnapshot.docs.first['status'] ?? '';
          dynamic timeInserted = querySnapshot.docs.first['timeCreated'];
          String timeReceived = querySnapshot.docs.first['timeReceived'] ?? '';
          String transaction = querySnapshot.docs.first['transaction'] ?? '';
          String type = querySnapshot.docs.first['type'] ?? '';
          String userId = querySnapshot.docs.first['userId'] ?? '';
          result = TransactionDTO(
            id: id,
            accountBalance: accountBalance,
            address: address,
            bankAccount: bankAccount,
            bankId: bankId,
            content: content,
            isFormatted: isFormatted,
            status: status,
            timeInserted: timeInserted,
            timeReceived: timeReceived,
            transaction: transaction,
            type: type,
            userId: userId,
          );
        }
      });
    } catch (e) {
      print('Error at getTransactionById - TransactionDB: $e');
    }
    return result;
  }
}
