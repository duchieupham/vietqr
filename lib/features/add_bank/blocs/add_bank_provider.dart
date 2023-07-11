import 'package:flutter/material.dart';

class AddBankProvider with ChangeNotifier {
  final bankAccountController = TextEditingController();

  final nameController = TextEditingController();

  void onChangeName(String value) {}

  void onChangeAccount(String value) {}

  void _listenerAccount() {}
}
