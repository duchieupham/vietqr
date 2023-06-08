import 'package:hive/hive.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => SharedPrefs.instance.prefs!;

  List<BankTypeDTO> banks = [];

  final String _bankKey = 'bank_key';

  Future saveBanks(data) async {
    return _box.put(_bankKey, data);
  }

  dynamic getBanks() {
    return _box.get(_bankKey);
  }
}
