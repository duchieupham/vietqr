import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/local_storage/local_storage.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => HivePrefs.instance.prefs!;

  String get userId => UserInformationHelper.instance.getUserId();

  String get intro_key => '${userId}_card';

  String get list_theme_key => 'list_theme_key';

  String get theme_dto_key => 'theme_dto_key';

  ThemeDTORepository local = ThemeDTORepository();
  List<BankTypeDTO> banks = [];

  bool isIntroContact = false;

  bool getIntroContact() {
    return isIntroContact = _box.get(intro_key) ?? false;
  }

  Future<void> updateIntroContact(bool value) async {
    isIntroContact = value;
    await _box.put(intro_key, value);
  }

  Future<ThemeDTO?> getThemeDTO() async {
    Box box = await local.openBox(theme_dto_key);
    return local.getSingleWish(box, userId);
  }

  Future<void> updateThemeDTO(ThemeDTO value) async {
    Box box = await local.openBox(theme_dto_key);
    var dto = value.copy;
    await local.removeSingleFromBox(box, userId);
    await local.addSingleToWishBox(box, dto, userId);
  }

  Future<List<ThemeDTO>> getThemes() async {
    Box box = await local.openBox(list_theme_key);
    return local.getWishlist(box);
  }

  Future<void> updateThemes(ThemeDTO value) async {
    Box box = await local.openBox(list_theme_key);
    var dto = value.copy;
    await local.addProductToWishlist(box, dto);
  }
}
