import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity connectivity;

  NetworkBloc({required this.connectivity})
      : super(NetworkNone(isInternet: false)) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _observe(event, emit) {
    connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _notifyStatus(NetworkNotify event, emit) async {
    if (event.result == TypeInternet.DISCONNECT) {
      emit(NetworkFailure(state: state, isInternet: event.isInternet));
    } else if (event.result == TypeInternet.CONNECT) {
      //sau khi có kết nối => hiện thông báo => sau 3 giây chuyển status thành none để tắt
      emit(NetworkSuccess(state: state, isInternet: event.isInternet));
      await Future.delayed(Duration(seconds: 3)).then((v) {
        this.add(NetworkNotify(
          result: TypeInternet.NONE,
          isInternet: true,
        ));
      });
    } else {
      emit(NetworkNone(isInternet: event.isInternet));
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      final result2 = await connectivity.checkConnectivity();
      if (result2 == ConnectivityResult.none) {
        this.add(NetworkNotify(
          result: TypeInternet.DISCONNECT,
          isInternet: true,
        ));
      } else {
        checkConnection();
      }
    } else {
      checkConnection();
    }
  }

  Future checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this.add(NetworkNotify(
          result: TypeInternet.CONNECT,
          isInternet: false,
        ));
      } else {
        this.add(NetworkNotify(
          result: TypeInternet.DISCONNECT,
          isInternet: true,
        ));
      }
    } on SocketException catch (_) {
      this.add(NetworkNotify(
        result: TypeInternet.DISCONNECT,
        isInternet: true,
      ));
    }
  }
}
