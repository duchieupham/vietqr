import 'package:hive/hive.dart';
import 'package:vierqr/models/theme_dto.dart';

import 'base_local_storage.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  Type boxType = ThemeDTO;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ThemeDTO>(boxName);
    return box;
  }

  @override
  List<ThemeDTO> getWishlist(Box box) {
    return box.values.toList() as List<ThemeDTO>;
  }

  @override
  Future<void> addProductToWishlist(Box box, ThemeDTO model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> removeProductFromWishlist(Box box, ThemeDTO model) async {
    await box.delete(model.id);
  }

  @override
  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }

  @override
  ThemeDTO getThemeDTO(Box<dynamic> box) {
    // TODO: implement getThemeDTO
    throw UnimplementedError();
  }
}
