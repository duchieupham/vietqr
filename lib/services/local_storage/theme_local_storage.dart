import 'package:hive/hive.dart';
import 'package:vierqr/models/theme_dto.dart';

import 'hive_local_storage.dart';

class ThemeDTORepository extends HiveLocalRepository<ThemeDTO> {
  Type boxType = ThemeDTO;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ThemeDTO>(boxName);
    return box;
  }

  @override
  Future<void> addProductToWishlist(Box<dynamic> box, ThemeDTO model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> addSingleToWishBox(
      Box<dynamic> box, ThemeDTO model, String id) async {
    await box.put(id, model);
  }

  @override
  ThemeDTO? getSingleWish(Box<dynamic> box, String id) {
    return box.get(id);
  }

  @override
  List<ThemeDTO> getWishlist(Box<dynamic> box) {
    return box.values.toList() as List<ThemeDTO>;
  }

  @override
  Future<void> removeSingleFromBox(Box<dynamic> box, String id) async {
    await box.delete(id);
  }

  @override
  Future<void> removeItemFromWishlist(Box<dynamic> box, ThemeDTO model) async {
    await box.delete(model.id);
  }

  @override
  Future<void> clearWishlist(Box<dynamic> box) async {
    await box.clear();
  }
}
