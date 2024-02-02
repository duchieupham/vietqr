import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vierqr/main.dart';

import 'i_shared_local.dart';

class SharedPrefLocal<T> extends IStorageService<T> {
  SharedPrefLocal(key) : super(key);

  Future<void> set({required T data}) async {
    if (T == bool) {
      sharedPrefs.setBool(key, data as bool);
      return;
    }
    if (T == int) {
      sharedPrefs.setInt(key, data as int);
      return;
    }
    if (T == double) {
      sharedPrefs.setDouble(key, data as double);
      return;
    }
    if (T == String) {
      sharedPrefs.setString(key, data as String);
      return;
    }
    sharedPrefs.setString(key, json.encode(data));
  }

  Future<T?> get({
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (T == bool) {
      final dataBool = sharedPrefs.getBool(key);
      return dataBool as T?;
    }
    if (T == int) {
      final dataInt = sharedPrefs.getInt(key);
      return dataInt as T?;
    }
    if (T == double) {
      final dataDouble = sharedPrefs.getDouble(key);
      return dataDouble as T?;
    }
    final dataStr = sharedPrefs.getString(key);
    if (dataStr == null) {
      return null;
    }
    if (T == String || fromJson == null) {
      return dataStr as T?;
    }
    try {
      final data = fromJson(json.decode(dataStr));
      return data;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<List<T>?> getList({
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final dataStr = sharedPrefs.getString(key);
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
    return sharedPrefs.remove(key);
  }
}
