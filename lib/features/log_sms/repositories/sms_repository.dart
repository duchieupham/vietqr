import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart' as smslistener;
import 'package:rxdart/rxdart.dart';

class SmsRepository {
  static BehaviorSubject<MessageDTO> smsListenController =
      BehaviorSubject<MessageDTO>();

  const SmsRepository();

  //step 1
  Future<Map<String, List<MessageDTO>>> getListMessage() async {
    Map<String, List<MessageDTO>> result = {};
    try {
      final SmsQuery query = SmsQuery();
      List<SmsMessage> messages = await query.getAllSms;
      if (messages.isNotEmpty) {
        for (int i = 0; i < messages.length; i++) {
          if (BankInformationUtil.instance
              .checkBankAddress(messages[i].address.toString())) {
            MessageDTO dto = MessageDTO(
                id: messages[i].id ?? 0,
                threadId: messages[i].threadId ?? 0,
                address: messages[i].address ?? '',
                body: messages[i].body ?? '',
                date: messages[i].date.toString(),
                dateSent: messages[i].dateSent.toString(),
                read: messages[i].read ?? false);
            if (result.containsKey(messages[i].address)) {
              result[messages[i].address]!.add(
                dto,
              );
            } else {
              result[messages[i].address ?? ''] = [];
              result[messages[i].address]!.add(
                dto,
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error at getListMessage - SmsRepository: $e');
    }
    return result;
  }

  //step 1
  void listenNewSMS(List<BankAccountDTO> bankAccounts) {
    print('-------bank account length: ${bankAccounts.length}');
    try {
      smslistener.FlutterSmsListener smsListener =
          smslistener.FlutterSmsListener();
      smsListener.onSmsReceived!.listen((msg) {
        //some address bank maybe not match with these existed addresses.
        if (BankInformationUtil.instance
            .checkBankAddress(msg.address.toString())) {
          MessageDTO messageDTO = MessageDTO(
              id: msg.id ?? 0,
              threadId: msg.threadId ?? 0,
              address: msg.address ?? '',
              body: msg.body ?? '',
              date: msg.date.toString(),
              dateSent: msg.dateSent.toString(),
              read: msg.read ?? false);
          if (bankAccounts.isNotEmpty) {
            if (bankAccounts
                .where((element) =>
                    element.bankCode.trim().toUpperCase() ==
                    messageDTO.address.trim().toUpperCase())
                .isNotEmpty) {
              smsListenController.sink.add(messageDTO);
            }
          }
        }
      });
    } catch (e) {
      print('Error at listenNewSMS - SmsRepository: $e');
    }
  }
}
