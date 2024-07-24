import 'dart:convert';
import 'dart:isolate';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/trans_list_dto.dart';
import 'package:vierqr/models/transaction_log_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class TransactionRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  void networkRequestIsolate(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    List<TransactionItemDTO> list = [];
    await for (var message in receivePort) {
      final data = message[0];
      final SendPort replyPort = message[1];

      try {
        String url = data['url'];
        final response = await BaseAPIClient.getAPI(
          url: url,
          type: AuthenticationType.SYSTEM,
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          list = data
              .map<TransactionItemDTO>(
                  (json) => TransactionItemDTO.fromJson(json))
              .toList();
        }

        replyPort.send(list);
      } catch (e) {
        replyPort.send(list);
      }
    }
  }

  Future<List<TransactionItemDTO>> getListTrans({
    required String bankId,
    required String value,
    required String fromDate,
    required String toDate,
    required int type,
    required int offset,
  }) async {
    List<TransactionItemDTO> list = [];
    try {
      ReceivePort receivePort = ReceivePort();
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}transactions/list/v2?bankId=$bankId&userId=$userId&value=$value&fromDate=$fromDate&toDate=$toDate&type=$type&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        final isolate = await Isolate.spawn(
            parseTransactions, [receivePort.sendPort, response.body]);

        list = await receivePort.first;
        isolate.kill(priority: Isolate.immediate);
      }
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      //   list = data
      //       .map<TransactionItemDTO>(
      //           (json) => TransactionItemDTO.fromJson(json))
      //       .toList();
      // }
    } catch (e) {
      LOG.error(e.toString());
    }
    return list;
  }

  void parseTransactions(List<dynamic> param) {
    SendPort sendPort = param[0];
    final responseBody = param[1];

    try {
      final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
      final transactions = parsed
          .map<TransactionItemDTO>((json) => TransactionItemDTO.fromJson(json))
          .toList();
      sendPort.send(transactions);
    } catch (e) {
      LOG.error('Error parsing transactions: $e');
      sendPort.send([]);
    }
  }

  Future<TransExtraData?> getTransAmount({
    required String bankId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}transaction-extra/v2?bankId=$bankId&userId=$userId&fromDate=$fromDate&toDate=$toDate';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return TransExtraData.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<TransactionItemDetailDTO?> getTransDetail(String id) async {
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}transaction/v2/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return TransactionItemDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<List<TransactionLogDTO>> getTransLog(String id) async {
    List<TransactionLogDTO> result = [];
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}transaction-log/v2/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransactionLogDTO>((json) => TransactionLogDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QRGeneratedDTO> regenerateQR(QRRecreateDTO dto) async {
    QRGeneratedDTO result = QRGeneratedDTO(
      bankId: '',
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}qr/re-generate';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
        result.setBankId(dto.bankId);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
