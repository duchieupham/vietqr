import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  String get userId => UserInformationHelper.instance.getUserId();

  List<BankTypeDTO> banks = [];
}
