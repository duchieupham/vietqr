import 'package:hive/hive.dart';
import 'package:vierqr/models/contact_dto.dart';

import 'base_local_storage.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  Type boxType = ContactDTO;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ContactDTO>(boxName);
    return box;
  }

  @override
  List<ContactDTO> getWishlist(Box box) {
    return box.values.toList() as List<ContactDTO>;
  }

  @override
  Future<void> addProductToWishlist(Box box, ContactDTO model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> removeProductFromWishlist(Box box, ContactDTO model) async {
    await box.delete(model.id);
  }

  @override
  Future<void> clearWishlist(Box box) async {
    await box.clear();
  }
}
