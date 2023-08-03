import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ChangeThemeEvent {
  ChangeThemeEvent();
}

class ChangeBottomBarEvent {
  final int page;

  ChangeBottomBarEvent(this.page);
}

class GetListBankScreen {
  GetListBankScreen();
}

class ReloadWallet {
  ReloadWallet();
}
