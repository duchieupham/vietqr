import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/local_storage/hive_local/local_storage.dart';

/// Tuyệt đối không được dùng box.clear()
/// vì nó sẽ xoá toàn bộ dữ liệu local app
/// nếu muốn xoá dữ liệu nào đó dùng methob: box.delete(key cần xoá);

class HivePrefs {
  static final HivePrefs _instance = HivePrefs._internal();

  SharedPrefsKey get keys => SharedPrefsKey.instance;
  Box? prefs;
  Box? bankPrefs;

  HivePrefs._internal();

  bool _initEd = false;

  static HivePrefs get instance => _instance;

  Future<HivePrefs> init() async {
    Completer<HivePrefs> completer = Completer<HivePrefs>();
    if (_initEd) {
      completer.complete(_instance);
    } else {
      Hive.registerAdapter(ThemeDTOAdapter());
      Hive.registerAdapter(BankTypeDTOAdapter());
      await Hive.initFlutter();
      prefs = await Hive.openBox(keys.prefKey);
      bankPrefs = await LocalRepository<BankTypeDTO>().openBox(keys.bankKey);
      _initEd = true;
      completer.complete(_instance);
    }
    return completer.future;
  }
}

class SharedPrefsKey {
  static final SharedPrefsKey _instance = SharedPrefsKey._internal();

  SharedPrefsKey._internal();

  static SharedPrefsKey get instance => _instance;

  String get bankKey => 'bank_key';

  String get prefKey => "pref_key";

  String get vCardKey => "vcard_key";
}
