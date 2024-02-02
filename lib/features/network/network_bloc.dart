import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/main.dart';

import 'network_event.dart';
import 'network_helper.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
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
    if (event.isFirst) {
      if (event.result != ConnectivityResult.none) {
        emit(NetworkNone());
      } else {
        emit(NetworkFailure());
      }

      await Future.delayed(const Duration(seconds: 5), () {
        if (mounted) emit(NetworkNone());
      });
      return;
    }

    if (event.result == ConnectivityResult.none) {
      emit(NetworkFailure());
    } else {
      emit(NetworkSuccess());
    }

    await Future.delayed(const Duration(seconds: 5), () {
      if (mounted) emit(NetworkNone());
    });
  }
}
