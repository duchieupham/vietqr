import 'package:hive/hive.dart';

abstract class HiveLocalRepository<T> {
  Future<void> clearWishlist(Box box);

  Future<void> removeItemFromWishlist(Box box, T model);

  Future<void> addProductToWishlist(Box box, T model);

  Future<void> addSingleToWishBox(Box box, T model, String id);

  Future<void> removeSingleFromBox(Box box, String id);

  T? getSingleWish(Box box, String id);

  List<T> getWishlist(Box box);

  Future<Box> openBox(String boxName);
}
