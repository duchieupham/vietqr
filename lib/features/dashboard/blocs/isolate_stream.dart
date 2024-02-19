import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:http/http.dart' as http;
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/models/user_repository.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class IsolateStream with BaseManager {
  @override
  final BuildContext context;

  IsolateStream(this.context);

  static void saveImageTask(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<BankTypeDTO> list = args[1];

    for (var message in list) {
      String url = '${EnvConfig.getBaseUrl()}images/${message.imageId}';
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
          if (!path.contains('.png')) {
            path = path + '.png';
          }

          String localPath = await saveImageToLocal(message.data, path);
          dto.fileImage = localPath;
          listSave.add(dto);
        }

        if (message.isDone) {
          listSave.forEach((element) async {
            if (!mounted) return;
            await UserRepository.instance.updateBanks(element);
          });
          receivePort.close();
          if (!mounted) return;
          await UserRepository.instance.getBanks();
          await UserHelper.instance.setBankTypeKey(true);
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
          dto.file = localPath;
          listSave.add(dto);
        }

        if (message.isDone) {
          listSave.forEach((element) async {
            await userRes.updateThemes(element);
          });
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
