import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/helper/media_helper.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/layouts/bottom_sheet/notify_trans_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/notify_trans_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  static SocketService get instance => _instance;

  static late WebSocketChannel _channelTransaction;

  WebSocketChannel get channelTransaction => _channelTransaction;

  String get userId => SharePrefUtils().userId;

  BuildContext get context => NavigationService.navigatorKey.currentContext!;

  static int _port = 8443;

  Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Socket? get socket => _socket;

  void init() {
    if (userId.isEmpty) return;
    Uri wsUrl = Uri.parse('wss://dev.vietqr.org/vqr/socket?userId=$userId');

    _channelTransaction = WebSocketChannel.connect(wsUrl);

    if (_channelTransaction.closeCode == null) {
      _channelTransaction.stream.listen((event) async {
        var data = jsonDecode(event);

        if (_isConnected) {
          _isConnected = false;
          Navigator.pop(context);
        }

        if (data['notificationType'] != null &&
            data['notificationType'] ==
                Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
          print('---------kaka $data');

          DialogWidget.instance.showModelBottomSheet(
            isDismissible: true,
            margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            height: MediaQuery.of(context).size.height * 0.9,
            borderRadius: BorderRadius.circular(16),
            widget: NotifyTransWidget(
              dto: NotifyTransDTO.fromJson(data),
            ),
          );
          MediaHelper.instance.playAudio(data);
        }
        notificationController.sink.add(true);
      });
    }
  }

  void updateConnect(bool value) {
    _isConnected = value;
  }

  void closeListenTransaction() {
    _channelTransaction.sink.close();
  }
}
