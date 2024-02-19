import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/local_storage/hive_local/local_storage.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => HivePrefs.instance.prefs!;

  Box get _boxBank => HivePrefs.instance.bankPrefs!;

  String get userId => UserHelper.instance.getUserId();

  String get intro_key => '${userId}_card';

  String get list_theme_key => 'list_theme_key';

  String get theme_dto_key => 'theme_dto_key';

  LocalRepository<BankTypeDTO> bankLocal = LocalRepository<BankTypeDTO>();
  LocalRepository<ThemeDTO> themeLocal = LocalRepository<ThemeDTO>();

  List<BankTypeDTO> _banks = [];
  List<ThemeDTO> _themes = [];

  List<BankTypeDTO> get banks => _banks;

  List<ThemeDTO> get themes => _themes;

  bool isIntroContact = false;

  bool getIntroContact() {
    return isIntroContact = _box.get(intro_key) ?? false;
  }

  Future<void> updateIntroContact(bool value) async {
    isIntroContact = value;
    await _box.put(intro_key, value);
  }

  ///bank-local
  Future<List<BankTypeDTO>> getBanks() async {
    if (!UserHelper.instance.getBankTypeKey()) {
      clearBanks();
      return _banks = [];
    }
    _banks = bankLocal.getWishlist(_boxBank);
    for (int i = 0; i < _banks.length; i++) {
      _banks[i].file = await getImageFile(_banks[i].fileImage);
    }
    _banks.sort((a, b) => a.linkType == LinkBankType.LINK ? -1 : 0);
    return _banks;
  }

  Future<void> updateBanks(BankTypeDTO value) async {
    var dto = value.copy;
    await bankLocal.addProductToWishlist(_boxBank, dto);
  }

  setBanks(value) {
    _banks = value;
  }

  clearBanks() {
    bankLocal.clearWishlist(_boxBank);
  }

  ///Theme
  Future<ThemeDTO?> getThemeDTO() async {
    Box box = await themeLocal.openBox(theme_dto_key);
    return themeLocal.getSingleWish(box, userId);
  }

  Future<void> updateThemeDTO(ThemeDTO value) async {
    Box box = await themeLocal.openBox(theme_dto_key);
    var dto = value.copy;
    await themeLocal.removeSingleFromBox(box, userId);
    await themeLocal.addSingleToWishBox(box, dto, userId);
  }

  Future<List<ThemeDTO>> getThemes() async {
    Box box = await themeLocal.openBox(list_theme_key);
    _themes = themeLocal.getWishlist(box);
    for (int i = 0; i < _themes.length; i++) {
      _themes[i].xFile = await getImageFile(_themes[i].file);
    }
    return _themes;
  }

  Future<void> updateThemes(ThemeDTO value) async {
    Box box = await themeLocal.openBox(list_theme_key);
    var dto = value.copy;
    await themeLocal.addProductToWishlist(box, dto);
  }

  Future<void> clearThemes() async {
    Box box = await themeLocal.openBox(list_theme_key);
    await themeLocal.clearWishlist(box);
  }
}
