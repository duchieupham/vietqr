import 'package:hive/hive.dart';
import 'package:vierqr/models/contact_dto.dart';

import 'base_local_storage.dart';

class LocalStorageRepository extends BaseLocalStorageRepository {
  Type boxType = ContactDTO;

  static int _pageSize = 20;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<ContactDTO>(boxName);
    return box;
  }

  @override
  List<ContactDTO> getWishlist(Box box,
      {int pageNum = 0, bool isLoadMore = false}) {
    int length = box.length;
    int offset = pageNum * _pageSize;

    var keyFirst;
    var keyLast;

    if (length == 0) {
      return [];
    }

    length = length - offset;
    if (!isLoadMore) {
      if (length < _pageSize) {
        keyFirst = box.keyAt(0);
        keyLast = box.keyAt(length);
      } else {
        keyFirst = box.keyAt(0);
        keyLast = box.keyAt(_pageSize);
      }
    } else {
      if (length > 0) {
        if (length <= 20) {
          keyFirst = box.keyAt(offset);
          keyLast = box.keyAt(offset + length);
        } else {
          keyFirst = box.keyAt(offset);
          keyLast = box.keyAt(offset + _pageSize);
        }
      } else {
        return [];
      }
    }

    return box.valuesBetween(startKey: keyFirst, endKey: keyLast).toList()
        as List<ContactDTO>;

    List<ContactDTO> listBetween = box
        .valuesBetween(startKey: keyFirst, endKey: keyLast)
        .toList() as List<ContactDTO>;
    List<ContactDTO> list = box.values.toList() as List<ContactDTO>;
    return box.values.toList() as List<ContactDTO>;
  }

  @override
  Future<void> addProductToWishlist(Box box, ContactDTO model) async {
    await box.put('${model.id}${DateTime.now().millisecondsSinceEpoch}', model);
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
