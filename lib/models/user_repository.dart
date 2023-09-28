import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => HivePrefs.instance.prefs!;

  String get userId => UserInformationHelper.instance.getUserId();

  String get intro_key => '${userId}_card';

  List<BankTypeDTO> banks = [];

  bool isIntroContact = false;

  bool getIntroContact() {
    return isIntroContact = _box.get(intro_key) ?? false;
  }

  Future<void> updateIntroContact(bool value) async {
    isIntroContact = value;
    await _box.put(intro_key, value);
  }
}
