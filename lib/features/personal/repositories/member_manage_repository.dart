import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/models/bank_member_old_dto.dart';
import 'package:vierqr/models/user_bank_dto.dart';
import 'package:vierqr/models/user_information_dto.dart';
import 'package:vierqr/models/user_phone_dto.dart';
import 'package:vierqr/services/firestore/bank_member_db.dart';
import 'package:vierqr/services/firestore/user_information_db.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class MemberManageRepository {
  const MemberManageRepository();

  Future<bool> addMemberIntoBank(
      String bankId, String phoneNo, String role) async {
    bool result = false;
    try {
      UserPhoneDTO userPhoneDTO =
          await UserInformationDB.instance.findUserIdByphone(phoneNo.trim());
      await BankMemberDB.instance
          .addUserToBankCard(
              bankId, userPhoneDTO.userId, role, userPhoneDTO.phoneNo)
          .then((value) => result = value);
    } catch (e) {
      print('Error at addMemberIntoBank - MemberManageRepository: $e');
    }
    return result;
  }

  Future<bool> removeMemberFromBank(String bankId, String userId) async {
    bool result = false;
    try {
      await BankMemberDB.instance
          .removeUserFromBank(bankId, userId)
          .then((value) => result = value);
    } catch (e) {
      print('Error at removeMemberFromBank - MemberManageRepository: $e');
    }
    return result;
  }

  Future<List<UserBankDTO>> getUsersIntoBank(String bankId) async {
    List<UserBankDTO> result = [];
    try {
      List<BankMemberOldDTO> bankNotifications =
          await BankMemberDB.instance.getListBankNotification(bankId);
      if (bankNotifications.isNotEmpty) {
        for (BankMemberOldDTO element in bankNotifications) {
          UserInformationDTO userInformationDTO = await UserInformationDB
              .instance
              .getUserInformation(element.userId, element.phoneNo);
          UserBankDTO userBankDTO = UserBankDTO(
            id: element.id,
            userId: userInformationDTO.userId,
            bankId: element.bankId,
            fullName: UserInformationUtils.instance.formatFullName(
                userInformationDTO.firstName,
                userInformationDTO.middleName,
                userInformationDTO.lastName),
            phoneNo: UserInformationHelper.instance.getPhoneNo(),
            role: element.role,
          );
          result.add(userBankDTO);
        }
      }
    } catch (e) {
      print('Error at getUsersIntoBank - MemberManageRepository: $e');
    }
    return result;
  }

  //step 3
  Future<List<String>> getUserIdsByBankId(String bankId) async {
    List<String> result = [];
    try {
      result = await BankMemberDB.instance.getUserIdsByBankId(bankId);
    } catch (e) {
      print('Error at getUserIdsByBankId - MemberManageRepository: $e');
    }
    return result;
  }

  //step 5
  // Future<List<String>> getBankIdsByUserId(String userId) async {
  //   List<String> result = [];
  //   try {
  //     result = await BankMemberDB.instance.getBankIdsByUserId(userId);
  //   } catch (e) {
  //     print('Error at getBankIdsByUserId - MemberManageRepository: $e');
  //   }
  //   return result;
  // }
}
