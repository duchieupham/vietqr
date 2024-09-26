// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:vierqr/commons/utils/pref_utils.dart';
// import 'package:vierqr/models/bank_type_dto.dart';
// import 'package:vierqr/models/theme_dto.dart';
//
// import 'local_storage.dart';
//
// class HiveUtils {
//   static final HiveUtils _instance = HiveUtils._internal();
//
//   HiveUtils._internal();
//
//   static HiveUtils get instance => _instance;
//
//   static final _bankLocal = LocalRepository<BankTypeDTO>();
//   static final _themeLocal = LocalRepository<ThemeDTO>();
//
//   Box get _boxBank => HivePrefs.instance.bankPrefs!;
//
//   String get list_theme_key => 'list_theme_key';
//
//   String get theme_dto_key => 'theme_dto_key';
//
//   ///bank-local
//   static List<BankTypeDTO> getBanks() {
//     return _bankLocal.getWishlist(_boxBank);
//   }
//
//   static Future<void> updateBanks(BankTypeDTO value) async {
//     Box box = await _bankLocal.openBox(theme_dto_key);
//     var dto = value.copy;
//     await _bankLocal.addProductToWishlist(_boxBank, dto);
//   }
//
//   ///Theme
//   static Future<ThemeDTO?> getThemeDTO() async {
//     Box box = await _themeLocal.openBox(theme_dto_key);
//     return _themeLocal.getSingleWish(box, userId);
//   }
//
//   static Future<void> updateThemeDTO(ThemeDTO value) async {
//     Box box = await _themeLocal.openBox(theme_dto_key);
//     var dto = value.copy;
//     await _themeLocal.removeSingleFromBox(box, userId);
//     await _themeLocal.addSingleToWishBox(box, dto, userId);
//   }
//
//   static Future<List<ThemeDTO>> getThemes() async {
//     Box box = await _themeLocal.openBox(list_theme_key);
//     return _themeLocal.getWishlist(box);
//   }
//
//   static Future<void> updateThemes(ThemeDTO value) async {
//     Box box = await _themeLocal.openBox(list_theme_key);
//     var dto = value.copy;
//     await _themeLocal.addProductToWishlist(box, dto);
//   }
// }
