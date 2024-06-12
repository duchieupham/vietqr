import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/configurations/stringify.dart'
as Constants;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class IsolateStream with BaseManager {
  @override
  final BuildContext context;

  IsolateStream(this.context);

  static void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<BankTypeDTO> list = args[1];

    for (var message in list) {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}images/${message.imageId}';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      sendPort.send(ReceiverData(data: bytes, index: list.indexOf(message)));
    }
    sendPort.send(ReceiverData(data: Uint8List(0), isDone: true));
  }

  void saveBankReceiver(List<BankTypeDTO> list) async {
    List<BankTypeDTO> listSave = [];
    final receivePort = ReceivePort();
    Isolate.spawn(saveImageTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is ReceiverData) {
        if (message.index != null) {
          BankTypeDTO dto = list[message.index!];

          String path = dto.imageId;
          for (var type in Constants.PictureType.values) {
            if (!path.contains(type.pictureValue)) {
              path += type.pictureValue;
              break;
            }
          }

          String localPath = await saveImageToLocal(message.data, path);
          dto.photoPath = localPath;
          listSave.add(dto);
        }

        if (message.isDone) {
          if (!mounted) return;
          await SharePrefUtils.saveBanks(listSave);
          receivePort.close();
          await UserRepository.instance.getBanks();
          await SharePrefUtils.saveBankType(true);
          return;
        }
      }
    }
  }

  static void saveThemeTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<ThemeDTO> list = args[1];

    for (var message in list) {
      final response = await http.get(Uri.parse(message.imgUrl));
      final bytes = response.bodyBytes;
      sendPort.send(ReceiverData(data: bytes, index: list.indexOf(message)));
    }
    sendPort.send(ReceiverData(data: Uint8List(0), isDone: true));
  }

  Future<List<ThemeDTO>> saveThemeReceiver(List<ThemeDTO> list) async {
    List<ThemeDTO> listSave = [];
    final receivePort = ReceivePort();
    Isolate.spawn(saveThemeTask, [receivePort.sendPort, list]);
    await for (var message in receivePort) {
      if (message is ReceiverData) {
        if (message.index != null) {
          ThemeDTO dto = list[message.index!];

          String path = dto.imgUrl.split('/').last;
          if (path.contains('.png')) {
            path.replaceAll('.png', '');
          }

          String localPath = await saveImageToLocal(message.data, path);
          dto.photoPath = localPath;
          listSave.add(dto);
        }

        if (message.isDone) {
          await SharePrefUtils.saveThemes(listSave);
          receivePort.close();
          if (!mounted) return [];
          return await userRes.getThemes();
        }
      }
    }
    return listSave;
  }
}

class ReceiverData {
  ReceiverData({required this.data, this.index, this.isDone = false});

  Uint8List data;
  int? index;
  bool isDone;
}
