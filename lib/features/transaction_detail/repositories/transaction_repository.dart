import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/models/trans/trans_request_dto.dart';
import 'package:vierqr/models/trans_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class TransactionRepository {
  const TransactionRepository(this.appConfig);

  final AppConfig appConfig;

  String get userId => SharePrefUtils().userId;

  Future<List<TransDTO>> getTransStatus(TransactionInputDTO dto) async {
    List<TransDTO> result = [];
    try {
      final String url =
          '${appConfig.getBaseUrl}transactions?bankId=${dto.bankId}&status=${dto.status}&offset=${dto.offset}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data.map<TransDTO>((json) => TransDTO.fromJson(json)).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  // - 9: all
  // - 1: reference_number (mã giao dịch)
  // - 2: order_id
  // - 3: content
  // - 4: terminal code
  // - 5: status
  Future<List<TransDTO>> getTrans(TransactionInputDTO dto) async {
    List<TransDTO> result = [];
    try {
      String userId = SharePrefUtils.getProfile().userId;

      final String url =
          '${appConfig.getBaseUrl}terminal/transactions?terminalCode=${dto.terminalCode}&userId=$userId&bankId=${dto.bankId}&type=${dto.type}&offset=${dto.offset}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data.map<TransDTO>((json) => TransDTO.fromJson(json)).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransDTO>> getTransIsOwner(TransactionInputDTO dto) async {
    List<TransDTO> result = [];
    try {
      final String url =
          '${appConfig.getBaseUrl}transactions/list?bankId=${dto.bankId}&type=${dto.type}&offset=${dto.offset}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data.map<TransDTO>((json) => TransDTO.fromJson(json)).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<TransactionReceiveDTO> getTransactionDetail(String id) async {
    TransactionReceiveDTO result = const TransactionReceiveDTO(
      time: 0,
      timePaid: 0,
      status: 0,
      id: '',
      type: 0,
      content: '',
      bankAccount: '',
      bankAccountName: '',
      bankId: '',
      bankCode: '',
      bankName: '',
      imgId: '',
      amount: '',
      transType: '',
      traceId: '',
      refId: '',
      referenceNumber: '',
      note: '',
      orderId: '',
      terminalCode: '',
      bankShortName: '',
    );
    try {
      final String url = '${appConfig.getBaseUrl}transaction/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = TransactionReceiveDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<dynamic>> loadImage(String transactionId) async {
    List<dynamic> list = [];
    try {
      final String url =
          '${appConfig.getBaseUrl}transaction/image/$transactionId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        list = data.map((job) => job['imgId']).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return list;
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
      final String url = '${appConfig.getBaseUrl}qr/re-generate';
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

  // Future<List<BusinessTransactionDTO>> getTransactionByBranchId(
  //     TransactionBranchInputDTO dto) async {
  //   List<BusinessTransactionDTO> result = [];
  //   try {
  //     final String url = '${appConfig.getBaseUrl}transaction-branch';
  //     final response = await BaseAPIClient.postAPI(
  //       url: url,
  //       body: dto.toJson(),
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       result = data
  //           .map<BusinessTransactionDTO>(
  //               (json) => BusinessTransactionDTO.fromJson(json))
  //           .toList();
  //     }
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  //   return result;
  // }

  Future<ResponseMessageDTO> updateNote(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${appConfig.getBaseUrl}transactions/note';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: param);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  // Future<TerminalDto> getMyListGroup(
  //     String userId, String type, int offset) async {
  //   TerminalDto result = TerminalDto(terminals: []);
  //   try {
  //     final String url =
  //         '${appConfig.getBaseUrl}terminal/bank?userId=$userId&bankId=$type&offset=$offset';
  //     final response = await BaseAPIClient.getAPI(
  //       url: url,
  //       type: AuthenticationType.SYSTEM,
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data != null) {
  //         result = TerminalDto.fromJson(data);
  //       }
  //     }
  //     return result;
  //   } catch (e) {
  //     LOG.error(e.toString());
  //     return result;
  //   }
  // }

  Future<List<TerminalAccountDTO>?> getMyListGroupTrans(
      String userId, String type, int offset) async {
    // TerminalAccountDTO result = TerminalAccountDTO();
    List<TerminalAccountDTO> result = [];
    try {
      final String url =
          '${appConfig.getBaseUrl}account-bank/terminal?bankId=$type&userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<TerminalAccountDTO>(
                  (json) => TerminalAccountDTO.fromJson(json))
              .toList();
        }
      }
      return result;
    } catch (e) {
      LOG.error(e.toString());
      return null;
    }
  }

  Future<ResponseMessageDTO> updateTerminal(
      String transactionId, String terminalCode) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');

    try {
      String url = '${appConfig.getBaseUrl}transaction/map-terminal';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {
          "transactionId": transactionId,
          "terminalCode": terminalCode,
          "userId": userId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<ResponseMessageDTO> transRequest(TransRequest dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${appConfig.getBaseUrl}transaction-request';

      final response = await BaseAPIClient.postAPI(
          url: url,
          type: AuthenticationType.SYSTEM,
          body: {
            'transactionId': dto.transactionId,
            'requestType': dto.requestType,
            'requestValue': dto.terminalCode,
            'userId': userId,
            'terminalId': dto.terminalId,
            'merchantId': dto.merchantId,
          });
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
