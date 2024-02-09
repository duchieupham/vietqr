import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/main.dart';

import 'network_event.dart';
import 'network_helper.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkNone()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  bool get mounted =>
      NavigationService.navigatorKey.currentContext?.mounted ?? false;

  void _observe(event, emit) {
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotify event, emit) async {
    if (event.result == TypeInternet.DISCONNECT) {
      emit(NetworkFailure());
    } else if (event.result == TypeInternet.CONNECT) {
      emit(NetworkSuccess());
    } else {
      emit(NetworkNone());
    }
  }
}
