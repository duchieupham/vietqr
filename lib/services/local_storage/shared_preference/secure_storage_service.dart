import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'i_shared_local.dart';

class SecureStorageService<T> extends IStorageService<T> {
  SecureStorageService(key) : super(key);

  @override
  Future<void> set({
    required T data,
  }) async {
    const storage = FlutterSecureStorage();
    if (data is String) {
      return storage.write(
        key: key,
        value: data,
      );
    }

    return storage.write(
      key: key,
      value: json.encode(data),
    );
  }

  @override
  Future<List<T>?> getList({
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    const storage = FlutterSecureStorage();
    final dataStr = await storage.read(key: key);
    if (dataStr == null) {
      return null;
    }
    try {
      return (json.decode(dataStr) as List<dynamic>)
          .map((item) => fromJson(item))
          .toList();
    } catch (err) {
      return null;
    }
  }

  @override
  Future<bool> remove() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
    return true;
  }

  @override
  Future<T?> getStorage({T Function(Map<String, dynamic> p1)? fromJson}) async {
    const storage = FlutterSecureStorage();
    final dataStr = await storage.read(key: key);
    if (dataStr == null) {
      return null;
    }
    if (fromJson == null) {
      return dataStr as T;
    }
    try {
      final data = fromJson(json.decode(dataStr));
      return data;
    } catch (err) {
      return null;
    }
  }

  @override
  T? get({required T Function(Map<String, dynamic> p1) fromJson}) {
    // TODO: implement get
    throw UnimplementedError();
  }
  
  @override
  List<T>? getListNoFuture({required T Function(Map<String, dynamic> p1) fromJson}) {
    // TODO: implement getListNoFuture
    throw UnimplementedError();
  }
}
