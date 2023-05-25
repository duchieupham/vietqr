import 'package:flutter/material.dart';

class AvatarProvider with ChangeNotifier {
  void rebuildAvatar() {
    notifyListeners();
  }
}
