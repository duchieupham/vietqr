import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';

///1. quản lý view chung mà 80% các màn dùng: appbar, dialog confirm, button...
///2 lấy thông tin model chung: user
///3. khi dùng 1 lib 80% chỉ dùng ở đây để sau này lib bị bỏ hoặc lỗi => thay cho dễ
mixin BaseManager {
  BuildContext get context;

  UserRepository get userRes => UserRepository.instance;

  bool get mounted => Navigator.of(context).mounted;

  get alwaysDisabledFocusNode => AlwaysDisabledFocusNode();

  List<BankTypeDTO> get banks => userRes.banks;

  List<ThemeDTO> get themes => userRes.themes;

  set banks(List<BankTypeDTO> value) => userRes.setBanks(value);

  String get userId => userRes.userId;

  PackageInfo? get packageInfo =>
      Provider.of<AuthProvider>(context, listen: false).packageInfo;
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
