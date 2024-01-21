import 'package:hive/hive.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/theme_dto_local.dart';

import 'base_local_storage.dart';

class ThemeStorageRepository {
  Type boxType = ThemeDTOLocal;

  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ThemeDTOLocal>(boxName);
    return box;
  }

  List<ThemeDTOLocal> getWishlist(Box box) {
    return box.values.toList() as List<ThemeDTOLocal>;
  }

  Future<void> addProductToWishlist(Box box, ThemeDTOLocal model) async {
    await box.put(model.id, model);
  }

  Future<void> removeProductFromWishlist(Box box, ThemeDTOLocal model) async {
    await box.deleteAll(box.keys);
  }

  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }

  ThemeDTO getThemeDTO(Box<dynamic> box) {
    return box.values as ThemeDTO;
  }
}
