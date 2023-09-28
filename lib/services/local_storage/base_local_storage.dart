import 'package:hive/hive.dart';
import 'package:vierqr/models/contact_dto.dart';

abstract class BaseLocalStorageRepository {
  Future<Box> openBox(String boxName);

  List<ContactDTO> getWishlist(Box box);

  Future<void> addProductToWishlist(Box box, ContactDTO model);

  Future<void> removeProductFromWishlist(Box box, ContactDTO model);

  Future<void> clearWishlist(Box box);
}
