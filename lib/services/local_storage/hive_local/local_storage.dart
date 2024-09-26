import 'package:hive/hive.dart';

import 'hive_local_storage.dart';

class LocalRepository<T> extends HiveLocalRepository<T> {
  Type boxType = T;

  @override
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox<T>(boxName);
    return box;
  }

  @override
  Future<void> addProductToWishlist(Box<dynamic> box, T model) async {
    String key = '${box.name}_${model.hashCode}';
    print(key);
    await box.put(key, model);
  }

  @override
  Future<void> addSingleToWishBox(Box<dynamic> box, T model, String id) async {
    await box.put(id, model);
  }

  @override
  T? getSingleWish(Box<dynamic> box, String id) {
    return box.get(id);
  }

  @override
  List<T> getWishlist(Box<dynamic> box) {
    return box.values.toList() as List<T>;
  }

  @override
  Future<void> removeSingleFromBox(Box<dynamic> box, String id) async {
    await box.delete(id);
  }

  @override
  Future<void> removeItemFromWishlist(Box<dynamic> box, T model) async {
    await box.delete(model.hashCode);
  }

  @override
  Future<void> clearWishlist(Box<dynamic> box) async {
    await box.clear();
  }
}
