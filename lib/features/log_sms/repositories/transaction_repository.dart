import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/firestore/transaction_db.dart';

class TransactionRepository {
  const TransactionRepository();
  //step 2
  Future<void> insertTransaction(TransactionDTO transactionDTO) async {
    try {
      await TransactionDB.instance.insertTransaction(transactionDTO);
    } catch (e) {
      print('Error at insertTransaction - TransactionRepository: $e');
    }
  }

  //step 5
  Future<List<TransactionDTO>> getTransactionsByIds(List<String> ids) async {
    List<TransactionDTO> result = [];
    try {
      result = await TransactionDB.instance.getTransactionsByIds(ids);
    } catch (e) {
      print('Error at listenNewTransaction - TransactionRepository: $e');
    }
    return result;
  }

  //step 4
  Future<TransactionDTO> getTransactionById(String id) async {
    TransactionDTO result = TransactionDTO(
      id: '',
      accountBalance: '',
      address: '',
      bankAccount: '',
      bankId: '',
      content: '',
      isFormatted: false,
      status: '',
      timeInserted: FieldValue.serverTimestamp(),
      timeReceived: '',
      transaction: '',
      type: '',
      userId: '',
    );
    try {
      result = await TransactionDB.instance.getTransactionById(id);
    } catch (e) {
      print('Error at getTransactionById - TransactionRepository: $e');
    }
    return result;
  }
}
