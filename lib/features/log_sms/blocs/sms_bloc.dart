// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vierqr/commons/utils/bank_information_utils.dart';
// import 'package:vierqr/commons/utils/sms_information_utils.dart';
// import 'package:vierqr/features/log_sms/events/sms_event.dart';
// import 'package:vierqr/features/log_sms/repositories/sms_repository.dart';
// import 'package:vierqr/features/log_sms/states/sms_state.dart';
// import 'package:vierqr/features/bank_card/repositories/bank_manage_repository.dart';
// import 'package:vierqr/models/bank_account_dto.dart';
// import 'package:vierqr/models/bank_information_dto.dart';
// import 'package:vierqr/models/message_dto.dart';
// import 'package:vierqr/models/transaction_dto.dart';
// import 'package:vierqr/services/shared_references/event_bloc_helper.dart';

// class SMSBloc extends Bloc<SMSEvent, SMSState> {
//   SMSBloc() : super(SMSInitialState()) {
//     on<SMSEventGetList>(_getList);
//     on<SMSEventListen>(_listenNewSMS);
//     on<SMSEventReceived>(_receivedNewSMS);
//   }
// }

// const SmsRepository smsRepository = SmsRepository();
// const BankManageRepository bankManageRepository = BankManageRepository();

// void _getList(SMSEvent event, Emitter emit) async {
//   try {
//     if (event is SMSEventGetList) {
//       Map<String, List<MessageDTO>> messages =
//           await smsRepository.getListMessage();
//       emit(SMSSuccessfulListState(messages: messages));
//     }
//   } catch (e) {
//     print('Error at _getList - SMSBloc: $e');
//     emit(const SMSFailedListState());
//   }
// }

// void _listenNewSMS(SMSEvent event, Emitter emit) async {
//   try {
//     if (event is SMSEventListen) {
//       if (EventBlocHelper.instance.isLogoutBefore()) {
//         SmsRepository.smsListenController.close();
//         SmsRepository.smsListenController = BehaviorSubject<MessageDTO>();
//         await EventBlocHelper.instance.updateListenSMS(false);
//       }
//       if (!EventBlocHelper.instance.isListenedSMS()) {
//         List<BankAccountDTO> bankAccounts = [...[], ...[]];
//         smsRepository.listenNewSMS(bankAccounts);
//         SmsRepository.smsListenController.sink.add(
//           const MessageDTO(
//               id: 0,
//               threadId: 0,
//               address: '',
//               body: '',
//               date: '',
//               dateSent: '',
//               read: false),
//         );
//         await EventBlocHelper.instance.updateListenSMS(true);
//         SmsRepository.smsListenController.listen((messageDTO) {
//           if (messageDTO.address.isNotEmpty) {
//             event.smsBloc.add(
//                 SMSEventReceived(messageDTO: messageDTO, userId: event.userId));
//           }
//         });
//       }
//     }
//   } catch (e) {
//     print('Error at _listenNewSMS - SMSBloc: $e');
//     emit(const SMSListenFailedState());
//   }
// }

// void _receivedNewSMS(SMSEvent event, Emitter emit) async {
//   try {
//     const Uuid uuid = Uuid();
//     TransactionDTO transactionDTO = TransactionDTO(
//       id: uuid.v1(),
//       accountBalance: '',
//       address: '',
//       bankAccount: '',
//       bankId: '',
//       content: '',
//       isFormatted: false,
//       status: 'PAID',
//       timeInserted: FieldValue.serverTimestamp(),
//       timeReceived: '',
//       transaction: '',
//       type: 'SMS',
//       userId: '',
//     );
//     if (event is SMSEventReceived) {
//       if (BankInformationUtil.instance
//           .checkAvailableAddress(event.messageDTO.address)) {
//         final BankInformationDTO bankInformationDTO =
//             SmsInformationUtils.instance.transferSmsData(
//           BankInformationUtil.instance.getBankName(event.messageDTO.address),
//           event.messageDTO.body,
//           event.messageDTO.date,
//         );
//         final String bankId = await bankManageRepository.getBankIdByBankAccount(
//             event.userId, bankInformationDTO.bankAccount);
//         if (bankId.isNotEmpty) {
//           transactionDTO = TransactionDTO(
//             id: uuid.v1(),
//             accountBalance: bankInformationDTO.accountBalance,
//             address: bankInformationDTO.address,
//             bankAccount: bankInformationDTO.bankAccount,
//             bankId: bankId,
//             content: bankInformationDTO.content,
//             isFormatted: true,
//             status: 'PAID',
//             timeInserted: FieldValue.serverTimestamp(),
//             timeReceived: bankInformationDTO.time,
//             transaction: bankInformationDTO.transaction,
//             type: 'SMS',
//             userId: event.userId,
//           );
//         }
//       }
//       emit(SMSReceivedState(
//           messageDTO: event.messageDTO, transactionDTO: transactionDTO));
//     }
//   } catch (e) {
//     print('Error at _receivedNewSMS - SMSBloc: $e');
//     emit(const SMSReceivedFailedState());
//   }
// }
