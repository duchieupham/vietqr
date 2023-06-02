// import 'dart:async';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:vierqr/models/bank_account_dto.dart';

// /// Tuyệt đối không được dùng box.clear()
// /// vì nó sẽ xoá toàn bộ dữ liệu local app
// /// nếu muốn xoá dữ liệu nào đó dùng methob: box.delete(key cần xoá);

// class SharedPrefs {
//   static final SharedPrefs _instance = SharedPrefs._internal();

//   SharedPrefsKey get keys => SharedPrefsKey.instance;
//   Box? prefs;

//   SharedPrefs._internal();

//   bool _initEd = false;

//   static SharedPrefs get instance => _instance;

//   Future<SharedPrefs> init() async {
//     Completer<SharedPrefs> completer = Completer<SharedPrefs>();
//     if (_initEd) {
//       completer.complete(_instance);
//     } else {
//       await Hive.initFlutter();
//       prefs = await Hive.openBox(keys.prefKey);
//       _initEd = true;
//       completer.complete(_instance);
//     }
//     return completer.future;
//   }
// }

// class SharedPrefsKey {
//   static final SharedPrefsKey _instance = SharedPrefsKey._internal();

//   SharedPrefsKey._internal();

//   static SharedPrefsKey get instance => _instance;

//   String get bankKey => 'bankKey';

//   String get prefKey => "pref_key";
// }
