import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

///1. quản lý view chung mà 80% các màn dùng: appbar, dialog confirm, button...
///2 lấy thông tin model chung: user
///3. khi dùng 1 lib 80% chỉ dùng ở đây để sau này lib bị bỏ hoặc lỗi => thay cho dễ
mixin BaseManager {
  BuildContext get context;

  UserRepository get userRes => UserRepository.instance;

  bool get mounted => Navigator.of(context).mounted;

  get alwaysDisabledFocusNode => AlwaysDisabledFocusNode();

  List<BankTypeDTO> get banks => userRes.banks;

  set banks(List<BankTypeDTO> value) => userRes.banks = value;

  String get userId => userRes.userId;

  int get getTypeBankArr =>
      Provider.of<AuthProvider>(context, listen: false).typeBankArr;

  PackageInfo? get packageInfo =>
      Provider.of<AuthProvider>(context, listen: false).packageInfo;
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
