import 'package:hive/hive.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/theme_dto_local.dart';

class ThemeStorageRepository {
  Type boxType = ThemeDTOLocal;

  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ThemeDTOLocal>(boxName);
    return box;
  }

  List<ThemeDTOLocal> getWishlist(Box box, String userId) {
    return box.values.toList() as List<ThemeDTOLocal>;
  }

  ThemeDTOLocal? getWishTheme(Box box, String userId) {
    print(box.containsKey(userId));
    return box.get(userId);
  }

  Future<void> addProductToWishlist(
      Box box, ThemeDTOLocal model, String userId) async {
    await box.put(userId, model);
  }

  Future<void> removeProductFromWishlist(Box box, String userId) async {
    await box.delete(userId);
  }

  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }

  ThemeDTO getThemeDTO(Box<dynamic> box) {
    return box.values as ThemeDTO;
  }
}
