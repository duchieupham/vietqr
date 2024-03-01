import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'i_shared_local.dart';

class SecureStorageService<T> extends IStorageService<T> {
  SecureStorageService(key) : super(key);

  Future<void> set({
    required T data,
  }) async {
    final storage = new FlutterSecureStorage();
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
    final storage = new FlutterSecureStorage();
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

  Future<bool> remove() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: key);
    return true;
  }

  Future<T?> getStorage({T Function(Map<String, dynamic> p1)? fromJson}) async {
    final storage = new FlutterSecureStorage();
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
}
