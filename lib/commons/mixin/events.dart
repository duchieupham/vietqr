import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

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

class ReloadContact {
  ReloadContact();
}

class CheckSyncContact {
  CheckSyncContact();
}
