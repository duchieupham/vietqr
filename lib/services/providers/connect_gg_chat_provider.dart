import 'package:flutter/cupertino.dart';

class ConnectGgChatProvider extends ChangeNotifier {
  int pageIndex = 0;

  bool isAllLinked = false;
  List<bool> linkedStatus = List.filled(3, false);

  void changeAllValue(bool value){
    isAllLinked = value;
    linkedStatus = List.filled(linkedStatus.length, value);
    notifyListeners();
  }

  void selectValue(bool value, int index){
    isAllLinked = value;

    linkedStatus[index] = value;
    notifyListeners();

  }
}

