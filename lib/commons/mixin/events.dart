import 'package:event_bus/event_bus.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/models/contact_dto.dart';

EventBus eventBus = EventBus();

class ListenNetworkEvent {
  final TypeInternet type;

  ListenNetworkEvent(this.type);
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

class ReloadContact {
  ReloadContact();
}

class CheckSyncContact {
  CheckSyncContact();
}

class SyncContactEvent {
  final List<ContactDTO> list;

  SyncContactEvent(this.list);
}

class SentDataToContact {
  final List<VCardModel> datas;
  final int length;

  SentDataToContact(this.datas, this.length);
}
