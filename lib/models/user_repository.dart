import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/extensions/string_extension.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/local_storage/hive_local/local_storage.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get instance => _instance;

  Box get _box => HivePrefs.instance.prefs!;

  Box get _boxBank => HivePrefs.instance.bankPrefs!;

  String get userId => SharePrefUtils.getProfile().userId;

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
    if (!SharePrefUtils.getBankType()) {
      clearBanks();
      return _banks = [];
    }
    _banks = await SharePrefUtils.getBanks() ?? [];
    for (var bank in banks) bank.fileBank = await bank.photoPath.getImageFile;

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
  Future<ThemeDTO?> getSingleTheme() async {
    return SharePrefUtils.getSingleTheme();
  }

  Future<void> saveSingleTheme(ThemeDTO value) async {
    await SharePrefUtils.saveSingleTheme(value);
  }

  clearThemeDTO() async {
    Box box = await themeLocal.openBox(theme_dto_key);
    themeLocal.clearWishlist(box);
  }

  Future<List<ThemeDTO>> getThemes() async {
    _themes = await SharePrefUtils.getThemes() ?? [];
    if (themes.isEmpty) return [];

    for (var theme in themes) theme.xFile = await theme.photoPath.getImageFile;
    return _themes;
  }

  Future<void> clearThemes() async {
    await SharePrefUtils.removeThemes();
  }
}
