import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/theme_dto_local.dart';
import 'package:vierqr/services/local_storage/local_storage.dart';
import 'package:vierqr/services/local_storage/theme_dto_storage.dart';
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

  LocalStorageRepository local = LocalStorageRepository();
  ThemeStorageRepository themLocal = ThemeStorageRepository();

  List<BankTypeDTO> banks = [];

  bool isIntroContact = false;
  ThemeDTOLocal? themesDTO;

  bool getIntroContact() {
    return isIntroContact = _box.get(intro_key) ?? false;
  }

  Future<ThemeDTOLocal?> getThemeDTO() async {
    Box box = await themLocal.openBox(theme_dto_key);
    if (themLocal.getWishlist(box).isNotEmpty) {
      themesDTO = themLocal.getWishlist(box).first;
    }
    return themesDTO;
  }

  Future<void> updateThemeDTO(ThemeDTOLocal value) async {
    Box box = await themLocal.openBox(theme_dto_key);
    await themLocal.removeProductFromWishlist(
        box, themesDTO ?? ThemeDTOLocal());
    await themLocal.addProductToWishlist(box, value);
  }

  Future<List<ThemeDTO>> getTheme() async {
    Box box = await local.openBox(list_theme_key);
    return local.getWishlist(box);
  }

  Future<void> updateTheme(ThemeDTO value) async {
    Box box = await local.openBox(list_theme_key);
    await local.addProductToWishlist(box, value);
  }

  Future<void> updateIntroContact(bool value) async {
    isIntroContact = value;
    await _box.put(intro_key, value);
  }

  void updateBanks(value) {
    banks = value;
  }
}
