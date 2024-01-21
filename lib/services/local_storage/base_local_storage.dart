import 'package:hive/hive.dart';
import 'package:vierqr/models/theme_dto.dart';

abstract class BaseLocalStorageRepository {
  Future<Box> openBox(String boxName);

  List<ThemeDTO> getWishlist(Box box);

  ThemeDTO getThemeDTO(Box box);

  Future<void> addProductToWishlist(Box box, ThemeDTO model);

  Future<void> removeProductFromWishlist(Box box, ThemeDTO model);

  Future<void> clearWishlist(Box box);
}
