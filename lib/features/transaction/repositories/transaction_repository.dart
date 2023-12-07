import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/qr_recreate_dto.dart';
import 'package:vierqr/models/related_transaction_receive_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';
import 'package:vierqr/models/transaction_input_dto.dart';
import 'package:vierqr/models/transaction_receive_dto.dart';

class TransactionRepository {
  const TransactionRepository();

  Future<List<RelatedTransactionReceiveDTO>> getTransStatus(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions?bankId=${dto.bankId}&status=${dto.status}&offset=${dto.offset}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<RelatedTransactionReceiveDTO>(
                (json) => RelatedTransactionReceiveDTO.fromJson(json))
            .toList();
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
  Future<List<RelatedTransactionReceiveDTO>> getTrans(
      TransactionInputDTO dto) async {
    List<RelatedTransactionReceiveDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transactions/list?bankId=${dto.bankId}&type=${dto.type}&offset=${dto.offset}&value=${dto.value}&from=${dto.from}&to=${dto.to}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<RelatedTransactionReceiveDTO>(
                (json) => RelatedTransactionReceiveDTO.fromJson(json))
            .toList();
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
      amount: 0,
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
      final String url = '${EnvConfig.getBaseUrl()}transaction/$id';
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
          '${EnvConfig.getBaseUrl()}transaction/image/$transactionId';
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
      final String url = '${EnvConfig.getBaseUrl()}qr/re-generate';
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

  Future<List<BusinessTransactionDTO>> getTransactionByBranchId(
      TransactionBranchInputDTO dto) async {
    List<BusinessTransactionDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}transaction-branch';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessTransactionDTO>(
                (json) => BusinessTransactionDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> updateNote(Map<String, dynamic> param) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}transactions/note';
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
}
